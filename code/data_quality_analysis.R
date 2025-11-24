# BSK15 - COMP 331 – Final Project 
# Data Quality & Bias Analysis - R script
# This script:
#   - loads the UCI Student Performance Math & Portuguese datasets
#   - checks completeness, consistency/uniqueness, representativeness
#   - creates summary tables and plots used in the report

# ---- Libraries ----
library(dplyr)
library(ggplot2)

# ---- Paths & setup ----
data_path_mat <- "student-mat.csv"
data_path_por <- "student-por.csv"
results_dir   <- "results"

if (!dir.exists(results_dir)) {
  dir.create(results_dir)
}

# ---- Load data ----
mat <- read.csv(data_path_mat, stringsAsFactors = FALSE)
por <- read.csv(data_path_por, stringsAsFactors = FALSE)

# ---- 1. Completeness checks ----

# 1a) basic row counts
count_summary <- data.frame(
  dataset = c("Math", "Portuguese"),
  n_rows  = c(nrow(mat), nrow(por))
)

write.csv(count_summary,
          file = file.path(results_dir, "row_counts.csv"),
          row.names = FALSE)

# 1b) missing values per column
missing_mat <- sapply(mat, function(x) sum(is.na(x)))
missing_por <- sapply(por, function(x) sum(is.na(x)))

missing_summary <- data.frame(
  variable = names(missing_mat),
  math_missing = as.integer(missing_mat),
  portug_missing = as.integer(missing_por)
)

write.csv(missing_summary,
          file = file.path(results_dir, "missing_summary.csv"),
          row.names = FALSE)

# ---- 2. Consistency & uniqueness: overlap between files ----

# Merge key recommended for the UCI student dataset
merge_key <- c(
  "school", "sex", "age", "address", "famsize", "Pstatus",
  "Medu", "Fedu", "Mjob", "Fjob",
  "reason", "guardian",
  "traveltime", "studytime", "failures",
  "schoolsup", "famsup", "paid", "activities",
  "nursery", "higher", "internet", "romantic"
)

# Inner join = students that appear in BOTH subjects
both <- dplyr::inner_join(
  mat,
  por,
  by = merge_key,
  suffix = c("_mat", "_por")
)

# Simple counts for report
overlap_summary <- data.frame(
  description = c("Math total", "Portuguese total", "Overlap (both subjects)"),
  n_students  = c(nrow(mat), nrow(por), nrow(both))
)

write.csv(overlap_summary,
          file = file.path(results_dir, "overlap_counts.csv"),
          row.names = FALSE)

# ---- 3. Grade distributions (G3) ----

grades_long <- bind_rows(
  mat %>% select(G3) %>% mutate(subject = "Math"),
  por %>% select(G3) %>% mutate(subject = "Portuguese")
)

# 3a) Histogram of final grades by subject
p_hist <- ggplot(grades_long, aes(x = G3, fill = subject)) +
  geom_histogram(binwidth = 1, position = "identity", alpha = 0.5) +
  scale_x_continuous(breaks = 0:20) +
  labs(
    title = "Final Grade (G3) Distribution by Subject",
    x = "Final grade (G3)",
    y = "Count",
    fill = "Subject"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(results_dir, "g3_hist_by_subject.png"),
  plot = p_hist,
  width = 7, height = 4, dpi = 300
)

# 3b) Boxplot of G3 by subject
p_box <- ggplot(grades_long, aes(x = subject, y = G3)) +
  geom_boxplot(outlier.alpha = 0.6) +
  labs(
    title = "Final Grade (G3) Comparison",
    x = "Subject",
    y = "Final grade (G3)"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(results_dir, "g3_boxplot_by_subject.png"),
  plot = p_box,
  width = 5, height = 4, dpi = 300
)

# ---- 4. Absences vs Final Grade ----

absences_long <- bind_rows(
  mat %>% select(absences, G3) %>% mutate(subject = "Math"),
  por %>% select(absences, G3) %>% mutate(subject = "Portuguese")
)

p_abs <- ggplot(absences_long, aes(x = absences, y = G3, colour = subject)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "loess", se = FALSE) +
  labs(
    title = "Absences vs Final Grade (G3)",
    x = "Number of absences",
    y = "Final grade (G3)",
    colour = "Subject"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(results_dir, "absences_vs_g3.png"),
  plot = p_abs,
  width = 7, height = 4, dpi = 300
)

# ---- 5. Simple text summary for representativeness ----
# (not required, but nice to have as a small helper file)

repr_text <- paste0(
  "Row counts:\n",
  "  Math: ", nrow(mat), "\n",
  "  Portuguese: ", nrow(por), "\n",
  "  Overlap (both): ", nrow(both), "\n\n",
  "Note: all students come from two Portuguese schools only.\n",
  "Interpret models as context-specific rather than fully general.\n"
)

writeLines(repr_text, con = file.path(results_dir, "representativeness_notes.txt"))

cat("Data quality checks complete. Results saved in the 'results' folder.\n")
