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
      checkboxInput("PR", label = "Private", value = TRUE),
      checkboxInput("PU", label = "Public", value = TRUE),
      checkboxInput("NP", label = "Non-Profit", value = TRUE),
      checkboxInput("FP", label = "For-Profit", value = TRUE)      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput("scatterPlot")
    )),
  
  selectInput("myXs", "X:", 
              choices = c("SAT", "ACT")),
  
  selectInput("myYs", "Y:", 
              choices = c("ACT", "SAT")),
    
    # Show a summary of the dataset and an HTML table with the 
    # requested number of observations
    mainPanel(
      DT::dataTableOutput("datatable")
    )
  
  
))
