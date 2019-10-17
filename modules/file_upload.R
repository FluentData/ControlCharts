file_upload_ui <- function(id) {
  
  ns <- NS(id)
  
  fileInput(ns("source_file"), NULL, multiple = FALSE,
            accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")
  )   
  
}

file_upload_server <- function(input, output, session) {
  
  values <- reactiveValues(source_data = NULL)
  
  observeEvent(input$source_file, {
    
    req(input$source_file)
    
    tryCatch(
      {
        df <- readr::read_csv(input$source_file$datapath)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    
    values$source_data <- df
    
  })
  
  x <- reactive({
    return(values$source_data)
  })

  return(x)
  
}