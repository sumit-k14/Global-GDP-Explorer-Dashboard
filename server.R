server <- function(input, output, session) {
  
  # Reactive expression to filter core long data
  filtered_data <- reactive({
    gdp_long %>%
      filter(Country %in% input$countries,
             year >= input$year_range[1],
             year <= input$year_range[2])
  })
  
  # Reactive expression for grouped data summary metrics
  summary_stats <- reactive({
    req(nrow(filtered_data()) > 0)
    filtered_data() %>%
      arrange(Country, year) %>%
      group_by(Country) %>%
      summarise(
        Min_GDP = round(min(gdp), 1),
        Max_GDP = round(max(gdp), 1),
        Avg_GDP = round(mean(gdp), 1),
        Start_Year_GDP = round(gdp[which.min(year)], 1),
        End_Year_GDP = round(gdp[which.max(year)], 1),
        # Handles single year selections to prevent division by zero
        years_diff = max(year) - min(year),
        CAGR_pct = if_else(years_diff > 0, 
                           round(((End_Year_GDP / Start_Year_GDP)^(1 / years_diff) - 1) * 100, 2), 
                           0)
      )
  })
  
  # Reactive calculation for YoY growth rates
  growth_data <- reactive({
    filtered_data() %>%
      arrange(Country, year) %>%
      group_by(Country) %>%
      mutate(growth = (gdp / lag(gdp) - 1) * 100) %>%
      ungroup()
  })
  
  # ==========================================
  # VALUE BOXES (KPIs)
  # ==========================================
  output$top_cagr_country <- renderText({
    res <- summary_stats() %>% slice_max(CAGR_pct, n = 1, with_ties = FALSE)
    paste0(res$Country, " (", res$CAGR_pct, "%)")
  })
  
  output$largest_economy <- renderText({
    res <- filtered_data() %>% 
      filter(year == max(year)) %>% 
      slice_max(gdp, n = 1, with_ties = FALSE)
    paste0(res$Country, " ($", round(res$gdp, 1), "B)")
  })
  
  output$highest_avg_growth <- renderText({
    res <- growth_data() %>%
      group_by(Country) %>%
      summarise(avg_g = mean(growth, na.rm = TRUE)) %>%
      slice_max(avg_g, n = 1, with_ties = FALSE)
    paste0(res$Country, " (", round(res$avg_g, 2), "%)")
  })
  
  # ==========================================
  # PLOTLY INTERACTIVE CHARTS
  # ==========================================
  
  # Chart 1: GDP Trend
  output$gdp_trend <- renderPlotly({
    p <- ggplot(filtered_data(), aes(x = year, y = gdp, color = Country, group = Country)) +
      geom_line(linewidth = 0.8) +
      labs(y = "GDP (billions USD)", x = NULL) +
      theme_minimal()
    ggplotly(p)
  })
  
  # Chart 2: Top 10 Economies (snapshot at end year)
  output$top10_bar <- renderPlotly({
    p <- gdp_long %>%
      filter(year == input$year_range[2]) %>%
      slice_max(gdp, n = 10) %>%
      ggplot(aes(x = reorder(Country, gdp), y = gdp, text = paste("Country:", Country, "<br>GDP: $", gdp, "B"))) +
      geom_col(fill = "steelblue") +
      coord_flip() +
      labs(x = NULL, y = "GDP (billions USD)") +
      theme_minimal()
    ggplotly(p, tooltip = "text")
  })
  
  # Chart 3: Year-over-year Growth Rate (%)
  output$growth_rate <- renderPlotly({
    p <- growth_data() %>%
      filter(!is.na(growth)) %>%
      ggplot(aes(x = year, y = growth, color = Country, group = Country)) +
      geom_line(linewidth = 0.8) +
      geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
      labs(y = "Growth Rate (%)", x = NULL) +
      theme_minimal()
    ggplotly(p)
  })
  
  # Chart 4: GDP Share (%) among selected countries
  output$gdp_share <- renderPlotly({
    p <- filtered_data() %>%
      group_by(year) %>%
      mutate(share = gdp / sum(gdp) * 100) %>%
      ungroup() %>%
      ggplot(aes(x = year, y = share, fill = Country, group = Country)) +
      geom_area(alpha = 0.8) +
      labs(y = "Share (%)", x = NULL) +
      theme_minimal()
    ggplotly(p)
  })
  
  # Chart 5: Average annual growth rate comparison
  output$avg_growth <- renderPlotly({
    df_avg <- growth_data() %>%
      group_by(Country) %>%
      summarise(avg_growth = mean(growth, na.rm = TRUE))
    
    p <- ggplot(df_avg, aes(x = reorder(Country, avg_growth), y = avg_growth, fill = avg_growth > 0,
                            text = paste("Country:", Country, "<br>Avg Growth:", round(avg_growth, 2), "%"))) +
      geom_col() +
      coord_flip() +
      scale_fill_manual(values = c("TRUE" = "seagreen", "FALSE" = "firebrick"), guide = "none") +
      labs(x = NULL, y = "Average Growth (%)") +
      theme_minimal()
    ggplotly(p, tooltip = "text")
  })
  
  # ==========================================
  # SUMMARY DATA TABLE
  # ==========================================
  output$summary_table <- renderDT({
    summary_stats() %>%
      select(-years_diff) %>% # drop structural column
      datatable(options = list(pageLength = 10, scrollX = TRUE))
  })
}
