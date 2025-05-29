# Layoff-Trends-Analysis
Analyzed global tech layoffs using SQL, performing data cleaning and exploratory analysis to uncover top affected companies, industries, and time trends using aggregate and window functions.

---

![](Laid_off_man.jpg)

---
## Project Overview 

This project focuses on analyzing global layoff trends by cleaning and exploring a real-world dataset using MySQL. The goal is to derive actionable business insights into industry-wide layoffs based on geography, time, company stage, and funding levels.

---
## Problem Statement ❓

In recent years, especially during economic downturns and post-pandemic recovery, massive layoffs have impacted industries across the globe. Organizations, policymakers, and job seekers need data-driven insights to understand which sectors and countries are most affected, what triggers layoffs, and how trends evolve over time.

---
## Data Source and Preparation 🗂️

### Dataset: 
The dataset used for this project can be found [here](layoffs.csv), provided as a CSV file.

### Tools Used: 
MySQL was used for the data cleaning and exploratory data analysis.

### Cleaning Steps:
  - Created staging tables to preserve raw data.

  - Removed duplicates using ROW_NUMBER() and filtering.

  - Standardized inconsistent entries (e.g., industry and country formatting).

  - Converted the date column to proper DATE format.

  - Handled NULL and blank values, especially in critical columns like industry.

  - Removed rows with no valid layoff data.

The file containing the SQL queries for the data cleaning process has been attached [here](Data_cleaning.sql)

---

## Exploratory Data Analysis (EDA) 🔍

Key SQL operations were used to:

  - Identify companies, industries, and countries most affected by layoffs.

  - Determine layoffs by year and by company stage (startup, post-IPO, etc.).

  - Generate rolling monthly layoff totals.

  - Rank companies with the highest layoffs per year using CTEs and DENSE_RANK().

I have attached the SQL queries for the exploratory data analysis process [here](Exploratory_Data_Analysis.sql)


---
## Key Metrics and Findings
- Max layoffs in a company: Found using MAX(total_laid_off).

- Top 5 companies with the most layoffs: Aggregated via SUM() and GROUP BY.

- Year with the highest layoffs: Identified through time-based grouping.

- Rolling layoff trend: Monthly cumulative trends highlight periods of layoff surges.

- Average percentage of layoffs: Computed across companies and by funding stages.

---
## Insights & Recommendations
- Tech and crypto industries were among the hardest hit.

- United States led in the number of layoffs, followed by a few other major economies.

- Early-stage and post-IPO companies showed a higher average percentage of workforce reduction.

- Layoffs peaked around 2022, signaling the aftermath of global economic disruptions.

- Recommendations include improved risk management for early-stage companies and support systems in layoff-prone sectors.

![](Laid_off_man2.jpg)

---
## Conclusion

The project successfully demonstrates how SQL can be used not just for data wrangling, but for uncovering meaningful patterns in organizational behavior. With clear trends and data-backed insights, stakeholders can make informed decisions to reduce future risks and improve resilience.

