addHelpBlock <- function(x, help_text = "") {
  
  id <- x$children[[1]]$attribs$`for`
  
  help_block <- tags$span(id = paste0(id, "_help_block"), class = 'shiny-text-output help-block', help_text)
  
  x$children[[length(x$children) + 1]] <- help_block
  
  return(x)
  
}
