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
mock.data[['Todo']] <- data.frame(
  Id     = c('7ab3df6f-2e8f-44b4-87bf-3004cf1c16ae',
            '7bfef861-6fe9-46da-9ad2-6a58779ccdcd',
            'd3b59bf0-14f0-4444-9ec9-1913e7256ee4'),
  Task   = c('Task.1','Task.2','Task.3'),
  Status = c('New','New','Done')
)

# Mock Storage Service Initialization
storage <- configuration |> Storage::Storage('Mock', mock.data)

# Mock Storage Service Test Extensions
storage[['Todo']][['SelectWhereId']] <- \(id) {
  table.fields[['Todo']] |> storage[['SelectWhereId']](table.name[['Todo']], id)
}
storage[['Todo']][['Select']] <- \() {
  table.fields[['Todo']] |> storage[['Select']](table.name[['Todo']])
}