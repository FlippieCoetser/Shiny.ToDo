header <- dashboardHeader(disable = TRUE)
sidebar <- dashboardSidebar(disable = TRUE)
body <- dashboardBody(
  tags[['head']](
    tags[['link']](
      rel = "stylesheet",
      type = "text/css",
      href = "custom.css"
    )
  ),
  Todo.View("component")
)

dashboardPage(
  header,
  sidebar,
  body
)