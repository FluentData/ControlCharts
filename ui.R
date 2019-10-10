library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinydashboardPlus)
library(shinyjs)

addHelpBlock <- function(x, help_text = "") {
  
  id <- x$children[[1]]$attribs$`for`
  
  help_block <- tags$span(id = paste0(id, "_help_block"), class = 'shiny-text-output help-block', help_text)
  
  x$children[[length(x$children) + 1]] <- help_block
  
  return(x)
  
}

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

dashboardPage(
  dashboardHeaderPlus(title = "Control Charts"),
                dashboardSidebar(disable = TRUE),
                dashboardBody(
                  tags$head(
                    tags$script(src = "intro.js"),
                    tags$script(src = "script.js"),
                    tags$link(rel = 'stylesheet', href = 'introjs.css', type = 'text/css')
                  ),
                  modal(),
                  useShinyjs(),
                  fluidRow(
                    column(width = 3, `data-step` = 1, `data-position` = 'right', `data-intro` = "The left column contains the controls you will use to create your chart",
                      box(id = "upload_box", width = NULL, title = tagList(icon("upload"), "Upload Data"), `data-step` = 3, `data-position` = 'right', `data-intro` = "The `Upload Data` box is where you upload your csv file for processing. For this tutorial we will load the example data file `gtt.csv`.",
                          collapsible = TRUE,
                          tags$p("Use this Upload Data box to upload your dataset. The file must be a flat comma separated (.csv) file with headers."),
                          fileInput("source_file", "", multiple = FALSE,
                            accept = c("text/csv",
                                       "text/comma-separated-values,text/plain",
                                       ".csv")
                          ),
                          tags$button(id = "file_next", class = "pull-right btn btn-default", disabled = 'disabled', onclick = 'open_box("typing_box")', "Next", icon("arrow-right"))
                      ),
                      tags$span(`data-step` = 4, `data-intro` = "The `Data Typing` box  allows you to tell the app about the data you uploaded.",
                        box(id = "typing_box", width = NULL, title = tagList(icon("project-diagram"), "Data Typing"), collapsible = TRUE, collapsed = TRUE, 
                          tags$p("This Data Typing box allows you to categorize the type of data you are uploading so that the right control chart can be selected. The selections are based on the flow chart on page 151 of The Health Care Data Guide."),
                          addHelpBlock(selectizeInput("data_type", label = "Type of Data",
                                                                   choices = c("Count or Classification",
                                                                               "Continuous")), "Testing"),
                          conditionalPanel(
                            condition = "input.data_type == 'Count or Classification'",
                            addHelpBlock(selectInput("nonconformities", label = "Nonconformities",
                              choices = c("Count", "Classification")
                            )),
                            addHelpBlock(selectInput("opportunity", label = "Area of Opportunity",
                              choices = c("Equal", "Unequal")
                            ))
                          ),
                          conditionalPanel(
                            condition = "input.data_type == 'Continuous'",
                            addHelpBlock(selectInput("subgroups", label = "Subgroups",
                              choices = c("Single Observation", "Multiple Values")
                            ))
                          ),
                          tags$button(id = "file_next", class = "pull-right btn btn-default", onclick = 'open_box("chart_box")', "Next", icon("arrow-right"))
                        )
                      ),
                      box(id = "chart_box", width = NULL, title = tagList(icon("chart-line"), "Chart Options"), collapsible = TRUE, collapsed = TRUE,
                        tags$p("Once your data is uploaded and it's type is categorized, the Control Chart sidebar item can be used to create a control chart that can be downloaded."),
                        addHelpBlock(selectInput("chart_type", label = "Chart Type", choices = c())),
                        addHelpBlock(selectInput("x_axis", label = "X-Axis", choices = c()), "Choose a column in the dataset for the x-axis"),
                        addHelpBlock(selectInput("y_axis", label = "Y-Axis", choices = c()), "Choose a column in the dataset for the y-axis"),
                        addHelpBlock(selectInput("n", label = "N", choices = c()), "Subgroup sizes (denominator)"),
                        tags$button(id = "file_next", class = "pull-right btn btn-default", onclick = 'open_box("label_box")', "Next", icon("arrow-right"))
                      ),
                      box(id = "label_box", width = NULL, title = tagList(icon("tags"), "Chart Labels"), collapsible = TRUE, collapsed = TRUE,
                          addHelpBlock(textInput("main_title", label = "Main Title")),
                          addHelpBlock(textInput("x_title", label = "X-axis Label")),
                          addHelpBlock(textInput("y_title", label = "Y-axis Label")),
                          tags$button(id = "file_next", class = "pull-right btn btn-default", onclick = 'open_box("download_box")', "Next", icon("arrow-right"))
                      ),
                      box(id = "download_box", width = NULL, title = tagList(icon("download"), "Download Chart"), collapsible = TRUE, collapsed = TRUE,
                        fluidRow(
                          column(width = 4, numericInput('chart_width', "Width", value = 1920)),
                          column(width = 4, numericInput('chart_height', "Height", value = 768)),
                          column(width = 4, selectInput('size_units', "Units", choices = c('pixels', 'in', 'cm', 'mm'), selected = 'pixels'))
                        ),
                        downloadButton("download_chart", "Download Chart"),
                        tags$button(id = "restart", class = "action-button pull-right btn btn-default", onclick = 'reset_app()', "Restart", icon("undo"))

                      )
                    ),
                    column(width = 9, `data-step` = 2, `data-intro` = "The right column allows you to see your data and/or the chart as your work.",
                      tabBox(width = NULL,
                        tabPanel("File Preview",
                          tags$h3(style = "text-align: center", textOutput("file_preview_help")),
                          DT::DTOutput("file_preview")         
                        ),
                        tabPanel("Data Typing",
                          tags$h3(style = "text-align: center", textOutput("data_typing_help")),
                          tableOutput("data_typing_table")
                        ),
                        tabPanel("Control Chart",
                          tags$h3(style = "text-align: center", textOutput("control_chart_help")),
                          plotOutput("control_chart")         
                        )
                      )       
                    )
                  )
                    
))
