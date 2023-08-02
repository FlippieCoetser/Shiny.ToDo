Todo.Processing <- \(service) {
  processors <- list()
  processors[['Retrieve']] <- \() {
    service[['Retrieve']]()
  }
  processors[['Upsert']] <- \() {}
  return(processors)
}
