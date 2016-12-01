library(shiny)
library(datasets)
library(plotly)
library(DT)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  score <- read.csv("data/Most-Recent-Cohorts-All-Data-Elements.csv")
    
    # draw the histogram with the specified number of bins
    plot_ly(x = ~rnorm(50), type = "histogram")#(x, breaks = bins, col = 'darkgray', border = 'white')
    if(input$graphSelect == "Overview")
    {
      #print DT
    }
    if(input$graphSelect == "Regression")
    {
      
    }
    if(input$graphSelect == "Histogram")
    {
      
    }
})

