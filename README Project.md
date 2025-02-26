# 🏎️ **F1 Argentina Data Analytics Project – Portfolio README**

## 📢 **Project Overview**
This project focuses on analyzing the **performance of Argentine drivers in Formula 1**, with a special emphasis on **Franco Colapinto’s 2024 debut season**. As an Argentine and a passionate F1 fan, I was motivated by Colapinto’s entry into F1 after more than 15 years without Argentine representation. This project was a perfect opportunity to merge my love for motorsport with data analysis, allowing me to explore a topic that genuinely excites me while showcasing my SQL skills in a real-world scenario.

For the analysis, I used a **comprehensive Formula 1 dataset** sourced from Kaggle, which contains updated information for every season from **1950 to 2024**. The dataset’s relational structure—with tables covering drivers, races, results, constructors, and circuits—made it ideal for practicing various SQL concepts.  

🔎 **Key Objectives:**  
- Explore the historical performance of Argentine drivers in F1.  
- Compare Franco Colapinto’s debut season with those of other Argentine drivers.  
- Apply and demonstrate practical SQL data analysis skills.  
- Develop a recruiter-friendly project with clear, documented queries.  

💾 **Dataset:**  
- Source: [Kaggle F1 Dataset (1950–2024)](https://www.kaggle.com/) *(Add the specific link when available)*  
- Contains data on races, drivers, constructors, results, circuits, and standings.  

🚀 **Deliverables:**  
- A complete set of **SQL queries** reflecting different data analysis stages.  
- Clear explanations of each query’s logic and purpose.  
- Visual summaries and insights (described in the project explanation).  

---

## 🛠️ **Tools & Technologies Used**  
- **Microsoft SQL Server**: Data storage and querying environment.  
- **SQL Server Management Studio (SSMS)**: Query development and execution.  
- **GitHub**: Code hosting and version control.  
- **Microsoft Excel**: Data cleaning and initial formatting prior to SQL import.  
- **Tableau Public** *(for final visualizations, see details below)*  

---

## 📚 **SQL Skills Practiced**  
✅ **Basic Queries:** Dataset exploration and identifying key variables.  
✅ **Joins:** Combining related tables using primary and foreign keys.  
✅ **Aggregate Functions:** Using `SUM`, `COUNT`, `AVG`, `MIN`, and `MAX` for summarizing data.  
✅ **CTEs (Common Table Expressions):** Structuring complex queries for readability.  
✅ **Window Functions:** Implementing `RANK`, `DENSE_RANK`, and `ROW_NUMBER` for ranking scenarios.  
✅ **Subqueries:** Handling advanced filtering and comparisons.  
✅ **String & Date Functions:** Cleaning data for clearer analysis and presentation.  
✅ **Best Practices:** Writing readable queries with meaningful aliases and formatted outputs.  

---

## 📝 **Query Logic & Analysis Approach**  
The analysis was structured in progressive stages to reflect a professional data exploration process. Each set of queries was designed to answer specific, real-world questions related to F1 and Argentine drivers. 

### 🏁 **1. Data Exploration**  
*Goal:* Understand the dataset and identify key areas for deeper analysis.  
✅ Queries included basic counts (e.g., how many circuits have hosted races) and identifying patterns like the number of races per season.  

```sql
-- How many circuits have been used in F1 history?
SELECT COUNT(DISTINCT circuitId) AS TotalCircuits FROM circuits;
```
*Why?* This provides context on the dataset’s coverage and helps frame further analysis.

---

### 📊 **2. Aggregations & Grouping**  
*Goal:* Summarize key performance metrics.  
✅ Used aggregation functions to identify trends, like which seasons had the most races and which teams secured the most wins.  

```sql
-- Which season had the most races?
SELECT TOP 1 r.year AS Season, COUNT(*) AS TotalRaces
FROM races r
GROUP BY r.year
ORDER BY TotalRaces DESC;
```
*Why?* Helps understand how the F1 calendar evolved over time.

---

### 🔗 **3. Joins & Relationships**  
*Goal:* Combine multiple tables to derive comprehensive insights.  
✅ Leveraged joins to connect drivers, results, and constructors, identifying champions and constructor performances.  

```sql
-- List all F1 champions by season
WITH SeasonsPoints AS (
    SELECT d.surname AS Driver, ra.year AS Season, SUM(CAST(r.points AS FLOAT)) AS TotalPoints
    FROM results r
    JOIN drivers d ON d.driverId = r.driverId
    JOIN races ra ON ra.raceId = r.raceId
    GROUP BY d.surname, ra.year
)
SELECT Driver, Season, RANK() OVER (PARTITION BY Season ORDER BY TotalPoints DESC) AS Rank
FROM SeasonsPoints
WHERE Rank = 1
ORDER BY Season DESC;
```
*Why?* This query identifies the world champion for each season, highlighting how relational data can be combined for meaningful insights.

---

### 🇦🇷 **4. Focus on Argentine Drivers**  
*Goal:* Delve into the performance of Argentine drivers throughout F1 history.  
✅ Analyzed podium finishes, constructors associated with Argentine drivers, and average points scored.  

```sql
-- Which constructor scored the most points with Argentine drivers?
SELECT c.name AS Constructor, SUM(CAST(r.points AS FLOAT)) AS TotalPoints
FROM results r
JOIN constructors c ON c.constructorId = r.constructorId
JOIN drivers d ON d.driverId = r.driverId
WHERE d.nationality LIKE 'Arg%'
GROUP BY c.name
ORDER BY TotalPoints DESC;
```
*Why?* Understanding which teams Argentine drivers performed best with provides insights into historical team-driver dynamics.

---

### 🏎️ **5. Franco Colapinto’s 2024 Season Analysis**  
*Goal:* Evaluate Colapinto’s debut season and compare it to other Argentine rookies.  
✅ Focused on race-by-race performance, teammate comparisons, and average points per race.  

```sql
-- Track Colapinto’s performance in 2024
WITH ColapintoPerformance AS (
    SELECT ra.round AS Round, r.positionOrder AS FinishingPosition, r.points AS PointsEarned
    FROM results r
    JOIN drivers d ON d.driverId = r.driverId
    JOIN races ra ON ra.raceId = r.raceId
    WHERE d.surname = 'Colapinto' AND ra.year = 2024
)
SELECT * FROM ColapintoPerformance ORDER BY Round;
```
*Why?* This analysis provides a detailed view of Colapinto’s progress during his debut season.

---

## 🗂️ **How to Navigate This Project**  
This repository is structured to guide you through the analysis process step by step:

1. **Start with the queries:** Browse the `sql_queries/` folder to view the scripts for each analysis stage. Each file is clearly named and commented for easy understanding.
2. **Follow the analysis flow:** The queries progress from data exploration to advanced performance comparisons.
3. **Read the explanations:** Inline comments within the SQL files explain the purpose and logic of each query.
4. **Explore the final insights:** Visual interpretations of these queries are available in the Tableau dashboard (see below).

🔑 **Tip for recruiters:** Check out the stages focusing on Argentine drivers and Franco Colapinto’s performance to see complex SQL concepts applied to a real-world dataset.

---

## 📊 **Data Visualization with Tableau**  
To showcase the insights obtained from the SQL analysis, I created an **interactive Tableau dashboard** highlighting:
- Points progression of Argentine drivers over the decades.
- Franco Colapinto’s race results and performance comparison.
- Podium finishes and constructor associations with Argentine drivers.
- Trends in Argentine driver participation throughout F1 history.

🔗 **Tableau Dashboard Link:** *(Coming soon – will be added here when published)*

*Why use Tableau?* Visualizations make the data-driven stories clearer and more engaging, especially for non-technical stakeholders. This dashboard provides an interactive way to explore key metrics from the project.

---

## 🌟 **Why This Project Matters**  
> *"Formula 1 isn’t just a sport to me—it’s a passion. Combining that enthusiasm with my data analysis journey made this project both exciting and educational. Being able to analyze Franco Colapinto’s entry into F1 and Argentina’s racing history was a rewarding challenge that pushed my SQL skills and analytical thinking."*  

✅ **Passion-driven analysis:** Working with a subject I love made the project more engaging.  
✅ **Real-world data challenges:** Managed large, relational datasets with practical solutions.  
✅ **Professional presentation:** Queries are clean, organized, and follow best practices.  
✅ **Recruiter-friendly:** Highlights both technical expertise and personal motivation.  

---

## 💬 **Contact & Links**  
- **GitHub:**  https://github.com/MatiasR95 
- **LinkedIn:** www.linkedin.com/in/matias-rossi-95-data-strength  
- **Portfolio Blog:** https://matirossi87mr.wixsite.com/matiasrossi-porfolio
- **Dataset:** [Kaggle F1 Dataset (1950–2024)] https://www.kaggle.com/datasets/rohanrao/formula-1-world-championship-1950-2020  
- **Tableau Dashboard:** *(Link coming soon)*  

📧 *Let’s connect and discuss data, F1, or this project further!* 🚀

