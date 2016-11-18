library(shiny)
library(datasets)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  score <- read.csv("data/Most-Recent-Cohorts-All-Data-Elements.csv")
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$distPlot <- renderPlotly({
    x    <- faithful[, 2]  # Old Faithful Geyser data
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    plot_ly(x = ~rnorm(50), type = "histogram")#(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = score[0:5],
           "pressure" = score[6:10],
           "cars" = score[11:12])
  })
  
  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  
  # Show the first "n" observations
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
})
