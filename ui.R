library(shiny)
library(plotly)
library(DT)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("College Scorecard App"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      checkboxInput("NE", label = "New England", value = TRUE),
      checkboxInput("MDW", label = "Midwest", value = TRUE),
      checkboxInput("SO", label = "South", value = TRUE),         
      checkboxInput("WE", label = "West", value = TRUE),
      checkboxInput("NUS", label = "Non-US State Location", value = TRUE),      
      checkboxInput("PU", label = "Public", value = TRUE),      
      checkboxInput("PR", label = "Private", value = TRUE),
      checkboxInput("PFP", label = "Private or-Profit", value = TRUE),
      selectInput("myXs", "X:", 
                  choices = c("SAT", "ACT", "Cost", "Number of Students", "Mean Earnings", "Percent of Federal Loans", "Admission Rate")),
      
      selectInput("myYs", "Y:", 
                  choices = c("ACT", "SAT", "Cost", "Number of Students", "Mean Earnings", "Percent of Federal Loans", "Admission Rate")),
      checkboxInput("LM", label = "Show Regression Line", value = FALSE),
      checkboxInput("CI", label = "Show Confidence Interval", value = FALSE),
      checkboxInput("PI", label = "Show Prediction Interval", value = FALSE),
      selectInput("myhist", "Histogram Variable:",
                  choices = c("SAT", "ACT", "Cost", "Number of Students", "Mean Earnings", "Percent of Federal Loans", "Admission Rate"))
      
    ),
    mainPanel(
      plotlyOutput("scatterPlot"),
      verbatimTextOutput("stats")
    )
    ),
    
    # Show a summary of the dataset and an HTML table with the 
    # requested number of observations
    mainPanel(
      plotlyOutput("hist"),
      DT::dataTableOutput("datatable")
    )
  
  
))
