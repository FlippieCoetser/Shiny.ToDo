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
  it('then orchestrations contain Add orchestration',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    # When
    orchestrations <- storage |> Todo.Orchestration()

    # Then
    orchestrations[['Add']] |> expect.exist()
  })
})

describe('When todo |> orchestrate[["Add"]]()',{
  it('then a data.frame with todos containing todo is returned',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    orchestrate <- storage |> Todo.Orchestration()

    random.todo <- 'Task' |> Todo.Model()

    new.todo      <- random.todo
    expected.todo <- new.todo 

    # When
    retrieved.todos <- new.todo |> orchestrate[["Add"]]()

    # Then
    retrieved.todos |> expect.contain(expected.todo)
  })
})