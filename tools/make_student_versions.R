# tools/make_student_versions.R
# ------------------------------------------------------------
# Generate student versions of Quarto (.qmd) files by
# transforming code chunks labeled exercise-* into
# fill-in-the-blank scaffolds using ___
#
# Usage (from repo root):
#   Rscript tools/make_student_versions.R
# ------------------------------------------------------------

suppressWarnings({
  if (!requireNamespace("stringr", quietly = TRUE)) install.packages("stringr")
  if (!requireNamespace("fs", quietly = TRUE)) install.packages("fs")
})

library(stringr)
library(fs)

IN_DIR  <- "instructor"
OUT_DIR <- "student"

# ------------------------------------------------------------
# CONFIGURATION
# ------------------------------------------------------------

# Add a short student notice after YAML (recommended)
ADD_STUDENT_HEADER <- TRUE

STUDENT_HEADER <- c(
  "",
  "> **Student version**",
  "> Code chunks marked as exercises are intentionally incomplete.",
  "> Replace `___` with valid R code before running.",
  ""
)

# Words that should NEVER be blanked
KEEP_WORDS <- c(
  # R constants / keywords
  "TRUE","FALSE","NULL","NA","NaN","Inf",
  "if","else","for","in","while","repeat","break","next","return","function",
  
  # Common base R verbs
  "c","sum","mean","sd","min","max","length","str","head","tail","class","print",
  "exp","log","sqrt","abs","sort","order","rank","set.seed","runif","ceiling",
  "seq","rep","rm",
  
  # Data inspection
  "library","require","glimpse","skim","View",
  
  # Pipes
  "%>%","|>",
  
  # dplyr verbs
  "select","filter","mutate","summarise","summarize","arrange","group_by",
  "left_join","right_join","inner_join","full_join",
  
  # Modeling
  "lm","glm"
)

# Keep left-hand-side object names (x <- ___)
KEEP_LHS_ASSIGNMENT_NAMES <- TRUE

# ------------------------------------------------------------
# HELPERS
# ------------------------------------------------------------

is_exercise_header <- function(line) {
  str_detect(line, "^```\\s*\\{\\s*r\\b") && str_detect(line, "exercise-")
}

blank_line_tokens <- function(line) {
  
  if (str_trim(line) == "") return(line)
  if (str_detect(str_trim(line), "^#")) return(line)
  if (str_detect(str_trim(line), "^#\\|")) return(line)
  
  protected <- list()
  
  protect_functions <- function(text) {
    m <- str_match_all(text, "([A-Za-z.][A-Za-z0-9._]*)\\b(?=\\s*\\()")[[1]]
    if (nrow(m) == 0) return(text)
    for (i in seq_len(nrow(m))) {
      fn <- m[i,2]
      key <- paste0("<<FN", length(protected)+1, ">>")
      protected[[key]] <<- fn
      text <- str_replace(text, paste0("\\b", fn, "\\b(?=\\s*\\()"), key)
    }
    text
  }
  
  line2 <- protect_functions(line)
  
  for (w in KEEP_WORDS) {
    w2 <- str_replace_all(w, "\\.", "\\\\.")
    line2 <- str_replace_all(line2, paste0("\\b", w2, "\\b"), paste0("<<KEEP:", w, ">>"))
  }
  
  if (KEEP_LHS_ASSIGNMENT_NAMES) {
    line2 <- str_replace(
      line2,
      "^(\\s*)([A-Za-z.][A-Za-z0-9._]*)\\s*(<-|=)",
      "\\1<<LHS:\\2>> \\3"
    )
  }
  
  line2 <- str_replace_all(line2, "(?<![A-Za-z0-9._])\\d+(?:\\.\\d+)?(?![A-Za-z0-9._])", "___")
  line2 <- str_replace_all(line2, "\\b([A-Za-z.][A-Za-z0-9._]*)\\b", "___")
  
  line2 <- str_replace_all(line2, "<<LHS:([^>]+)>>", "\\1")
  line2 <- str_replace_all(line2, "<<KEEP:([^>]+)>>", "\\1")
  
  for (k in names(protected)) {
    line2 <- str_replace_all(line2, fixed(k), protected[[k]])
  }
  
  line2 <- str_replace_all(line2, "___\\s*___", "___")
  line2
}

transform_exercise_chunk <- function(lines) {
  vapply(lines, blank_line_tokens, character(1))
}

# ------------------------------------------------------------
# FILE TRANSFORM
# ------------------------------------------------------------

transform_qmd <- function(lines) {
  
  out <- character(0)
  
  if (ADD_STUDENT_HEADER) {
    if (length(lines) > 0 && str_trim(lines[1]) == "---") {
      idx <- which(str_trim(lines) == "---")
      if (length(idx) >= 2) {
        out <- c(lines[1:idx[2]], STUDENT_HEADER)
        lines <- lines[(idx[2]+1):length(lines)]
      }
    } else {
      out <- c(out, STUDENT_HEADER)
    }
  }
  
  in_chunk <- FALSE
  exercise <- FALSE
  chunk <- character(0)
  
  for (line in lines) {
    
    if (!in_chunk && str_detect(line, "^```\\s*\\{\\s*r")) {
      in_chunk <- TRUE
      exercise <- is_exercise_header(line)
      out <- c(out, line)
      chunk <- character(0)
      next
    }
    
    if (in_chunk && str_detect(line, "^```\\s*$")) {
      if (exercise) chunk <- transform_exercise_chunk(chunk)
      out <- c(out, chunk, line)
      in_chunk <- FALSE
      exercise <- FALSE
      next
    }
    
    if (in_chunk) {
      chunk <- c(chunk, line)
    } else {
      out <- c(out, line)
    }
  }
  
  out
}

# ------------------------------------------------------------
# RUN
# ------------------------------------------------------------

dir_create(OUT_DIR)

files <- dir_ls(IN_DIR, glob = "*.qmd", recurse = TRUE)
if (length(files) == 0) stop("No .qmd files found in instructor/")

for (f in files) {
  rel <- path_rel(f, start = IN_DIR)
  out_path <- path(OUT_DIR, rel)
  dir_create(path_dir(out_path))
  
  lines <- readLines(f, warn = FALSE)
  new_lines <- transform_qmd(lines)
  
  writeLines(new_lines, out_path, useBytes = TRUE)
  message("Generated: ", out_path)
}

message("Done. Student files written to /student/")
