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
})