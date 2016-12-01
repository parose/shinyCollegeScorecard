library(shiny)
library(plotly)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("College Scorecard App"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      radioButtons("graphSelect", "Select View", c("Overview","Barchart of stuff","Boxplot of Stuff"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput("distPlot")
    )),
  
  
  # Sidebar with controls to select a dataset and specify the
  # number of observations to view
  sidebarLayout(
    sidebarPanel(

    ),
    
    # Show a summary of the dataset and an HTML table with the 
    # requested number of observations
    mainPanel(

    )
  )
  
))
