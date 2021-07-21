#load libraries
library(shiny)
library(shinythemes)
library(tidyverse)
library(CodeClanData)


# ui ----------------------------------------------------------------------

ui <- fluidPage(
    theme = shinytheme("superhero"),
    
    titlePanel(tags$h1("Five Country Medal Comparison")),
    
    navbarPage("Olympics",
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
                 column(12, plotOutput("medal_plot")
                        )                
            )
        ),
        tabPanel("The Olympic Website",
            tags$a("Click here", href = "https://www.olympics.com/")
        ),
        tabPanel("All Medal Winners Comparison")
    )
)


# server ------------------------------------------------------------------
server <- function(input, output) {
    output$medal_plot <- renderPlot({
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
}

# Run the application 
shinyApp(ui = ui, server = server)