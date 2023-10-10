describe("Given Todo.Service",{
  it('exist',{
    # Given
    Todo.Service |> expect.exist()
  })
})

describe('When services <- Todo.Service()',{
  it('then services is a list',{
    # Given
    services <- Todo.Service()

    # Then
    services |> expect.list()
  })
  it('then services contains Add operation',{
    # Given
    services <- Todo.Service()

    # Then
    services[['Add']] |> expect.exist()
  })
  it('then services contains Retrieve operation',{
    # Given
    services <- Todo.Service()

    # Then
    services[['Retrieve']] |> expect.exist()
  })
  it('then services contains RetrieveById operation',{
    # Given
    services <- Todo.Service()

    # Then
    services[['RetrieveById']] |> expect.exist()
  })
  it('then services contains Modify operation',{
    # Given
    services <- Todo.Service()

    # Then
    services[['Modify']] |> expect.exist()
  })
  it('then services contains Remove operation',{
    # Given
    services <- Todo.Service()

    # Then
    services[['Remove']] |> expect.exist()
  })
})

describe("When todo |> service[['Add']]()",{
  it('then todo is added to storage',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()

    random.todo <- 'Task' |> Todo.Model()

    new.todo      <- random.todo
    expected.todo <- new.todo

    # When
    new.todo |> service[["Add"]]()

    # Then
    retrieved.todo <- new.todo[['id']] |> storage[['RetrieveWhereId']](table, fields)

    retrieved.todo |> expect.equal.data(expected.todo)
  })
  it('then an exception is thrown if todo has no id',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()

    invalid.todo <- data.frame(
      task = 'Task',
      status = 'New'
    )

    new.todo <- invalid.todo
    expected.error <- 'todo data frame has no id'

    # Then
    new.todo |> service[["Add"]]() |> expect.error(expected.error)
  })
  it('then an exception is thrown if todo has no task',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()
    invalid.todo <- data.frame(
      id = uuid::UUIDgenerate(),
      status = 'New'
    )

    new.todo <- invalid.todo
    expected.error <- 'todo data frame has no task'

    # Then
    new.todo |> service[["Add"]]() |> expect.error(expected.error)
  })
  it('then an exception is thrown if todo has no status',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()

    invalid.todo <- data.frame(
      id = uuid::UUIDgenerate(),
      task = 'Task'
    )

    new.todo <- invalid.todo
    expected.error <- 'todo data frame has no status'

    # Then
    new.todo |> service[["Add"]]() |> expect.error(expected.error)
  })
  it('then an exception is thrown if todo is null',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()

    invalid.todo <- NULL

    new.todo <- invalid.todo
    expected.error <- 'successful validation requires a data frame with todo'

    # Then
    new.todo |> service[["Add"]]() |> expect.error(expected.error)
  })
  it('then an exception is thrown if todo already exist',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()

    existing.todo <- table |> storage[['Retrieve']](fields) |> tail(1)

    new.todo <- existing.todo
    expected.error <- 'todo already exist, duplicate key not allowed'

    # Then
    new.todo |> service[["Add"]]() |> expect.error(expected.error)
  })
})
describe("When service[['Retrieve']]()",{
  it('then all todos are retrieved from storage',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()

    expected.todos <- table |> storage[['Retrieve']](fields)

    # When
    retrieved.todos <- service[['Retrieve']]()

    # Then
    retrieved.todos |> expect.equal(expected.todos)
  })
})
describe("When id |> service[['RetrieveById']]()",{
  it('then todo with matching id is retrieved from storage',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()

    existing.todo <- table |> storage[['Retrieve']](fields) |> tail(1)

    input.todo    <- existing.todo
    expected.todo <- existing.todo

    # When
    retrieved.todo <- input.todo[['id']] |> service[['RetrieveById']]()

    # Then
    retrieved.todo[['id']]     |> expect.equal(expected.todo[["id"]])
    retrieved.todo[['task']]   |> expect.equal(expected.todo[["task"]])
    retrieved.todo[['status']] |> expect.equal(expected.todo[["status"]])
  })
  it("then an exception is thrown if id is NULL",{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()

    id <- NULL

    expected.error <- 'successful validation requires an id'

    # Then
    id |> service[['RetrieveById']]() |> expect.error(expected.error)
  })
})
describe("When todo |> service[['Modify']]()",{
  it('then todo is updated in storage',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()

    existing.todo <- table |> storage[['Retrieve']](fields) |> head(1)

    updated.todo <- existing.todo
    updated.todo[['status']] <- 'Done'

    expected.todo <- updated.todo

    # When
    updated.todo |> service[['Modify']]()

    # Then
    retrieved.todo <- updated.todo[['id']] |> storage[['RetrieveWhereId']](table, fields)

    retrieved.todo[['id']]     |> expect_equal(expected.todo[['id']])
    retrieved.todo[['task']]   |> expect_equal(expected.todo[['task']])
    retrieved.todo[['status']] |> expect_equal(expected.todo[['status']])
  })
  it('then an exception is thrown if todo has no id',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()

    invalid.todo <- data.frame(
      task   = 'Task',
      status = 'New'
    )

    updated.todo <- invalid.todo
    expected.error <- 'todo data frame has no id'

    # Then
    updated.todo |> service[['Modify']]() |> expect.error(expected.error)
  })
  it('then an exception is thrown if todo has no task',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()
    invalid.todo <- data.frame(
      id     = uuid::UUIDgenerate(),
      status = 'New'
    )

    updated.todo <- invalid.todo
    expected.error <- 'todo data frame has no task'

    # Then
    updated.todo |> service[['Modify']]() |> expect.error(expected.error)
  })
  it('then an exception is thrown if todo has no status',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()

    invalid.todo <- data.frame(
      id   = uuid::UUIDgenerate(),
      task = 'Task'
    )

    updated.todo <- invalid.todo
    expected.error <- 'todo data frame has no status'

    # Then
    updated.todo |> service[['Modify']]() |> expect.error(expected.error)
  })
  it('then an exception is thrown if todo is null',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')
    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()
    invalid.todo <- NULL

    updated.todo <- invalid.todo
    expected.error <- 'successful validation requires a data frame with todo'

    # Then
    updated.todo |> service[['Modify']]() |> expect.error(expected.error)
  })
})
describe("When id |> service[['Remove']]()",{
  it('then todo is deleted from storage',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')

    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <-  storage |> Todo.Broker() |> Todo.Service()
    existing.todo <- table |> storage[['Retrieve']](fields) |> tail(1)

    # When
    existing.todo[['id']] |> service[['Remove']]()

    # Then
    existing.todo[['id']] |> storage[['RetrieveWhereId']](table, fields) |> expect.empty()
  })
  it('then an exception is thrown if id is null',{
    # When
    configuration <- data.frame()
    storage <- configuration |> Storage::Storage('memory')

    Todo.Mock.Data |> storage[['Seed.Table']]('Todo')

    service <- storage |> Todo.Broker() |> Todo.Service()

    id <- NULL

    expected.error <- 'successful validation requires an id'

    # Then
    id |> service[['Remove']]() |> expect.error(expected.error)
  })
})
