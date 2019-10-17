exploration_ui <- function(id) {
  
  ns <- NS(id)
  
  fluidRow(
    column(width = 6,
      fluidRow(
        valueBox("4", "Calling Birds", color = "blue", icon = icon("crow")),
        valueBox("3", "French Hens", color = "green", icon = icon("kiwi-bird")),
        valueBox("2", "Turtle Doves", color = 'orange', icon = icon('dove'))
      ),
      tabBox(id = ns("tables"), width = NULL,
        tabPanel(title = "File Preview", status = "primary", DT::DTOutput(ns('file_preview'))),
        tabPanel(title = "Data Summary", status = "primary", tableOutput(ns('data_summary')))
      )
    ),
    column(width = 6,
      box(title = "Example Charts", width = NULL, status = 'primary', "Charts go here")       
    )
  )
  
}

exploration_server <- function(input, output, session, data) {
  
  typing_data <- reactive({
    
    d <- data()
    
    data_type <- function(x) {
      
      if(is.character(x)) {
        return("Classification")
      } else if(is.numeric(x)) {
        if(length(unique(x[!is.na(x)])) / sum(!is.na(x)) > 0.25) {
          return("Continuous")
        } else {
          return("Count")
        }
      } else {
        return("Date")
      }
      
    }
    
    x <- lapply(colnames(d), function(cn) {
      
      list(
        "Column Name" = cn,
        "Data Class" = class(d[[cn]]),
        "Unique Values" = length(unique(d[[cn]][!is.na(d[[cn]])])),
        "Non-NA Values" = sum(!is.na(d[[cn]])),
        "Data Type" = as.character(tags$span(style = "font-weight: bold", data_type(d[[cn]])))
      )
      
    })
    
    y <- as.data.frame(matrix(unlist(x), ncol = length(unlist(x[1])), byrow = TRUE))
    
    colnames(y) <- c("Column Name", "Data Class", "Unique Value Count", "Non-NA Value Count", "Calculated Data Type")
    
    y
    
  })
  
  output$file_preview <- renderDT({

    datatable(
      data(), extensions = 'FixedColumns',
      options = list(
        dom = 't',
        scrollX = TRUE,
        fixedColumns = TRUE
      )
    )
    
  })

  output$data_summary <- renderTable({
    typing_data()
  }, sanitize.text.function = function(x) x) 
  
}