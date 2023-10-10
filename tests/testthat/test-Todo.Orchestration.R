describe('Given Todo.Orchestration',{
  it('exist',{
    # Given
    Todo.Orchestration |> expect.exist()
  })
})

describe('When orchestrations <- storage |> Todo.Orchestration()',{
  it('then operations is a list',{
    # When
    orchestrations <- storage |> Todo.Orchestration()

    # Then
    orchestrations |> expect.list()
  })
  it('then orchestrations contain UpsertRetrieve orchestration',{
    # When
    orchestrations <- storage |> Todo.Orchestration()

    # Then
    orchestrations[['UpsertRetrieve']] |> expect.exist()
  })
  it('then orchestrations contain Retrieve orchestration',{
    # When
    orchestrations <- storage |> Todo.Orchestration()

    # Then
    orchestrations[['Retrieve']] |> expect.exist()
  })
  it('then orchestrations contain DeleteRetrieve orchestration',{
    # When
    orchestrations <- storage |> Todo.Orchestration()

    # Then
    orchestrations[['DeleteRetrieve']] |> expect.exist()
  })
})

describe('When todo |> orchestrate[["UpsertRetrieve"]]()',{
  it('then a data.frame with todos containing new todo is returned',{
    # Given    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

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
    # Given    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    orchestrate <- storage |> Todo.Orchestration()

    existing.todo <- table |> storage[['Retrieve']](fields) |> tail(1)

    updated.todo  <- existing.todo
    updated.todo[['task']] <- 'Updated Task'
    
    expected.todo <- updated.todo

    # When
    retrieved.todos <- updated.todo |> orchestrate[['UpsertRetrieve']]()
    retrieved.todo  <- retrieved.todos[retrieved.todos[['id']] == updated.todo[['id']],] 

    # Then
    retrieved.todos |> expect.contain(expected.todo)

    retrieved.todo[['id']]     |> expect.equal(expected.todo[['id']])
    retrieved.todo[['task']]   |> expect.equal(expected.todo[['task']])
    retrieved.todo[['status']] |> expect.equal(expected.todo[['status']])
  })
})

describe('When orchestrate[["Retrieve"]]()',{
  it('then a data.frame with todos is returned',{
    # Given    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    orchestrate <- storage |> Todo.Orchestration()

    actual.todos   <- table |> storage[['Retrieve']](fields)
    expected.todos <- actual.todos

    # When
    retrieved.todos <- orchestrate[['Retrieve']]()

    # Then
    retrieved.todos |> expect.equal(expected.todos)
  })
})

describe("When id |> orchestrate[['DeleteRetrieve']]()",{
  it("then a data.frame with todos excluding todo with id is returned",{
    # Given    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    orchestrate <- storage |> Todo.Orchestration()

    existing.todo <- table |> storage[['Retrieve']](fields) |> tail(1)
    existing.id <- existing.todo[['id']]

    # When 
    retrieved.todos <- existing.id |> orchestrate[['DeleteRetrieve']]()

    # Then
    retrieved.todos |> expect.not.contain(existing.todo)
  })
})