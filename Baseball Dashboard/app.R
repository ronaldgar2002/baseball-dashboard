# Load required libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(readr)

# Load the cleaned datasets
batting_data <- readRDS("batting_data.rds")
career_stats <- readRDS("career_stats.rds")

# Get list of available years and teams
years <- sort(unique(batting_data$yearID))
teams <- sort(unique(batting_data$franchID))

# UI layout
ui <- fluidPage(
  titlePanel("⚾ MLB Sabermetrics Dashboard"),

  sidebarLayout(
    sidebarPanel(
      sliderInput("year", "Select Year:",
                  min = min(years), max = max(years), value = max(years),
                  step = 1, sep = ""),

      selectInput("team", "Select Team (Optional):",
                  choices = c("All", teams), selected = "All"),

      numericInput("minAB", "Minimum At-Bats:", value = 100, min = 0),

      selectInput("player", "Player Profile:",
                  choices = sort(unique(career_stats$Name)))
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Leaderboard",
                 h4("Top Performers"),
                 tableOutput("leaderboard"),
                 br(),
                 plotlyOutput("ops_plot")
        ),

        tabPanel("Player Career Summary",
                 h4(textOutput("selected_player")),
                 tableOutput("career_table"),
                 plotlyOutput("trend_plot")
        )
      )
    )
  )
)

# Server logic
server <- function(input, output, session) {

  # Reactive: filtered data by year, team, and min AB
  filtered_data <- reactive({
    data <- batting_data |> filter(yearID == input$year, AB >= input$minAB)

    if (input$team != "All") {
      data <- data |> filter(franchID == input$team)
    }

    data
  })

  # Leaderboard table
  output$leaderboard <- renderTable({
    filtered_data() |>
      arrange(desc(OPS)) |>
      select(Name, franchID, AB, HR, OBP, SLG, OPS) |>
      head(10)
  })

  # OPS distribution plot
  output$ops_plot <- renderPlotly({
    plot <- filtered_data() |>
      ggplot(aes(x = OPS)) +
      geom_density(fill = "steelblue", alpha = 0.6) +
      labs(title = paste("OPS Distribution in", input$year),
           x = "OPS", y = "Density") +
      theme_minimal()

    ggplotly(plot)
  })

  # Player career summary table
  output$career_table <- renderTable({
    career_stats |>
      filter(Name == input$player) |>
      select(Years, Total_HR, Total_H, Total_AB, Career_AVG, Career_OPS, Career_OBP, Career_SLG)
  })

  # Player performance trend over time
  output$trend_plot <- renderPlotly({
    player_id <- career_stats |>
      filter(Name == input$player) |>
      pull(playerID)

    trend <- batting_data |>
      filter(playerID == player_id) |>
      arrange(yearID)

    plot <- ggplot(trend, aes(x = yearID, y = OPS)) +
      geom_line(color = "#D7263D", size = 1) +
      geom_point(size = 2) +
      labs(title = paste(input$player, "- OPS Over Time"),
           x = "Year", y = "OPS") +
      theme_minimal()

    ggplotly(plot)
  })

  # Player name output
  output$selected_player <- renderText({
    paste("Career Stats for", input$player)
  })
}

# Run the app
shinyApp(ui = ui, server = server)
