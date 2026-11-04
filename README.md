# Olympic Gamses UCDavis Capstone Project

In the framework of [Coursera course from UCDavis "SQL for Data Science Capstone Project"](https://www.coursera.org/learn/sql-data-science-capstone?specialization=learn-sql-basics-data-science), I'm creating a historical analysis of the Olympic Games (1896-2006).

## Research Question, Main Metrics, and Analytical Approach
### Research Question
How have athlete demographics, geographic representation, and competitive dominance evolved across Summer and Winter Olympic Games from 1896 to 2016?

**Sub-questions:**
* **Participation & Demographics**: How has the gender ratio and average age/physical profile of athletes shifted across decades?
* **Global Reach**: How has the number of participating countries and regions (NOCs) expanded over time?
* **Medal Concentration**: Has medal distribution become more globally decentralized, or is it still dominated by a handful of top-performing countries?

### Main Metrics
|Metric Category|Metric Name|Purpose|
|---|---|---|
|Participation|Total Unique Athletes|Measures overall scale and growth of the games|
|Demographics|Gender Representation (%)|Tracks the evolution of female inclusion in sports over time|
|Demographics|Athlete Physical Profiles|Evaluates whether athletes are becoming taller, heavier, or aging differently over time|
|Geographic Diversity|Active NOCs / Regions|Measures globalization and international participation depth|
|Performance|Medal Tally by Region|Analyzes national success and shifting dominance across eras|

### Analytical Approach
* **Step 1. Data Exploration & Re-formatting**
    * restructuring the data (from one flat table to a system of related tables in a local PostgreSQL database) and building new ERD;
    * checking for unique values, duplicates, null-values handling.

* **Step 2. Exploratory SQL Queries & First Visualizations**<br>
    * > [PLANNED]
    * check anomalies and outliers;
    * total rows, unique atletes, unique counts of events and sports, unique games and events per season;
    * distribution of athletes across countries, sport disciplines, games;
    * distribution of athletes and medals across countries; contry-level comparison;
    * descriptive statistics of age, height, weight, participation counts, medal counts across countries, years, gender, sport disciplines;
    * analytical engineering: creating additional fields/metrics (e.g., `medal_per_region` or `change_team`).

* **Step 3. Deep-Dive Analytical Queries**
    * > [PLANNED]
    * trend analysis: window functions / grouping by `year` and `season` to track percentage growth of female athletes decade-over-decade;
    * specializarion trends: checking for specific sports weight/height/age statistics to see the change over time in different disciplines;
    * host country advantage (idea): cross-reference host cities with team performace --> is there a "bonus" in medal counts?

* **Step 4. Presentation & Storytelling**
    * > [PLANNED]
    * preparation of final product (a presentation, a repors, a `streamlit` app).

## Data
[Kaggle by Randi Griffin](https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results/data)

## Steps
The course offers four assignments:
1. Data Selection & Project Proposal
> In this first milestone, you will select your client and import your dataset. You will begin to explore your data to understand it and make assumptions about your data. You will draft a project proposal to act as a guide as you explore your data and prove or disprove your hypotheses.<br>
Status: ✅

2. Descriptive Statistics & Domain Knowledge
> In this milestone, you will start to execute your project proposal. You will start looking at your data and perform initial statistic models to explore your data and determine what you have available to you.<br>
Status: 🛠️

3. Dive Deeper / Go Broader
> In this milestone, you will go beyond the descriptive statistics you completed in the last milestone. This milestone is really about diving deeper to analyze your data, beyond descriptive stats. Maybe you need to analyze qualitative data or textual data to get a full picture.<br>
Status: 🛠️ 

4. Presentation
> In this milestone, you will present your findings. You will identify your audience and create a presentation tailored to them. You will be able to tell the story of analyses and make recommendations.<br>
Status: 🛠️

## Repository Structure
* `analysis/` includes `.sql` scripts and `.ipynb` files with first EDA and data transformations; also provides the steps to create local database;
* `assignments/` contains `.pdf` files, shared during the course as milestone completion documents;
* `data/` has notes on data source and data dictionary; `.csv` files are not being tracked;
* `reports/` contains drafts for assignmnets and presentations.
