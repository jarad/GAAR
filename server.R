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
})

