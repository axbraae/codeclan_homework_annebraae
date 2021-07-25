#Game Finder app
#App to help users pick a game by genre, rating, developer or platform

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

#shows the user which developer makes the most games for the selected genre
#useful as this information can be used to filter the game names table
    output$developer_plot <- renderPlot({
        filtered_games() %>% 
            ggplot() +
            aes(x = genre, fill = developer) +
            geom_bar(alpha = 0.6) +
            theme_minimal() +
            labs(title = input$genre_input,
                 subtitle = "Game Developers",
                 x = "", fill = "Developers")
    })

#user and critic scores indicate the popularity of the selected game genre
#indicates how much the user will enjoy the games in their chosen genre 
    output$score_plot <- renderPlot({
        filtered_games() %>% 
            ggplot() +
            aes(x = score, fill = scored_by) +
            geom_density(alpha = 0.6) +
            theme_minimal() +
            labs(title = input$genre_input,
                 subtitle = "Scores from critics and users",
                 x = "", fill = "Score")
    })

#the table generates a list of games the user to play based on user selections
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
