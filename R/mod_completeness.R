#' Completeness
#' 
#' In development
#' @rdname mod_completeness
#' @param id standard shiny id argument
#' @param label standard shiny label argument
#' @import naniar
#' @importFrom waiter autoWaiter
mod_completeness_ui <- function(id, label){
  ns <- NS(id)
  tabItem(tabName = label,
          
          fluidRow(
            
            box(
              width = 3
              ## Forms filter
              , selectInput(ns("forms"), "Form:", 
                          choices = 
                            c("esurgeries", 
                              "baseline", 
                              "outcome",
                              "treatment",
                              "allmedi",
                              "studyterminat",
                              "ae", "sae"),
                          selected = "baseline")
            )
          )
          
          , fluidRow(
            autoWaiter(),
            tabBox(width = 12,
                   title = "",
                   id = "tabset2",
                   height = "850px",
                   selected = "Completeness"
                   , tabPanel("Overview form",
                            height = "400",
                            plotlyOutput(ns('vis_miss'), height = "750")
                   )
                   , tabPanel("Variable missingness",
                              height = "400",
                              plotlyOutput(ns('var_miss'), height = "750")
                   )
                   , tabPanel("Case missingness",
                              height = "400",
                              plotlyOutput(ns('case_miss'), height = "750")
                   )
                   , tabPanel("Missingness pattern",
                              height = "300",
                              plotOutput(ns('miss_pattern'), height = "750")
                   )
            )
          )
  )
}

#' @rdname mod_completeness
#' @param input standard shiny input argument
#' @param output standard shiny output argument
#' @param session standard shiny session argument
#' @param data data for use in calculations
mod_completeness_server <- function(input, output, session, data){
  
  ns <- session$ns
  
  form_selected <- reactive({
    return(data[[input$forms]])
  })
  
  output$vis_miss <- renderPlotly({
    form_selected() %>% vis_miss %>% ggplotly
  })
  
  output$var_miss <- renderPlotly({
    form_selected() %>% gg_miss_var(show_pct = TRUE) %>% ggplotly
  })
  
  output$case_miss <- renderPlotly({
    form_selected() %>% gg_miss_case(show_pct = TRUE) %>% ggplotly
  })
  
  output$miss_pattern <- renderPlot({
    form_selected() %>% gg_miss_upset(text.scale = 3, nsets = ncol(form_selected()))
  })

}
