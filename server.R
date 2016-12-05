library(shiny)
library(datasets)
library(plotly)
library(DT)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #Data Importing + Cleaning
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
      
      NP <- reactive({
        
        if(input$NUS)
        {
          x <- 1
        }
        else
        {
          x <- 0
        }
        
      })
      
      FP <- reactive({
        
        if(input$NUS)
        {
          x <- 1
        }
        else
        {
          x <- 0
        }
        
      })
      

      scorex <- reactive({
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
        
        if(!NE())
        {
          score <- score[score$Region != 1,]
          score <- score[score$Region != 2,] 
        }
        if(!MDW())
        {
          score <- score[score$Region != 3,]
          score <- score[score$Region != 4,] 
        }    
        if(!SO())
        {
          score <- score[score$Region != 5,]
          score <- score[score$Region != 6,] 
        }
        if(!WE())
        {
          score <- score[score$Region != 7,]
          score <- score[score$Region != 8,] 
        }
        if(!NUS())
        {
          score <- score[score$Region != 9,]
        }         
        score
        
      })
            
        

  output$scatterPlot <- renderPlotly({
    plot_ly(data = score, x = ~AverageSAT, y = ~netCost)
  })
  
      #print DT
      output$datatable = DT::renderDataTable(score)
})

