library(shiny)
library(bslib)
library(DT)
library(plotly)

ui <- page_sidebar(
  title = "Global GDP Explorer (1999–2022)",
  fillable = FALSE, 
  
  theme = bs_theme(
    version = 5,
    bootswatch = "flatly",
    primary = "#2c3e50", 
    success = "#18bc9c"
  ),
  
  sidebar = sidebar(
    title = "Controls",
    width = 320,
    selectizeInput(
      "countries", "Select countries:",
      choices = sort(unique(gdp_long$Country)),
      selected = c("United States", "China", "India", "Japan", "Germany"),
      multiple = TRUE
    ),
    sliderInput(
      "year_range", "Year range:",
      min = 1999, max = 2022,
      value = c(1999, 2022), sep = ""
    )
  ),
  
  tags$head(
    tags$style(HTML("
      /* Fix layout text truncation inside metric cards */
      .gdp-kpi-card .card-body { padding: 15px !important; overflow: visible !important; }
      .gdp-kpi-title { font-size: 0.85rem; font-weight: 600; opacity: 0.9; text-transform: uppercase; margin-bottom: 4px; }
      .gdp-kpi-value { font-size: 1.4rem; font-weight: 700; line-height: 1.2; }
      
      /* Enforce clean vertical gaps between rows */
      .app-row-spacer { margin-bottom: 25px !important; }
      
      /* Standardized DataTables Pagination Styling */
      .pagination .page-link {
        color: #2c3e50 !important;
        background-color: #ffffff !important;
        border: 1px solid #dee2e6 !important;
        box-shadow: none !important;
      }
      
      /* Active Page Number (Matches the primary theme) */
      .pagination .page-item.active .page-link {
        background-color: #2c3e50 !important;
        border-color: #2c3e50 !important;
        color: #ffffff !important;
      }
      
      /* Hover State for standard buttons */
      .pagination .page-link:hover {
        background-color: #f8f9fa !important;
        color: #1a252f !important;
      }
    "))
  ),
  
  # 1. Top Row: Refined KPI Summary Boxes
  layout_columns(
    col_widths = c(4, 4, 4),
    fill = FALSE,
    class = "app-row-spacer",
    
    card(
      class = "gdp-kpi-card text-white bg-success",
      card_body(
        div(class = "gdp-kpi-title", "Growth (CAGR)"),
        div(class = "gdp-kpi-value", textOutput("top_cagr_country"))
      )
    ),
    card(
      class = "gdp-kpi-card text-white bg-primary",
      card_body(
        div(class = "gdp-kpi-title", "Largest Economy in Selected Group"),
        div(class = "gdp-kpi-value", textOutput("largest_economy"))
      )
    ),
    card(
      class = "gdp-kpi-card text-white bg-info",
      card_body(
        div(class = "gdp-kpi-title", "Highest Average Annual Growth"),
        div(class = "gdp-kpi-value", textOutput("highest_avg_growth"))
      )
    )
  ),
  
  # 2. Middle Row: Visualizations Layout
  layout_columns(
    col_widths = c(6, 6, 6, 6, 12), 
    fill = FALSE,
    class = "app-row-spacer",
    
    card(
      card_header("Economic Trajectory"),
      card_body(plotlyOutput("gdp_trend", height = "360px"))
    ),
    card(
      card_header("Global Standings Snapshot"),
      card_body(plotlyOutput("top10_bar", height = "360px"))
    ),
    card(
      card_header("Year-over-Year Volatility"),
      card_body(plotlyOutput("growth_rate", height = "360px"))
    ),
    card(
      card_header("Relative Market Share"),
      card_body(plotlyOutput("gdp_share", height = "360px"))
    ),
    card(
      card_header("Historical Performance Summary"),
      card_body(plotlyOutput("avg_growth", height = "360px"))
    )
  ),
  
  # 3. Bottom Row: Comprehensive Data Table
  card(
    fill = FALSE,
    card_header("Consolidated Macroeconomic Metrics Data Table"),
    card_body(DTOutput("summary_table"))
  )
)
