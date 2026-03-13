# 🧠 Illusion of Randomness  
### A Statistical Analysis of Human-Generated Binary Sequences

## 📌 Project Overview

Humans often believe they understand randomness. However, when asked to generate random sequences, they unintentionally introduce patterns due to cognitive biases.

This project investigates whether human-generated binary sequences behave like **true statistical randomness**, and studies how **confidence level** and **statistics background** influence randomness quality.

The analysis combines **behavioral science + statistics + data visualization** to uncover hidden biases in human perception of randomness.

---

## 🎯 Objectives

- Analyze whether humans can generate truly random binary sequences  
- Measure randomness using **Runs Analysis** and **balance of 0s and 1s**  
- Compare human randomness with **theoretical expected randomness**
- Study the relationship between:
  - Confidence level and randomness quality
  - Statistics background and randomness performance
- Identify common **cognitive biases** in perceived randomness  

---

## 📊 Dataset Description

The dataset was collected through a survey where participants were asked to:

- Generate a **10-digit binary sequence**
- Generate a **20-digit binary sequence**
- Report their **confidence level**
- Indicate whether they have a **statistics background**

After data cleaning and validation, **69 responses** were used for analysis.

---

## 🧹 Data Cleaning Steps

- Converted sequences into text format  
- Removed non-binary characters (only kept 0 and 1)  
- Checked sequence lengths  
- Filtered invalid responses  

This ensured accurate statistical analysis.

---

## 📈 Methodology

### 1️⃣ Runs Analysis

A **run** is defined as a switch between digits (0 → 1 or 1 → 0).

Example:
00111001
Runs = 00 | 111 | 00 | 1 → Total = 4

Expected number of runs in a random sequence:

\[
E(R) = 1 + \frac{2n_1 n_0}{n}
\]

Deviation from this value indicates non-random behavior.

---

### 2️⃣ Balance Analysis

True randomness expects approximately equal numbers of **0s and 1s**.

The project evaluates how closely participant sequences follow this property.

---

### 3️⃣ Randomness Deviation Score

A deviation metric was computed:
Randomness Deviation = |Observed Runs − Expected Runs|

Lower deviation indicates better randomness.

---

### 4️⃣ Behavioral Analysis

The study investigates:

- Does higher confidence improve randomness?
- Does statistical training reduce randomness bias?

---

## 📉 Visualizations

The project includes multiple visual insights:

- Histogram of runs distribution  
- Histogram of number of 1s  
- Scatter plot: Human vs Expected Randomness  
- Confidence vs Randomness trend  
- Boxplot comparison by statistics background  
- Donut chart of participant composition  

---

## 🔎 Key Findings

- Humans struggle to generate truly random sequences  
- Participants tend to **over-alternate digits**, producing too many runs  
- Confidence level does **not guarantee statistical accuracy**
- Statistics background may slightly reduce bias but does not eliminate it  

These results highlight the gap between **intuitive randomness perception and mathematical randomness**.

---

## 🛠️ Tools & Technologies

- **Programming Language:** R  
- **Libraries Used:**
  - tidyverse  
  - stringr  
  - ggplot2  

- **Techniques Applied:**
  - Data cleaning  
  - Statistical feature extraction  
  - Behavioral data analysis  
  - Data visualization  

---

## 🚀 Future Improvements

- Increase dataset size for stronger statistical conclusions  
- Apply formal randomness tests (Runs Test, Chi-Square Test)  
- Compare human sequences with computer-generated random sequences  
- Build an interactive dashboard for randomness evaluation  

---

## 🧩 Why This Project?

This project explores an important psychological and statistical question:

> The human brain is excellent at detecting patterns but poor at generating randomness.

Understanding randomness perception has applications in:

- Behavioral economics  
- Gambling psychology  
- Decision science  
- Data science education  

The project demonstrates how **data science techniques can reveal hidden cognitive biases** in human thinking. 
