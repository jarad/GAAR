library(ggplot2)
library(reshape2)

source("get_times.R")

d = get_times(read.csv("data/GAAR2013.csv"))

shinyServer(function(input, output) {

  # 
  dd <- reactive({
    o = d[d$Category %in% input$category,]
    o = o[order(o$Total),]
    o$Rank = 1:nrow(o)
    o[order(o[,input$sort]),]
  })

  output$table <- renderTable({
    dd()
  }, include.rownames = FALSE)

  output$plot <- renderPlot({
    o <- dd()
    o$Canoe = times(o$Canoe)
    o$Bike = times(o$Bike)
    o$Run = times(o$Run)

    m = melt(o, measure.vars=c("Canoe","Bike","Run"),
             variable.name="Event", value.name="Time")
    m$Rank = as.factor(m$Rank)

    p = ggplot(m, aes(x=Rank, y=Time*24, fill=Event)) + 
        geom_bar(stat="identity") + 
        ylab("Time (hours)") 
    print(p)
  })
})

