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

    br(),
    htmlOutput("cat1"),
    htmlOutput("cat2"),
    htmlOutput("cat3"),
    br(),

    radioButtons("sort", "Sort by:",
                c("Kayak","Bike","Run","Total"),"Total")

  ),

  mainPanel(
    tabsetPanel(
      tabPanel("Results", tableOutput("table")),
      tabPanel("Plot", plotOutput("plot"))
    )
  )
))

