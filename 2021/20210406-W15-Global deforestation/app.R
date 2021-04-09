#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Deforestation"),

    # Sidebar with a slider input for number of bins 
        sidebarPanel(
            selectizeInput("entity",
                        "Country",
                        choices = unique(forest$entity),
                        selected = "China",
                        multiple = F)),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("forestPlot"),
           plotOutput("areaPlot")
        )
    )


# Define server logic required to draw a histogram
server <- function(input, output, session) {
    

    output$forestPlot <- renderPlot({
        forest %>% 
            ggplot(aes(year, net_forest_conversion, group = entity, color = entity))+
            geom_line(size = 2,show.legend = F)+
            gghighlight(entity == input$entity,
                        unhighlighted_params = list(size = 0.5))+
            scale_y_continuous(labels = scales::comma_format())+
            labs(title = "Change every 5 years for forest area in conversion",
                 x = "Year",
                 y = "Net forest conversion in hectares")+
            theme_light()
    })


    output$areaPlot <- renderPlot({
        forest_area %>% 
            ggplot(aes(year, forest_area, group = entity, color = entity))+
            geom_line(size = 2,show.legend = F)+
            gghighlight(entity == input$entity,
                        unhighlighted_params = list(size = 0.5))+
            labs(title = "Forest area as a percent of global forest area",
                 x = "Year",
                 y = "Percent of global forest area")+
            theme_light()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
