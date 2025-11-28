# BSK15(Bhuvraj Khangura) – COMP 331 – Final Project
# Data Quality & Bias Analysis – R script
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
mat <- read.csv(
  data_path_mat,
  sep = ";",
  stringsAsFactors = FALSE
)

por <- read.csv(
  data_path_por,
  sep = ";",
  stringsAsFactors = FALSE
)

# Quick check of columns (should match the UCI documentation)
# print(names(mat))
# print(names(por))

# ============================================================
# 1. COMPLETENESS – row counts and overlap
# ============================================================

# Shared columns we can safely use to define the same "student"
shared_cols <- intersect(names(mat), names(por))

# Inner join on all shared columns to find students in BOTH subjects
both <- dplyr::inner_join(
  mat,
  por,
  by = shared_cols,
  suffix = c("_mat", "_por")
)

cat("Rows in Math file:       ", nrow(mat), "\n")
cat("Rows in Portuguese file: ", nrow(por), "\n")
cat("Rows in overlap (both):  ", nrow(both), "\n\n")

# Simple summary table for the report
overlap_summary <- data.frame(
  description = c("Math total", "Portuguese total", "Overlap (both subjects)"),
  n_students  = c(nrow(mat), nrow(por), nrow(both))
)

write.csv(
  overlap_summary,
  file      = file.path(results_dir, "overlap_counts.csv"),
  row.names = FALSE
)

# ============================================================
# 2. BASIC SUMMARY TABLES (G3 and absences)
# ============================================================

summary_tables <- bind_rows(
  mat %>%
    summarise(
      dataset       = "Math",
      n_students    = n(),
      mean_G3       = mean(G3, na.rm = TRUE),
      sd_G3         = sd(G3, na.rm = TRUE),
      mean_absences = mean(absences, na.rm = TRUE)
    ),
  por %>%
    summarise(
      dataset       = "Portuguese",
      n_students    = n(),
      mean_G3       = mean(G3, na.rm = TRUE),
      sd_G3         = sd(G3, na.rm = TRUE),
      mean_absences = mean(absences, na.rm = TRUE)
    )
)

write.csv(
  summary_tables,
  file      = file.path(results_dir, "summary_tables.csv"),
  row.names = FALSE
)

# ============================================================
# 3. G3 DISTRIBUTIONS (for hist + boxplot)
# ============================================================

grades_long <- rbind(
  data.frame(G3 = mat$G3, subject = "Math"),
  data.frame(G3 = por$G3, subject = "Portuguese")
)

# Histogram of G3 by subject
p_g3_hist <- ggplot(grades_long, aes(x = G3, fill = subject)) +
  geom_histogram(
    position = "identity",
    alpha    = 0.5,
    bins     = 15
  ) +
  labs(
    title = "Final Grade (G3) Distribution",
    x     = "G3 (final grade)",
    y     = "Count"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(results_dir, "g3_hist.png"),
  plot     = p_g3_hist,
  width    = 7,
  height   = 4,
  dpi      = 300
)

# Boxplot of G3 by subject
p_g3_box <- ggplot(grades_long, aes(x = subject, y = G3)) +
  geom_boxplot() +
  labs(
    title = "G3 Comparison",
    x     = "Subject",
    y     = "G3 (final grade)"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(results_dir, "g3_box.png"),
  plot     = p_g3_box,
  width    = 5,
  height   = 4,
  dpi      = 300
)

# ============================================================
# 4. ABSENCES vs G3 (scatterplot)
# ============================================================

abs_long <- rbind(
  data.frame(absences = mat$absences, G3 = mat$G3, subject = "Math"),
  data.frame(absences = por$absences, G3 = por$G3, subject = "Portuguese")
)

p_abs <- ggplot(abs_long, aes(x = absences, y = G3, colour = subject)) +
  geom_jitter(width = 0.4, height = 0.4, alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, size = 0.7) +
  labs(
    title = "Absences vs Final Grade (G3)",
    x     = "Absences",
    y     = "G3 (final grade)"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(results_dir, "absences_vs_g3.png"),
  plot     = p_abs,
  width    = 7,
  height   = 4,
  dpi      = 300
)

# ============================================================
# 5. SIMPLE TEXT NOTES ON REPRESENTATIVENESS
# ============================================================

repr_text <- paste0(
  "Row counts:\n",
  "  Math:       ", nrow(mat), "\n",
  "  Portuguese: ", nrow(por), "\n",
  "  Overlap:    ", nrow(both), "\n\n",
  "Note: all students come from two Portuguese schools only.\n",
  "Interpret models as context-specific rather than fully general.\n"
)

writeLines(
  repr_text,
  con = file.path(results_dir, "representativeness_notes.txt")
)

cat("Data quality checks complete. Results saved in the 'results' folder.\n")

