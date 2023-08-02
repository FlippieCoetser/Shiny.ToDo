Todo.Processing <- \(service) {
  processors <- list()
  processors[['Retrieve']] <- \() {
    service[['Retrieve']]()
  }
  processors[['Upsert']] <- \(todo) {
    todo |> service[['Add']]()
  }
  return(processors)
}
