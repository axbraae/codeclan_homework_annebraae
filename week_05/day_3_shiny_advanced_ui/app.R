#load libraries
library(shiny)
library(shinythemes)
library(tidyverse)
library(CodeClanData)

all_teams <- unique(olympics_overall_medals$team)

# ui ----------------------------------------------------------------------

ui <- fluidPage(
    theme = shinytheme("superhero"),
    
    titlePanel(tags$h1("Olympics Medals Summary")),
    
    navbarPage("",
               tabPanel("Five Country Medal Comparison",
                        fluidRow(
                 column(6, radioButtons(inputId = "season_input",
                              tags$h4("Summer or Winter Olympics"),
                              choices = c("Summer", "Winter")
                              )
                         ),
                 column(6, radioButtons(inputId = "medal_input",
                              tags$h4("Medal Type"),
                              choices = c("Gold", "Silver", "Bronze")
                              )
                        ),
                 column(12, plotOutput("medal_5_plot")
                        )                
            )
        ),
        tabPanel("All Medal Winners Comparison",
                 fluidRow(
                 column(6, selectInput("team_input",
                             "Which team?",
                             choices = all_teams)
                        ),
                 #column(6, radioButtons(inputId = "season_input", #removed for now
                              #"Summer or Winter Olympics",
                              #choices = c("Summer", "Winter"))
                        #),
                 column(12, plotOutput("medal_plot")
                        )
                 )
        ),
        tabPanel("The Olympic Website",
                 tags$a("Click here", href = "https://www.olympics.com/")
        )
    )
)


# server ------------------------------------------------------------------
server <- function(input, output) {
    output$medal_5_plot <- renderPlot({
        olympics_overall_medals %>%
            filter(team %in% c("United States",
                               "Soviet Union",
                               "Germany",
                               "Italy",
                               "Great Britain")) %>%
            filter(medal == input$medal_input) %>%
            filter(season == input$season_input) %>%
            ggplot() +
            aes(x = team, y = count, fill = medal) +
            geom_col() +
            scale_fill_manual(
                values = c(
                    "Gold" = "gold",
                    "Silver" = "gray75",
                    "Bronze" = "orange"
                )) +
            theme(
                legend.position = "none"
            )
    })
    
    output$medal_plot <- renderPlot({
        olympics_overall_medals %>% 
            filter(team == input$team_input) %>% 
            #filter(season == input$season_input) %>% 
            ggplot() +
            aes(x = medal, y = count, fill = medal) +
            geom_col() +
            facet_wrap(~season) +
            scale_fill_manual(
                values = c(
                    "Gold" = "gold",
                    "Silver" = "gray75",
                    "Bronze" = "orange"
                ))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)