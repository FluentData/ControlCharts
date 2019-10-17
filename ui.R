dashboardPage(
  dashboardHeaderPlus(title = "Control Charts"),
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      menuItem("Upload Data", icon = icon('upload'),
        file_upload_ui("data")
      ),
      menuItem("Data Exploration", icon = icon('eye'), tabName = "explore"),
      menuItem("Chart Generation", icon = icon('chart-bar'), tabName = "chart")
    )
  ),
  dashboardBody(
    tags$head(
      tags$script(src = "intro.js"),
      tags$script(src = "script.js"),
      tags$link(rel = 'stylesheet', href = 'introjs.css', type = 'text/css')
    ),
    tabItems(
      tabItem("explore",
        exploration_ui('explore')
      ),
      tabItem("chart",
        "World"
      )
    )
  )
)
