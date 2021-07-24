#load helpers script
source("helpers.R")

# ui ----------------------------------------------------------------------

ui <- fluidPage(
  theme = shinytheme("slate"),
  
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

        #column(12, plotOutput("developer_plot", height = "300px")),
        #column(12, plotOutput("score_plot", height = "175px"))
      )
    ),
    mainPanel(
      fluidRow(
        column(4, radioButtons("rating_input",
                               "Rating",
                               choices = unique(game_sales$rating),
                               inline = TRUE
                               ),
               
        fluidRow(
          br(),
          br(),
          br(),
          column(6, selectInput("developer_input",
                                "Developer",
                                choices = c("Select one" = "",
                                            unique(game_sales$developer)
                                            )
                                )
                 ),
          column(6, selectInput("platform_input",
                                "Platform",
                                choices = c("Select one" = "",
                                            unique(game_sales$platform)
                                            )
                                )
                 )
          )
        ),
        column(4, offset = 4, plotOutput("developer_plot", height = "275px"))
        ),
      column(12, br()),
      column(12, DT::dataTableOutput("names_table")
        )
      )
    )
  ) 



# server ------------------------------------------------------------------

server <- function(input, output) {
  
  output$developer_plot <- renderPlot({
    game_sales %>% 
      filter(genre == input$genre_input) %>% 
      #filter(developer == "Nintendo") %>% 
      #filter(platform == "Wii") %>% 
      #filter(rating == "E") %>% 
      ggplot() +
      aes(x = genre, fill = developer) +
      geom_bar() +
      theme_minimal()
  })
  
  output$sales_plot <- renderPlot({
    game_sales %>% 
      filter(genre == input$genre_input) %>% 
      #filter(developer == "Nintendo") %>% 
      #filter(platform == "Wii") %>% 
      #filter(rating == "E") %>% 
      ggplot() +
      aes(x = year_of_release, y = sales) +
      geom_col() +
      theme_minimal()
  })
  
  output$score_plot <- renderPlot({
    game_sales %>% 
      filter(genre == input$genre_input) %>% 
      filter(rating == input$rating_input) %>% 
      ggplot() +
      aes(x = score, fill = scored_by) +
      geom_density(alpha = 0.6) +
      theme_minimal()
  })
  
  output$names_table <- DT::renderDataTable({
    game_sales %>% 
      filter(genre == input$genre_input,
             rating == input$rating_input,
             developer == input$developer_input,
             platform == input$platform_input) %>% 
      select(name, year_of_release, publisher, developer) %>% 
    DT::datatable(options = list(dom = "t"), style = "bootstrap") 
  })

}


shinyApp(ui, server)

#trying to get an if else table
#output$names_table <- DT::renderDataTable({
#  game_table <- filtered_games() %>% 
#    select(name, year_of_release, publisher, developer)
  
#  if(developer == input$developer_input)
#  {
#    game_table <- game_table %>% 
#      filter(developer == input$developer_input) 
#  }
#  if(platform == input$platform_input)
#  {
#    game_table <- game_table %>% 
#      filter(developer == input$developer_input) 
#  }  
  
  DT::datatable(game_table, options = list(dom = "t"), style = "bootstrap") 
})
