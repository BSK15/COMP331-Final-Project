BSK15(Bhuvraj Khangura) - COMP331 Final Project
Data Quality Review of the UCI Student Performance Dataset

This repository contains all files and outputs for the COMP 331 final project. It includes the analysis script, processed results (plots and tables), original datasets, and the final report.

--- Repository Structure
1. /code/ — Analysis Scripts

Contains the main R script used for the full analysis:

data_quality_analysis.R
Loads both datasets, checks completeness, consistency, uniqueness, and representativeness, and generates all plots/tables stored in /results.

2. /results/ — Generated Outputs

All outputs created by the R script:

Plots

g3_box.png — Boxplot comparing final grades (G3)

g3_hist.png — Histogram of G3 distributions

absences_vs_g3.png — Scatterplot of absences vs final grade

Tables (CSV)

missing_summary.csv — Missing data summary

overlap_counts.csv — Math/Portuguese row counts & overlap

row_counts.csv — Dataset-level row counts

summary_tables.csv — Combined summary statistics

Notes

representativeness_notes.txt — Interpretation of representativeness findings

3. Data Files

Original UCI datasets used for the analysis:

student-mat.csv

student-por.csv

4. /report/ — Final Report

Contains the final project report submitted for COMP 331.

--- Project Description

This project evaluates the UCI Student Performance dataset across key data quality dimensions, including:

Completeness

Consistency & Uniqueness

Representativeness

The goal is to examine common data issues that may affect data mining or predictive modeling tasks. Outputs supporting this analysis (charts and tables) are provided in the /results folder.

Author - Bhuvraj Khangura
