actionItem <- function(inputId, label, icon = NULL) {
  
  tags$li(
    tags$a(id = inputId, href = "#", class = "action-button", style = "margin: 0",
           icon,
           tags$span(label)
    )
  )
  
}