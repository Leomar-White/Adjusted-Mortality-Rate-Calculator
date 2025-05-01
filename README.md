# Mortality Rate Calculator – Violent Injuries

## Description
This project calculates injury mortality rates stratified by sex, race, and ethnicity in Florida, supporting visualization in a Tableau dashboard. Using R and the Tidyverse suite, mortality data from an Excel flat file were cleaned, reshaped, and merged with U.S. Census population estimates for accurate rate calculations.

---

## Languages and Packages Used
- **R**
- **Tidyverse**
- **Tidycensus**

---

## Development Environment
- **RStudio** (Version 4.4.1)

---

## Program Walk-through

### 1. Load Packages and Connect to U.S. Census API  
<p align="center">
  <img src="https://i.imgur.com/HIGfLqz.png" width="80%" alt="Loading Packages and API Connection">
</p>

### 2. Import Population Data from U.S. Census  
<p align="center">
  <img src="https://i.imgur.com/2WCG08t.png" width="80%" alt="Importing Population Data Step 1">
  <br><br>
  <img src="https://i.imgur.com/7DO2lO7.png" width="80%" alt="Importing Population Data Step 2">
</p>

### 3. Create a Template Data Frame for Mortality Data and Merge with Population Data  
<p align="center">
  <img src="https://i.imgur.com/cj8YBd2.png" width="80%" alt="Merging Data Frames">
</p>

### 4. Calculate Rates and Export Final Output  
<p align="center">
  <img src="https://i.imgur.com/ArUPV4Y.png" width="80%" alt="Calculating Rates">
  <br><br>
  <img src="https://i.imgur.com/OkWGkzt.png" width="80%" alt="Exporting Data">
</p>
