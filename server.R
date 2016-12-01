library(shiny)
library(datasets)
library(plotly)
library(DT)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  score <- read.csv("data/Most-Recent-Cohorts-All-Data-Elements.csv")[c("INSTNM", "STABBR", "REGION", "LATITUDE", "LONGITUDE", "CONTROL", "SAT_AVG_ALL", "ACTCMMID", "NPT4_PUB", "NPT4_PRIV", "UGDS")]
  
    
    # draw the histogram with the specified number of bins
    plot_ly(x = ~rnorm(50), type = "histogram")#(x, breaks = bins, col = 'darkgray', border = 'white')
      #print DT
  
    output$datatable = DT::renderDataTable(score)
})

