library(tidyverse)
library(shiny)

game_sales <- CodeClanData::game_sales

# ui ----------------------------------------------------------------------

ui <- fluidPage(
  titlePanel("Game Finder"),
  
  sidebarLayout(
    sidebarPanel(
      fluidRow(
        column(12, actionButton("update",
                               "Find games")),
        column(12, br()),
        column(12, selectInput("genre_input",
                              "What Genre?",
                              choices = 
                                c(unique(game_sales$genre))
                              )
               ),

        column(12, plotOutput("developer_plot")),
        column(12, plotOutput("sales_plot"))
      )
    ),
    mainPanel(
      fluidRow(
        column(4, radioButtons("rating_input",
                               "Rating",
                               choices = unique(game_sales$rating),
                               inline = TRUE
                               )
               ),
        column(8, plotOutput("score_plot")),
        column(4, selectInput("developer_input",
                              "Developer",
                              choices = unique(game_sales$developer)
                              )
               ),
        column(4, selectInput("platform_input",
                              "Platform",
                              choices = unique(game_sales$platform)
                              )
               ),
        column(12, DT::dataTableOutput("names_table")
        )
      )
    )
  ) 
)


# server ------------------------------------------------------------------

server <- function(input, output) {

}


shinyApp(ui, server)
