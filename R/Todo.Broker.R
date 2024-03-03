Todo.Broker <- \(storage){
  sql.utilities <- Query::SQL.Utilities()
  sql.functions <- Query::SQL.Functions()

  table <- 'ToDo'
  fields <- list(
    'id'     |> sql.utilities[['BRACKET']]() |> sql.functions[['LOWER']]('id'),
    'task'   |> sql.utilities[['BRACKET']](),
    'status' |> sql.utilities[['BRACKET']]()
  )
  
  operations <- list()
  operations[['Insert']]        <- \(todo) {
    todo |> storage[['Add']](table)
  }
  operations[['Select']]        <- \(...)  {
    table |> storage[['Retrieve']](fields)
  }
  operations[['SelectById']]    <- \(id)   {
    id |> storage[['RetrieveWhereId']](table, fields)
  }
  operations[['Update']]        <- \(todo) {
    todo |> storage[['Modify']](table)
  }
  operations[['Delete']]        <- \(id)   {
    id |> storage[['Remove']](table)
  }
  return(operations)
}