Todo.Controller <- \(id, data) {
  moduleServer(
    id,
    \(input, output, session) {
      # Local State
      state <- reactiveValues()
      state[["todos"]] <- data[['Retrieve']]()
      state[["todo"]]  <- NULL
      
     # Input Binding
      observeEvent(input[['create']], { coordinator[['create']](input[["newTask"]]) })
      observeEvent(input[["todos_rows_selected"]], { coordinator[["select"]](input[["todos_rows_selected"]]) }, ignoreNULL = FALSE )
      observeEvent(input[["update"]], { coordinator[["update"]]() })
      observeEvent(input[["delete"]], { coordinator[["delete"]]() })

      # Input Verification
      verification <- NULL
      verification[["isTaskEmpty"]] <- reactive(input[["newTask"]] == '')
      verification[["isTodoSelected"]] <- reactive(!is.null(input[["todos_rows_selected"]]))

      # User Actions
      coordinator <- list()
      coordinator[['create']] <- \(task) {
        if (!verification[["isTaskEmpty"]]()) {
          # Use the data layer to create a new todo
          task |> Todo.Model() |> data[['Add']]()
          # Use the data layer to update local state
          state[["todos"]] <- data[['Retrieve']]()
          # Clear the input
          session |> updateTextInput("task", value = '')
        }
      }
      coordinator[['select']] <- \(id) {
        if (verification[["isTodoSelected"]]()) {
          state[["todo"]] <- state[["todos"]][id,]

          session |> updateTextInput("task", value = state[["todo"]][["Task"]])
          session |> updateTextInput("status", value = state[["todo"]][["Status"]])

        } else {
          state[["todo"]] <- NULL
        }
      }
      coordinator[['update']] <- \() {
        state[['todo']][["Task"]] <- input[["task"]]
        state[['todo']][["Status"]] <- input[["status"]]

        state[['todo']] |> data[["Modify"]]()
 
        state[["todos"]] <- data[['Retrieve']]()
      }
      coordinator[['delete']] <- \() {
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
