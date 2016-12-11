library(shiny)
library(datasets)
library(plotly)
library(DT)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #Data Importing + Cleaning
  score <- read.csv("data/Most-Recent-Cohorts-All-Data-Elements.csv", as.is = T)[c("INSTNM", "STABBR", "REGION", "LATITUDE", "LONGITUDE", "CONTROL", "SAT_AVG_ALL", "ACTCMMID", "UGDS", "NPT4_PUB", "NPT4_PRIV")]
  colnames(score) <- c("College Name", "State", "Region", "Latitude", "Longitude", "Control", "AverageSAT", "AverageACT", "NumberofStudents", "PublicNetCost", "PrivateNetCost")
  score[score$Latitude == "NULL", "Latitude"] <- NA
  score[score$Longitude == "NULL", "Longitude"] <- NA
  score$Latitude <- as.numeric(score$Latitude)
  score$Longitude <- as.numeric(score$Longitude)
  
  score[score$AverageACT == "NULL", "AverageACT"] <- NA
  score[score$AverageSAT == "NULL", "AverageSAT"] <- NA
  score$AverageACT <- as.numeric(score$AverageACT)
  score$AverageSAT <- as.numeric(score$AverageSAT)
  
  score[score$NumberofStudents == "NULL", "NumberofStudents"] <- NA
  score$NumberofStudents <- as.numeric(score$NumberofStudents)
  
  #Merge 2 NetCost columns into 1
  score[score$PublicNetCost == "NULL", "PublicNetCost"] <- NA
  score[score$PrivateNetCost == "NULL", "PrivateNetCost"] <- NA
  netCost <- as.numeric(score$PublicNetCost)
  netCost[is.na(netCost)] <- as.numeric(score$PrivateNetCost[is.na(netCost)])
  score$netCost <- netCost
  score <- score[, -c(10, 11)]
  
  #Checkbox input variables for subsetting data
  NE <- reactive({
    
    if(input$NE)
    {
      x <- 1
    }
    else
    {
      x <- 0
    }
    
  })
  
  SO <- reactive({
    
    if(input$SO)
    {
      x <- 1
    }
    else
    {
      x <- 0
    }
    
  })
  
  MDW <- reactive({
    
    if(input$MDW)
    {
      x <- 1
    }
    else
    {
      x <- 0
    }
    
  })
  
  WE <- reactive({
    
    if(input$WE)
    {
      x <- 1
    }
    else
    {
      x <- 0
    }
    
  })
  
  NUS <- reactive({
    
    if(input$NUS)
    {
      x <- 1
    }
    else
    {
      x <- 0
    }
    
  })
  
  PU <- reactive({
    
    if(input$PU)
    {
      x <- 1
    }
    else
    {
      x <- 0
    }
    
  })
  
  PR <- reactive({
    
    if(input$PR)
    {
      x <- 1
    }
    else
    {
      x <- 0
    }
    
  })
  
  PFP <- reactive({
    
    if(input$PFP)
    {
      x <- 1
    }
    else
    {
      x <- 0
    }
    
  })
  
  #Checkbox input variables for turning regression plots on/off
  LM <- reactive({
    if(input$LM) {
      x <- TRUE
    }
    else {
      x <- FALSE
    }
  })
  
  CI <- reactive({
    if(input$CI) {
      x <- TRUE
    }
    else {
      x <- FALSE
    }
  })
  
  PI <- reactive({
    if(input$PI) {
      x <- TRUE
    }
    else {
      x <- FALSE
    }
  })
  
  #Subsets data based on checkbox inputs
  scorex <- reactive({
    dispScore <- score
    
    if(!NE())
    {
      dispScore <- dispScore[dispScore$Region != 0,]      
      dispScore <- dispScore[dispScore$Region != 1,]
      dispScore <- dispScore[dispScore$Region != 2,] 
    }
    if(!MDW())
    {
      dispScore <- dispScore[dispScore$Region != 3,]
      dispScore <- dispScore[dispScore$Region != 4,]  
    }    
    if(!SO())
    {
      dispScore <- dispScore[dispScore$Region != 5,]
      dispScore <- dispScore[dispScore$Region != 6,] 
    }
    if(!WE())
    {
      dispScore <- dispScore[dispScore$Region != 7,]
      dispScore <- dispScore[dispScore$Region != 8,]  
    }
    if(!NUS())
    {
      dispScore <- dispScore[dispScore$Region != 9,]  
    }
    if(!PU())
    {
      dispScore <- dispScore[dispScore$Control != 1,]  
    }   
    if(!PR())
    {
      dispScore <- dispScore[dispScore$Control != 2,]  
    }          
    if(!PFP())
    {
      dispScore <- dispScore[dispScore$Control != 3,]  
    }          
    
    dispScore
  })

  
  myX <- reactive({
    switch(input$myXs,
           "SAT" = "AverageSAT",
           "ACT" = "AverageACT",
           "Cost" = "netCost",
           "Number of Students" = "NumberofStudents")
  })  

  
  myY <- reactive({
    switch(input$myYs,
           "ACT" = "AverageACT",
           "SAT" = "AverageSAT",
           "Cost" = "netCost",
           "Number of Students" = "NumberofStudents")
  })
  
  #Renders a scatterplot, optionally with linear regression output
  output$scatterPlot <- renderPlotly({
    plotData <- scorex()[!is.na(scorex()[, myX()]) & !is.na(scorex()[, myY()]), ]
    
    model <- lm(eval(parse(text = myY())) ~ eval(parse(text = myX())), data = plotData)
    predictObj <- predict(model, interval = "prediction", level = 0.99)
    confObj <- predict(model, interval = "confidence", level = 0.99)
    
    x <- list(
      title = myX()
    )
    y <- list(
      title = myY()
    )
    plot <- plot_ly(plotData, x = ~eval(parse(text = myX()))) %>% add_markers(y = ~eval(parse(text = myY())), name = "", text = plotData[,"College Name"], showlegend = F) %>% layout(xaxis = x, yaxis = y)
    if (PI()){
      plot <- add_ribbons(plot, ymin = ~predictObj[,"lwr"], ymax = ~predictObj[,"upr"], line = list(color = 'rgba(255, 246, 79, 0.4)'), fillcolor = 'rgba(255, 246, 79, 0.4)', name = "99% Prediction Interval")
    }
    if (CI()){
      plot <- add_ribbons(plot, ymin = ~confObj[,"lwr"], ymax = ~confObj[,"upr"], line = list(color = 'rgba(255, 150, 0, 0.4)'), fillcolor = 'rgba(255, 204, 0, 0.4)', name = "99% Confidence Interval")
    }
    if (LM()) {
      plot <- add_lines(plot, y = ~fitted(model), line = list(color = "red"), name = "Regression Line")
    }
    plot
  })
  
  #Renders text output containing descriptive statistics and regression information
  output$stats <- renderPrint({
    model <- lm(eval(parse(text = myY())) ~ eval(parse(text = myX())), data = scorex())
    ci <- confint(model)
    cat("Mean of X:", mean(scorex()[,myX()], na.rm = T), "\tMean of Y:", mean(scorex()[,myY()], na.rm = T), 
        "\n\nLinear Model: y = ", model$coef[1], " + ", model$coef[2], "*", "x", 
        "\n\n\t   Coefficient\t95% C.I.\t\t    Prob > t",
        "\nIntercept: ", model$coef[1], "\t(",ci[1,1], ",", ci[1,2], ")\t    ", summary(model)[[4]][1,4],"\nSlope:\t   ", model$coef[2], "\t(",ci[2,1], ",", ci[2,2], ")\t    ", summary(model)[[4]][2,4],
        sep = "")
  })
  
  #Renders DT data table
  output$datatable = DT::renderDataTable(scorex())
})
