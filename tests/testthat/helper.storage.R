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

# Mock Storage Service Initialization
storage <- configuration |> Storage::Storage('memory')

# Mock Storage Service Test Extensions
storage[['Todo']][['SelectWhereId']] <- \(id) {
  id |> storage[['RetrieveWhereId']](table.name[['Todo']], table.fields[['Todo']])
}
storage[['Todo']][['Select']] <- \() {
  table.name[['Todo']] |> storage[['Retrieve']](table.fields[['Todo']])
}