Todo.Orchestration <- \(storage) {
  service <- storage |> Todo.Broker() |> Todo.Service()
  orchestrations <- list()
  orchestrations[['Add']] <- \(todo) {
    todo |> service[['Add']]()

    todos <- service[['Retrieve']]()
    return(todos)
  }
  return(orchestrations)
}