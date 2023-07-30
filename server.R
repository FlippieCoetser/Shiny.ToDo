configuration <- data.frame()
storage       <- configuration |> Storage::Mock.Storage.Service()
todo.broker   <- storage |> Todo.Broker()
data  <- todo.broker |> Todo.Service()

shinyServer(\(input, output, session) {

  create.todo <- \(task) data.frame(
    Id = uuid::UUIDgenerate(),
    Task = task,
    Status = "New"
  )

  # EVENT BINDING
  # For all user gestures triggered in UI and Event is defined and binded to a specific user workflow
  observeEvent(input[["create.Todo"]],         { workflow[["create.Todo"]]() })
  observeEvent(input[["todos_rows_selected"]], { workflow[["select.Todo"]]() }, ignoreNULL = FALSE )
  observeEvent(input[["update.Todo"]],         { workflow[["update.Todo"]]() })
  observeEvent(input[["delete.Todo"]],         { workflow[["delete.Todo"]]() })

  # STATE
  # Example app includes a states for:
  # 1. List of Todos
  # 2. a specific Todo
  state <- reactiveValues()
  state[["todos"]] <- data[['Retrieve']]()
  state[["todo"]]  <- NULL

  validation <- NULL
  validation[["isTaskEmpty"]]    <- reactive(input[["task"]] == '')
  validation[["isTodoSelected"]] <- reactive(!is.null(input[["todos_rows_selected"]]))

  # USER WORKFLOWS
  # Workflow are used to update state and execute other Logic or Data layer datas
  workflow <- NULL
  workflow[["create.Todo"]] <- \() {
    if (!validation[["isTaskEmpty"]]()) {
      input[["task"]] |>
        create.todo() |>
        data[["Add"]]()

      state[["todos"]] <- data[['Retrieve']]()

      session |> updateTextInput("task", value = '')
    }
  }
  workflow[["select.Todo"]] <- \() {
    if (validation[["isTodoSelected"]]()) {
      selectedRow <- input[["todos_rows_selected"]]
      state[["todo"]] <- state[["todos"]][selectedRow, ]

      session |> updateTextInput("selected.Task", value = state[["todo"]][["Task"]])
      session |> updateTextInput("selected.Status", value = state[["todo"]][["Status"]])
    } else {
      state[["todo"]] <- NULL
    }
  }
  workflow[["update.Todo"]] <- \() {
    todo <- data.frame(
      Id = state[["todo"]][["Id"]],
      Task = input[["selected.Task"]],
      Status = input[["selected.Status"]]
    ) |> data[["Update"]]()

    state[["todos"]] <- data[['Retrieve']]()
  }
  workflow[["delete.Todo"]] <- \() {
    state[["todo"]][["Id"]] |> data[['Delete']]()
    state[["todos"]] <- data[['Retrieve']]()
  }

  # OUTPUT BINDING
  # Todos:
  # List of current todos
  output[["todos"]] <- DT::renderDataTable({
    DT::datatable(
      state[["todos"]] |> select(Id, Status, Task),
      selection = 'single',
      rownames = FALSE,
      colnames = c("", ""),
      options = list(
        dom = "t",
        ordering = FALSE,
        columnDefs = list(
          list(visible = FALSE, targets = 0),
          list(width = '50px', targets = 1),
          list(className = 'dt-center', targets = 1),
          list(className = 'dt-left', targets = 2)
        )
      )
    )
  })

  # UI VISIBILITY: Conditional Panels
  output[["selectedTodoVisible"]] <- reactive({ is.data.frame(state[["todo"]]) })

  # CONFIGURATION
  outputOptions(output, "selectedTodoVisible", suspendWhenHidden = FALSE)

})
