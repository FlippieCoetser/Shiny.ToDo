Todo.Orchestration <- \(storage) {
  service <- storage |> Todo.Broker() |> Todo.Service()
  orchestrations <- list()
  orchestrations[['Add']] <- \(todo) {
    todo |> service[['Add']]()

    todos <- service[['Retrieve']]()
    return(todos)
  }
  orchestrations[['Retrieve']] <- \() {
    todos <- service[['Retrieve']]()
    return(todos)
  }
  orchestrations[['Update']] <- \(todo) {
    todo |> service[['Modify']]()

    todos <- service[['Retrieve']]()
    return(todos)
  }
  orchestrations[['Delete']] <- \(id) {
    id |> service[['Remove']]()

    todos <- service[['Retrieve']]()
    return(todos)
  }
  return(orchestrations)
}