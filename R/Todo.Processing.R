Todo.Processing <- \(service) {
  processors <- list()
  processors[['Retrieve']] <- \() {
    service[['Retrieve']]()
  }
  processors[['Upsert']] <- \(todo) {
    exist <- todo[['Id']] |> service[['RetrieveById']]() |> nrow() > 0

    if(exist) {
      todo |> service[['Modify']]()
    } else {
      todo |> service[['Add']]()
    }
  }
  return(processors)
}
