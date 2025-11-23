# COMP331 Final Project  
## Data Quality Review of the UCI Student Performance Dataset

This repository contains my final project for COMP 331 – Data Warehousing and Data Mining. 
The project examines data quality issues in the Student Performance datasets from the UCI 
Machine Learning Repository. These datasets capture demographic details, academic background, 
study behaviour, support programs, and performance information for students enrolled in 
Mathematics and Portuguese language courses.

The project is based on *Option 2: Data Mining Quality and Bias Assessment* from the final 
project guidelines.

---

## 📁 Dataset Overview

The UCI repository provides two CSV files:

- **student-mat.csv** – student information for the Mathematics course  
- **student-por.csv** – student information for the Portuguese course  

Each dataset includes:
- Demographic characteristics  
- Family structure  
- Academic support variables  
- Alcohol consumption and health metrics  
- Attendance and study habits  
- Grades (G1, G2, G3)

Original dataset source:  
https://archive.ics.uci.edu/dataset/320/student+performance

---

## 🎯 Project Goals

The project focuses on:
- Evaluating data quality dimensions from Weeks 10–11  
- Identifying issues involving completeness, consistency/uniqueness, and representativeness  
- Connecting findings to data mining concepts such as training data quality and sampling bias  
- Developing recommendations to improve reliability and fairness  
- Maintaining a clean GitHub repository with data, scripts, and results

---

## 📂 Repository Structure

```
COMP331-Final-Project/
│
├── data/
│   ├── student-mat.csv
│   ├── student-por.csv
│
├── code/
│   ├── student-merge.R
│   ├── dq_checks.ipynb (optional)
│
├── results/
│   ├── overlap_counts.txt
│   ├── summary_tables.csv
│   ├── figures/ (optional)
│
├── report/
│   └── COMP331_Final_Project_Report.pdf
│
└── README.md
```

---

## 🧪 Scripts Included

### **student-merge.R**
- Loads both CSV datasets  
- Detects matching students using a multi-attribute key  
- Merges the datasets or extracts overlap counts  

### **dq_checks.ipynb** (optional)
- Runs distribution checks  
- Highlights inconsistencies  
- Evaluates sampling imbalance  
- Prepares visual summaries

---

## 📘 Final Report
The final PDF is found in the `/report` folder and includes:

1. Introduction  
2. Data Quality Review  
3. Recommendations  
4. Conclusion  
5. References (separate page)

---

## ▶️ How to Run the Analysis

To run the scripts:

1. Clone the repository  
   ```
   git clone https://github.com/BSK15/COMP331-Final-Project
   ```
2. Open the files in the **code** folder  
3. Run the R script or Jupyter notebook  
4. Review generated outputs under **results**

---

## 📄 Note
This project is intended solely for COMP 331 coursework.

