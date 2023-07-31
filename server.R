# Mock Storage do not need configuration details
# When using an Azure SQL Server, configuration details are needed
# Configuration details can be stored in .Reviron file and retrieved via Environment Package
configuration <- data.frame()
storage       <- configuration |> Storage::Mock.Storage.Service()

# Data Access Layer
data  <- storage |> Todo.Broker() |> Todo.Service()

shinyServer(\(input, output, session) {
  Todo.Controller("todo", data)
})
