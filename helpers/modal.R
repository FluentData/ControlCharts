modal <- function() {
  
  tags$div(class="modal fade", id="introModal", tabindex="-1",
           tags$div(class="modal-dialog",
                    tags$div(class="modal-content",
                             tags$div(class="modal-header",
                                      tags$button(type="button", class="close", `data-dismiss`="modal",
                                                  icon("times")
                                      ),
                                      tags$h4(class="modal-title", id="myModalLabel", "Control Charts")
                             ),
                             tags$div(class="modal-body",
                                      tags$p("This app can be used to create control charts for data uploaded as a .csv file.",
                                             "The charts are generated using the ", 
                                             tags$a(href = "https://anhoej.github.io/qicharts2/", target = "_blank", "qicharts package")),
                                      tags$p("You can dive in by closing this dialog and uploading your own file or you may run a quick tutorial",
                                             "with an example file by clicking `Start Tutorial` below.")
                                      
                             ),
                             tags$div(class="modal-footer",
                                      tags$button(type="button", class="btn btn-default", `data-dismiss`="modal", "Close"),
                                      tags$button(type="button", class="btn btn-primary", "Start Tutorial", onclick = "start_tutorial()")
                             )
                    )
           )
  )  
  
}
