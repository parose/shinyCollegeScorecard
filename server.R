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
  
  score[score$PublicNetCost == "NULL", "PublicNetCost"] <- NA
  score[score$PrivateNetCost == "NULL", "PrivateNetCost"] <- NA
  netCost <- as.numeric(score$PublicNetCost)
  netCost[is.na(netCost)] <- as.numeric(score$PrivateNetCost[is.na(netCost)])
  
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
  
  
  scorex <- reactive({
    dispScore <- score
    
    if(!NE())
    {
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
           "ACT" = "AverageACT")
  })  

  myY <- reactive({
    switch(input$myYs,
           "ACT" = "AverageACT",
            "SAT" = "AverageSAT")
  })
  
  #regression <- reactive({
   # model <- lm(eval(parse(text = myY())) ~ eval(parse(text = myX())), data = scorex())
  #})
  
  output$scatterPlot <- renderPlotly({
    #model <- lm(eval(parse(text = myY())) ~ eval(parse(text = myX())), data = scorex())
    x <- list(
      title = myX()
    )
    y <- list(
      title = myY()
    )
    plot_ly(data = scorex(), x = ~eval(parse(text = myX())), y = ~(eval(parse(text = myY())))) %>%
      #add_trace(data = scorex(), y = ~fitted(model), mode = "lines") %>%
      layout(xaxis = x, yaxis = y)
  })
  
  #output$linearModel <- renderPrint({regression$model})
  
  #print DT
  output$datatable = DT::renderDataTable(scorex())
})
