library(ggplot2)
library(reshape2)

source("fix_data.R")

shinyServer(function(input, output, session) {

  # Read in data file for selected year
  dat <- reactive({
    d = fix_data(read.csv(paste("data/GAAR",input$year,".csv",sep="")))
    d$Cat3 = factor(d$Cat3)
    d
  })

  # Create UI
  output$cat1 <- renderUI({
    d = dat()
    checkboxGroupInput("cat1","Category",
                       levels(d$Cat1), levels(d$Cat1))
  })

  output$cat2 <- renderUI({
    d = dat()
    checkboxGroupInput("cat2","Sub-category",
                       levels(d$Cat2), levels(d$Cat2))
  })

  output$cat3 <- renderUI({
    d = dat()

    if (all(input$cat1=="Relay")) {
      checkboxGroupInput("cat3","",
        levels(d$Cat3), levels(d$Cat3))
    } else {
      return(NULL)
    }
  })

  # 
  dd <- reactive({
    o = dat()

    # Remove Bib columns
    o$Bib = o$Bib2 = NULL

    # Subset data by selected categories
    o = o[o$Cat1 %in% input$cat1 &
          o$Cat2 %in% input$cat2 &
          (o$Cat3 %in% input$cat3 | is.na(o$Cat3)),]

    # Refactor categories
    o$Cat1 = factor(o$Cat1)
    o$Cat2 = factor(o$Cat2)
    o$Cat3 = factor(o$Cat3)

    # Add overall rank column
    o = o[order(o$Total),]
    o$Rank = 1:nrow(o)

    # Return the data frame sorted by 
    o[order(o[,input$sort]),]
  })



  # Table
  output$table <- renderTable({
    o <- dd()
    
    # Remove categories with only one level
    if (nlevels(o$Cat1)==1) o$Cat1 = NULL
    if (nlevels(o$Cat2)==1) o$Cat2 = NULL
    if (nlevels(o$Cat3)==1) o$Cat3 = NULL

    o 
  }, include.rownames = FALSE)


  # Plot
  output$plot <- renderPlot({
    o <- dd()

    # Create times from characters
    o$Kayak = times(o$Kayak)
    o$Bike  = times(o$Bike)
    o$Run   = times(o$Run)

    # Recreate ranks 
    o$Rank = 1:nrow(o)

    m = melt(o, measure.vars=c("Kayak","Bike","Run"),
             variable.name="Event", value.name="Time")
    m$Rank = as.factor(m$Rank)

    p = ggplot(m, aes(x=Rank, y=Time*24, fill=Event)) + 
        geom_bar(stat="identity") + 
        ylab("Time (hours)") 
    print(p)
  })
})

