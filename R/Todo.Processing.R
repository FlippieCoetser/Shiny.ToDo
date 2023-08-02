Todo.Processing <- \(service) {
  processors <- list()
  processors[['Retrieve']] <- \() {
    service[['Retrieve']]()
  }
  return(processors)
}
