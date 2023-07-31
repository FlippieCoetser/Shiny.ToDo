describe('Given Todo.Broker',{
  it('exist',{
    # Given
    Todo.Broker |> expect.exist()
  })
})

describe('When operations <- storage |> Todo.Broker()',{
  it('then operations is a list',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    # When
    operations <- storage |> Todo.Broker()

    # Then
    operations |> expect.list()
  })
  it('then operations contains Insert operation',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    # When
    operations <- storage |> Todo.Broker()

    # Then
    operations[['Insert']] |> expect.exist()
  })
  it('then operations contains Select operation',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    # When
    operations <- storage |> Todo.Broker()

    # Then
    operations[['Select']] |> expect.exist()
  })
  it('then operations contains SelectById operation',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    # When
    operations <- storage |> Todo.Broker()

    # Then
    operations[['SelectById']] |> expect.exist()
  })
  it('then operations contains Update operation',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    # When
    operations <- storage |> Todo.Broker()

    # Then
    operations[['Update']] |> expect.exist()
  })
  it('then operations contains Delete operation',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    # When
    operations <- storage |> Todo.Broker()

    # Then
    operations[['Delete']] |> expect.exist()
  })
})

describe("When todo |> operation[['Insert']]()",{
  it('then todo is inserted into storage',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    operation <- storage |> Todo.Broker()

    random.todo <- 'Task' |> Todo.Model()

    new.todo      <- random.todo
    expected.todo <- new.todo

    # When
    new.todo |> operation[['Insert']]()

    # Then
    retrieved.todo <- new.todo[['Id']] |> storage[['Todo']][['SelectWhereId']]() 
    
    retrieved.todo |> expect.equal(expected.todo)
  })
})
describe("When operation[['Select']]()",{
  it('then all todos are retrieved from storage',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    operation <- storage |> Todo.Broker()

    expected.todos <- storage[['Todo']][['Select']]()

    # When
    retrieved.todos <- operation[['Select']]()

    # Then
    retrieved.todos |> expect.equal(expected.todos)
  })
})
describe("When id |> operation[['SelectById']]()",{
  it('then todo with matching id is retrieved from storage',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    operation <- storage |> Todo.Broker()

    existing.todo <- storage[['Todo']][['Select']]() |> tail(1)

    input.todo    <- existing.todo
    expected.todo <- existing.todo

    # When
    retrieved.todo <- input.todo[['Id']] |> operation[['SelectById']]()

    # Then
    retrieved.todo[['Id']]     |> expect.equal(expected.todo[["Id"]])
    retrieved.todo[['Task']]   |> expect.equal(expected.todo[["Task"]])
    retrieved.todo[['Status']] |> expect.equal(expected.todo[["Status"]])
  })
})
describe("When todo |> operation[['Update']]()",{
  it('then todo is updated in storage',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    operation <- storage |> Todo.Broker()

    existing.todo <- storage[['Todo']][['Select']]() |> tail(1)

    updated.todo <- existing.todo
    updated.todo[['Status']] <- 'Done'

    expected.todo <- updated.todo

    # When
    updated.todo |> operation[['Update']]()

    # Then
    retrieved.todo <- updated.todo[['Id']] |> storage[['Todo']][['SelectWhereId']]()

    updated.todo[['Id']]     |> expect_equal(retrieved.todo[['Id']])
    updated.todo[['Task']]   |> expect_equal(retrieved.todo[['Task']])
    updated.todo[['Status']] |> expect_equal(retrieved.todo[['Status']])
  })
})
describe("When id |> operation[['Delete']]()",{
  it("then todo with matching id is deleted from storage",{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    operation <- storage |> Todo.Broker()

    existing.todo <- storage[['Todo']][['Select']]() |> tail(1)

    # When
    existing.todo[['Id']] |> operation[['Delete']]()

    # Then
    retrieved.todo <- existing.todo[['Id']] |> storage[['Todo']][['SelectWhereId']]() 
    
    retrieved.todo |> expect.empty()
  })
})
