library(shiny)

files = list.files("./data",pattern=".csv")

d = read.csv("data/GAAR2013.csv")


# Define UI for miles per gallon application
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Great Ames Adventure Race Results"),

  sidebarPanel(
    selectInput("year", "Year:",
                gsub("\\D","",files),"2013"),

    selectInput("category", "Category:", 
                levels(d$Category), levels(d$Category),
                multiple=TRUE),

    radioButtons("sort", "Sort by:",
                c("Canoe","Bike","Run","Total"),"Total")

  ),

  mainPanel(
    tabsetPanel(
      tabPanel("Results", tableOutput("table")),
      tabPanel("Plot", plotOutput("plot"))
    )
  )
))

