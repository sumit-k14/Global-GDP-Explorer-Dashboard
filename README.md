# Global GDP Explorer Dashboard (1999–2022)

A dynamic and interactive R Shiny web application designed to visualize and analyze historical Gross Domestic Product (GDP) data for various global economies from 1999 to 2022. 

The application is fully deployed and accessible on the *Posit Connect Cloud*.

---

## 🚀 Live Demo
You can view and interact with the deployed application here:
👉 https://connect.posit.cloud/sumitkumar/content/01a0fd04-a5cb-fd88-88cb-c939d28129f4?utm_source=rsconnect-rstudio

---

## ✨ Features

### 1. Interactive Sidebar Controls
*   *Country Selection:* A multi-select dropdown menu allowing users to isolate specific countries (e.g., China, Germany, India, Japan, United States) for custom comparisons.
*   *Dynamic Year Range:* A responsive slider input to filter data across custom historical windows between **1999 and 2022**.

### 2. Rich Data Visualizations
*   *GDP Trend Line Chart:* Tracks total GDP growth over time (in billions USD) to visualize economic trajectories.
*   *Top 10 Economies Bar Chart:* Automatically identifies and ranks the leading global economies for the selected ending year.
*   *Year-over-Year (YoY) GDP Growth Rate:* A line chart plotting annual volatility and economic expansion/contraction cycles.
*   *GDP Share 100% Stacked Area Chart:* Demonstrates shifts in relative economic dominance among the selected group over time.
*   *Average Annual Growth Rate:* A horizontal bar chart summarizing overall average performance rankings.

### 3. Comprehensive Summary Statistics Table
*   An interactive, searchable, and sortable data table providing core metrics for selected countries:
    *   `Min_GDP` & `Max_GDP` reached during the period.
    *   Overall `Avg_GDP` (Average GDP).
    *   `Start_Year_GDP` & `End_Year_GDP` benchmarks.
    *   *CAGR_pct* (Compound Annual Growth Rate percentage) for robust long-term growth analysis.

---

## 📊 Data Source
The dashboard is powered by a structured dataset tracking national macroeconomic metrics:
*   *File Name:* `GDP By Country (1999-2022).csv`
*   *Time Horizon:* 1999 – 2022
*   *Monetary Unit:* Billions of USD (\$)

---

## 🛠️ Tech Stack & Dependencies

This application is built entirely using the *R programming language* ecosystem. Key packages utilized include:
*   `shiny` & `shinydashboard` - For application layout and reactivity.
*   `ggplot2` / `plotly` - For static and interactive visualizations.
*   `dplyr` / `tidyr` - For data manipulation, filtering, and aggregation.
*   `DT` - For rendering the interactive server-side data summary table.

---

## 💻 Local Installation & Setup

To run this dashboard locally on your machine, follow these steps:

### Prerequisites
Make sure you have [R](https://r-project.org) and [RStudio](https://posit.co) installed.

### 1. Clone the Repository
```bash
git clone https://github.com
cd global-gdp-explorer
```

### 2. Install Required R Packages
Open R or RStudio and execute the following script to install all needed dependencies:
```R
install.packages(c("shiny", "shinydashboard", "dplyr", "ggplot2", "DT", "tidyr"))
```

### 3. Run the App
Place the dataset `GDP By Country (1999-2022).csv` into the project root folder alongside your `app.R` (or `ui.R`/`server.R`), then run:
```R
shiny::runApp()
```

---

## 🌐 Deployment to Posit Connect
This application is configured for cloud deployment. To redeploy or host your own instance:
1. Initialize the deployment manifest via `rsconnect::writeManifest()`.
2. Connect your RStudio IDE to your *Posit Connect Cloud* account.
3. Click the *Publish* button at the top right of your RStudio viewer window.
