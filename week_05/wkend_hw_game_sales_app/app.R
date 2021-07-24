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
                column(12, radioButtons("rating_input",
                                       "Rating",
                                       choices = unique(game_sales$rating),
                                       inline = TRUE
                ),
                fluidRow(
                    column(6, selectInput("developer_input",
                                          "Developer",
                                          choices = c("Select" = "",
                                                      unique(game_sales$developer)
                                          )
                    )
                    ),
                    column(6, selectInput("platform_input",
                                          "Platform",
                                          choices = c("Select" = "",
                                                      unique(game_sales$platform)
                                          )
                    )
                    )
                )
                )
            )
            ),
        mainPanel(
            fluidRow(
                column(4, plotOutput("developer_plot", height = "400px")),
                column(8, plotOutput("score_plot", height = "400px"))
            ),
            fluidRow(
                column(12, DT::dataTableOutput("names_table"))
                
            )

        )

)
)


# server ------------------------------------------------------------------
server <- function(input, output) {
    
    filtered_games <- eventReactive(input$update, {
        game_sales %>% 
            filter(genre == input$genre_input,
                   rating == input$rating_input)
        })
    
    output$developer_plot <- renderPlot({
        filtered_games() %>% 
            ggplot() +
            aes(x = genre, fill = developer) +
            geom_bar() +
            theme_minimal()
    })
    
    output$score_plot <- renderPlot({
        filtered_games() %>% 
            ggplot() +
            aes(x = score, fill = scored_by) +
            geom_density(alpha = 0.6) +
            theme_minimal()
    })
    
    output$names_table <- DT::renderDataTable({
        game_table <- filtered_games() %>% 
            select(name, year_of_release, publisher, developer)
        
            if(developer == input$developer_input)
                {
                game_table <- game_table %>% 
                filter(developer == input$developer_input) 
                    }
            if(platform == input$platform_input)
                {
                game_table <- game_table %>% 
                filter(developer == input$developer_input) 
            }  
        
           DT::datatable(game_table, options = list(dom = "t"), style = "bootstrap") 
    })
    

}

shinyApp(ui, server)
