# Mock Storage 

# Mock Broker Configuration
configuration <- data.frame()

# Mock Broker table name, fields, and data
sql.utilities <- Query::SQL.Utilities()
sql.functions <- Query::SQL.Functions()

table.name <- list()
table.name[['Todo']] <- 'Todo'

table.fields <- list()
table.fields[['Todo']] <- list(
  'Id'     |> sql.utilities[['BRACKET']]() |> sql.functions[['LOWER']]('Id'),
  'Task'   |> sql.utilities[['BRACKET']](),
  'Status' |> sql.utilities[['BRACKET']]()
)

mock.data <- list()
mock.data[['Todo']] <- Todo.Data

# Mock Storage Service Initialization
storage <- configuration |> 
  Storage::Mock.Storage.Broker(mock.data) |> 
  Storage::Storage.Service()

# Mock Storage Service Test Extensions
storage[['Todo']][['SelectWhereId']] <- \(id) {
  table.fields[['Todo']] |> storage[['SelectWhereId']](table.name[['Todo']], id)
}
storage[['Todo']][['Select']] <- \() {
  table.fields[['Todo']] |> storage[['Select']](table.name[['Todo']])
}