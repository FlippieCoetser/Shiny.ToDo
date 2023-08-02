Todo.Controller <- \(id, data) {
  moduleServer(
    id,
    \(input, output, session) {
      # Local State
      state <- reactiveValues()
      state[["todos"]] <- data[['Retrieve']]()
      state[["todo"]]  <- NULL

      # Input Binding
      observeEvent(input[['create']], { controller[['create']]() })
      observeEvent(input[["todos_rows_selected"]], { controller[["select"]]() }, ignoreNULL = FALSE )
      observeEvent(input[["update"]], { controller[["update"]]() })
      observeEvent(input[["delete"]], { controller[["delete"]]() })

      # Input Verification
      verify <- list()
      verify[["taskEmpty"]]    <- reactive(input[["newTask"]] == '')
      verify[["todoSelected"]] <- reactive(!is.null(input[["todos_rows_selected"]]))

      # User Actions
      controller <- list()
      controller[['create']] <- \() {
        if (!verify[["taskEmpty"]]()) {
          # Use the data layer to create a new todo
          input[["newTask"]] |> Todo.Model() |> data[['Add']]()
          # Use the data layer to update local state
          state[["todos"]] <- data[['Retrieve']]()
          # Clear the input
          session |> updateTextInput("task", value = '')
        }
      }
      controller[['select']] <- \() {
        if (verify[["todoSelected"]]()) {
          id <- input[["todos_rows_selected"]]
          state[["todo"]] <- state[["todos"]][id,]

          session |> updateTextInput("task", value = state[["todo"]][["Task"]])
          session |> updateTextInput("status", value = state[["todo"]][["Status"]])

        } else {
          state[["todo"]] <- NULL
        }
      }
      controller[['update']] <- \() {
        state[['todo']][["Task"]] <- input[["task"]]
        state[['todo']][["Status"]] <- input[["status"]]

        state[['todo']] |> data[["Modify"]]()
 
        state[["todos"]] <- data[['Retrieve']]()
      }
      controller[['delete']] <- \() {
        state[["todo"]][["Id"]] |> data[['Remove']]()
        state[["todos"]] <- data[['Retrieve']]()
      }

      # Output Bindings
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
      output[["isSelectedTodoVisible"]] <- reactive({ is.data.frame(state[["todo"]]) })
      outputOptions(output, "isSelectedTodoVisible", suspendWhenHidden = FALSE) 
    }
  )
}
