header  <- dashboardHeader(
  disable = TRUE
)
sidebar <- dashboardSidebar(
  disable = TRUE
)
body    <- dashboardBody(
  Todo.View("todo")
)

dashboardPage(
  header,
  sidebar,
  body
)