describe('Given Todo.Logic.Validation.Service',{
  it('exist',{
    # Given
    Todo.Logic.Validation.Service |> expect.exist()
  })
})

describe('When validators <- Todo.Logic.Validation.Service()',{
  it('then operations is a list',{
    # Given
    validators <- Todo.Logic.Validation.Service()

    # Then
    validators |> expect.list()
  })
  it('then operations has IsDuplicate',{
    # Given
    validators <- Todo.Logic.Validation.Service()

    # Then
    validators[["IsDuplicate"]] |> expect.exist()
  })
})