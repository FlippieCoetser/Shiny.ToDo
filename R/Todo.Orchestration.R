Todo.Orchestration <- \(storage) {
  process <- storage |> Todo.Broker() |> Todo.Service() |> Todo.Processing()
  orchestrations <- list()
  orchestrations[['Add']]      <- \(todo) {
    todo |> process[['Upsert']]()

    todos <- process[['Retrieve']]()
    return(todos)
  }
  orchestrations[['Retrieve']] <- \() {
    todos <- process[['Retrieve']]()
    return(todos)
  }
  orchestrations[['Update']]   <- \(todo) {
    todo |> process[['Upsert']]()

    todos <- process[['Retrieve']]()
    return(todos)
  }
  orchestrations[['Delete']]   <- \(id) {
    id |> process[['Remove']]()

    todos <- process[['Retrieve']]()
    return(todos)
  }
  return(orchestrations)
}