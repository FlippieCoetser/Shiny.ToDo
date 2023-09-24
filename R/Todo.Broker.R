Todo.Broker <- \(storage){
  sql.utilities <- Query::SQL.Utilities()
  sql.functions <- Query::SQL.Functions()

  table <- 'Todo'
  fields <- list(
    'Id'     |> sql.utilities[['BRACKET']]() |> sql.functions[['LOWER']]('Id'),
    'Task'   |> sql.utilities[['BRACKET']](),
    'Status' |> sql.utilities[['BRACKET']]()
  )
  
  operations <- list()
  operations[['Insert']]        <- \(todo) {
    todo |> storage[['Insert']](table)
  }
  operations[['Select']]        <- \(...)  {
    table |> storage[['Select']](fields)
  }
  operations[['SelectById']]    <- \(id)   {
    id |> storage[['SelectWhereId']](table, fields)
  }
  operations[['Update']]        <- \(todo) {
    todo |> storage[['Update']](table)
  }
  operations[['Delete']]        <- \(id)   {
    id |> storage[['Delete']](table)
  }
  return(operations)
}