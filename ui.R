stylesheet <- \() tags[['head']](
  tags[['link']](
    rel = "stylesheet",
    type = "text/css",
    href = "custom.css"
  )
)

customEvents <- \() tags[['script']]('
    $(document).ready(function(){
      $("#task").keypress(function(e){
        if (e.which == 13) {
          Shiny.onInputChange("create.Todo", Date.now())
        }
      })
    })
  ')

header <- dashboardHeader(disable = TRUE)
sidebar <- dashboardSidebar(disable = TRUE)
body <- dashboardBody(
  stylesheet(),
  customEvents(),
  fluidRow(
    box(
      title = div(icon("house")," Tasks"),
      status = "primary",
      solidHeader = TRUE,
      DT::dataTableOutput(
        "todos"
      ),
      textInput(
        "task",
        ""
      )
    )
  ),
  conditionalPanel(
    condition = "output.selectedTodoVisible",
    fluidRow(
      box(title = "Selected ToDo",
          status = "primary",
          solidHeader = TRUE,
          textInput("selected.Task", "Task"),
          textInput("selected.Status", "Status"),
          column(6,
                align = "right",
                offset = 5,
                actionButton("update.Todo", "Update"),
                actionButton("delete.Todo", "Delete")
          )
      )
    )
  )
)

dashboardPage(
  header,
  sidebar,
  body
)
