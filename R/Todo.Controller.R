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
          state[["todos"]] <- input[["newTask"]] |> Todo.Model() |> data[['UpsertRetrieve']]()
          # Clear the input
          session |> updateTextInput("task", value = '')
        }
      }
      controller[['select']] <- \() {
        if (verify[["todoSelected"]]()) {
          state[["todo"]] <- state[["todos"]][input[["todos_rows_selected"]],]

          session |> updateTextInput("task", value = state[["todo"]][["Task"]])
          session |> updateTextInput("status", value = state[["todo"]][["Status"]])

        } else {
          state[["todo"]] <- NULL
        }
      }
      controller[['update']] <- \() {
        state[['todo']][["Task"]]   <- input[["task"]]
        state[['todo']][["Status"]] <- input[["status"]]

        state[["todos"]] <- state[['todo']] |> data[["UpsertRetrieve"]]()
      }
      controller[['delete']] <- \() {
        state[["todos"]] <- state[["todo"]][["Id"]] |> data[['DeleteRetrieve']]()
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
