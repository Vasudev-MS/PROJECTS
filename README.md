# 🦠 COVID-19 Data Exploration using SQL (MySQL)

## 📖 Project Overview
This project focuses on analyzing COVID-19 global data using **MySQL**.  
It explores infection trends, death rates, vaccination progress, and population impact through structured SQL queries.

---

## 🧰 Tools & Technologies
- **Database:** MySQL  
- **Data Source:** Our World in Data (COVID-19 Dataset)  
- **Skills Demonstrated:**  
  - Joins & CTEs  
  - Aggregate Functions  
  - Window Functions  
  - Temporary Tables & Views  
  - Data Cleaning & Exploration

---

## 🎯 Objective
To explore, clean, and analyze COVID-19 data to answer key questions such as:
- What’s the death percentage per country?
- Which countries have the highest infection rate relative to population?
- What are the vaccination progress trends across continents?
- How does global mortality rate change over time?

---

## 📊 Key Insights
- Countries with larger populations (like India and the USA) showed diverse infection-to-death ratios.  
- Some smaller countries had higher infection percentages due to dense populations.  
- Vaccination rollouts showed consistent correlation with decreasing fatality rates.  
- Global death percentage averaged around **2–3%** across most regions.

---

## 🧩 Project Breakdown

### 1. Data Exploration
Selected the key columns from the dataset:
```sql
SELECT Location, Date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;
