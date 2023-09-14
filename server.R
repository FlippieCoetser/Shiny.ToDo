# Mock Storage do not need configuration details but does require mock data
# When using an Azure SQL Server, configuration details are needed
# Configuration details can be stored in .Reviron file and retrieved via Environment Package
configuration <- data.frame()

mock.data <- list()
mock.data[['Todo']] <- Todo.Data

storage <- configuration |> 
  Storage::Mock.Storage.Broker(mock.data) |>
  Storage::Storage.Service()

# Data Layer
data  <- storage |> Todo.Orchestration()

shinyServer(\(input, output, session) {
  Todo.Controller("todo", data)
})
