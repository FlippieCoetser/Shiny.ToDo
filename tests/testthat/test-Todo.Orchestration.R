describe('Given Todo.Orchestration',{
  it('exist',{
    # Given
    Todo.Orchestration |> expect.exist()
  })
})

describe('When orchestrations <- storage |> Todo.Orchestration()',{
  it('then operations is a list',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    # When
    orchestrations <- storage |> Todo.Orchestration()

    # Then
    orchestrations |> expect.list()
  })
  it('then orchestrations contain UpsertRetrieve orchestration',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    # When
    orchestrations <- storage |> Todo.Orchestration()

    # Then
    orchestrations[['UpsertRetrieve']] |> expect.exist()
  })
  it('then orchestrations contain Retrieve orchestration',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    # When
    orchestrations <- storage |> Todo.Orchestration()

    # Then
    orchestrations[['Retrieve']] |> expect.exist()
  })
  it('then orchestrations contain DeleteRetrieve orchestration',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    # When
    orchestrations <- storage |> Todo.Orchestration()

    # Then
    orchestrations[['DeleteRetrieve']] |> expect.exist()
  })
})

describe('When todo |> orchestrate[["UpsertRetrieve"]]()',{
  it('then a data.frame with todos containing new todo is returned',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    orchestrate <- storage |> Todo.Orchestration()

    random.todo <- 'Task' |> Todo.Model()

    new.todo      <- random.todo
    expected.todo <- new.todo 

    # When
    retrieved.todos <- new.todo |> orchestrate[["UpsertRetrieve"]]()

    # Then
    retrieved.todos |> expect.contain(expected.todo)
  })
  it("then a data.frame with todos containing update todo is returned",{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    orchestrate <- storage |> Todo.Orchestration()

    existing.todo <- storage[['Todo']][['Select']]() |> tail(1)

    updated.todo  <- existing.todo
    updated.todo[['Task']] <- 'Updated Task'
    
    expected.todo <- updated.todo

    # When
    retrieved.todos <- updated.todo |> orchestrate[['UpsertRetrieve']]()
    retrieved.todo  <- retrieved.todos[retrieved.todos[['Id']] == updated.todo[['Id']],] 

    # Then
    retrieved.todos |> expect.contain(expected.todo)

    retrieved.todo[['Id']]     |> expect.equal(expected.todo[['Id']])
    retrieved.todo[['Task']]   |> expect.equal(expected.todo[['Task']])
    retrieved.todo[['Status']] |> expect.equal(expected.todo[['Status']])
  })
})

describe('When orchestrate[["Retrieve"]]()',{
  it('then a data.frame with todos is returned',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    orchestrate <- storage |> Todo.Orchestration()

    actual.todos   <- storage[['Todo']][['Select']]()
    expected.todos <- actual.todos

    # When
    retrieved.todos <- orchestrate[['Retrieve']]()

    # Then
    retrieved.todos |> expect.equal(expected.todos)
  })
})

describe("When id |> orchestrate[['DeleteRetrieve']]()",{
  it("then a data.frame with todos excluding todo with id is returned",{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    orchestrate <- storage |> Todo.Orchestration()

    existing.todo <- storage[['Todo']][['Select']]() |> tail(1)
    existing.id <- existing.todo[['Id']]

    # When 
    retrieved.todos <- existing.id |> orchestrate[['DeleteRetrieve']]()

    # Then
    retrieved.todos |> expect.not.contain(existing.todo)
  })
})