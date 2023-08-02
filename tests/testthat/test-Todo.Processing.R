describe('Given Todo.Processing',{
  it('exist',{
    # Given
    Todo.Processing |> expect.exist()
  })
})

describe('When processors <- storage |> Todo.Processing()',{
  it('then processors is a list',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    # When
    processors <- storage |> Todo.Broker() |> Todo.Service() |> Todo.Processing()

    # Then
    processors |> expect.list()
  })
  it('then processors contains Retrieve processor',{
    # Given
    configuration <- data.frame()

    storage <- configuration |> Storage::Mock.Storage.Service()

    # When
    processors <- storage |> Todo.Broker() |> Todo.Service() |> Todo.Processing()

    # Then
    processors[['Retrieve']] |> expect.exist()
  })
})