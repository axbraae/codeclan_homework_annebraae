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
               tabPanel("Overview",
                   column(6, tableOutput("summary_table")
                   ),
                   column(12, img(src = "https://upload.wikimedia.org/wikipedia/commons/8/82/Olympic_Rings_black.svg",
                                  height = 155, width = 320))
               ),
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
                 #removing for now because I will try faceting the graph
                 #column(6, radioButtons(inputId = "season_input", 
                              #"Summer or Winter Olympics",
                              #choices = c("Summer", "Winter"))
                        #),
                 column(12, plotOutput("medal_plot")
                        ),
                 )
        ),
        tabPanel("The Olympic Website",
                 "To link out to the Olympic Website: ",
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
            theme_minimal() +
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
                )) +
            theme_minimal() +
            theme(
                panel.spacing = unit(.05, "lines"),
                panel.border = element_rect(color = "black", fill = NA, size = 1)
            )
    })
    output$summary_table <- renderTable({
        head(
        olympics_overall_medals %>% 
            summarise("Total Countries" = n_distinct(team),
                      "Total Gold Medals" = sum(medal == "Gold"),
                      "Total Silver Medals" = sum(medal == "Silver"),
                      "Total Bronze Medals" = sum(medal == "Bronze")))
    },
    bordered = TRUE,
    align = 'l')
}

# Run the application 
shinyApp(ui = ui, server = server)