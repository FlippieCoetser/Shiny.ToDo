

test_that("Todo.Structure.Validation Exist",{
  Todo.Structure.Validation |>
    is.null() |>
      expect_equal(FALSE)
})

test_that("Todo.Structure.Validation() returns a list of validators",{
  # Given
  validators <- Todo.Structure.Validation()

  # Then
  validators |>
    is.list() |>
      expect_equal(TRUE)
})

test_that("Todo.Structure.Validation instance has TodoExist validator",{
  # Given
  validator <- Todo.Structure.Validation()

  # Then
  validator[['TodoExist']] |>
    is.null() |>
      expect_equal(FALSE)
})

test_that("todo |> validate[['TodoExist']]() should not throw error if todo exist",{
  # Given
  validate <- Todo.Structure.Validation()

  todo  <- data.frame()

  # Then
  todo |>
    validate[['TodoExist']]() |>
      expect_no_error()
})

test_that("todo |> validate[['TodoExist']]() should throw error if todo is null",{
  # Given
  validate <- Todo.Structure.Validation()

  todo  <- NULL
  error <- "successful validation requires a data frame with todo"

  # Then
  todo |>
    validate[['TodoExist']]() |>
      expect_error(error)
})

test_that("Todo.Structure.Validation instance has HasId validator",{
  # Given
  validator <- Todo.Structure.Validation()

  # Then
  validator[['HasId']] |>
    is.null() |>
      expect_equal(FALSE)
})

test_that("todo |> validate[['HasId']]() should not throw error if todo has Id exist",{
  # Given
  validate <- Todo.Structure.Validation()

  todo  <- data.frame(
    Id = 'Id'
  )

  # Then
  todo |>
    validate[['HasId']]() |>
      expect_no_error()
})

test_that("todo |> validate[['HasId']]() should throw error if todo has no Id",{
  # Given
  validate <- Todo.Structure.Validation()

  todo  <- data.frame()
  error <- "todo data frame has no Id"

  # Then
  todo |>
    validate[['HasId']]() |>
      expect_error(error)
})

test_that("Todo.Structure.Validation instance has TodoTask validator",{
  # Given
  validator <- Todo.Structure.Validation()

  # Then
  validator[['HasTask']] |>
    is.null() |>
      expect_equal(FALSE)
})

test_that("todo |> validate[['HasTask']]() should not throw error if todo has Task exist",{
  # Given
  validate <- Todo.Structure.Validation()

  todo  <- data.frame(
    Task = 'Task'
  )

  # Then
  todo |>
    validate[['HasTask']]() |>
      expect_no_error()
})

test_that("todo |> validate[['HasTask']]() should throw error if todo has no Task",{
  # Given
  validate <- Todo.Structure.Validation()

  todo  <- data.frame()
  error <- "todo data frame has no Task"

  # Then
  todo |>
    validate[['HasTask']]() |>
      expect_error(error)
})

test_that("Todo.Structure.Validation instance has HasStatus validator",{
  # Given
  validator <- Todo.Structure.Validation()

  # Then
  validator[['HasStatus']] |>
    is.null() |>
      expect_equal(FALSE)
})

test_that("todo |> validate[['HasStatus']]() should not throw error if todo has Status exist",{
  # Given
  validate <- Todo.Structure.Validation()

  todo  <- data.frame(
    Status = 'Status'
  )

  # Then
  todo |>
    validate[['HasStatus']]() |>
      expect_no_error()
})

test_that("todo |> validate[['HasStatus']]() should throw error if todo has no Status",{
  # Given
  validate <- Todo.Structure.Validation()

  todo  <- data.frame()
  error <- "todo data frame has no Status"

  # Then
  todo |>
    validate[['HasStatus']]() |>
      expect_error(error)
})

test_that("Todo.Structure.Validation instance has Todo validator",{
  # Given
  validator <- Todo.Structure.Validation()

  # Then
  validator[['Todo']] |>
    is.null() |>
      expect_equal(FALSE)
})

test_that("todo |> validate[['Todo']]() should not throw error if todo is valid",{
  # Given
  validate <- Todo.Structure.Validation()

  todo  <- data.frame(
    Id     = 'Id',
    Task   = 'Task',
    Status = 'Status'
  )

  # Then
  todo |>
    validate[['Todo']]() |>
      expect_no_error()
})

test_that("Todo |> validate[['Todo']]() should throw error if todo is null",{
  # Given
  validate <- Todo.Structure.Validation()

  todo  <- NULL
  error <- "successful validation requires a data frame with todo"

  # Then
  todo |>
    validate[['Todo']]() |>
      expect_error(error)
})

test_that("Todo |> validate[['Todo']]() should throw error if todo has no Id",{
  # Given
  validate <- Todo.Structure.Validation()

  todo  <- data.frame()
  error <- "todo data frame has no Id"

  # Then
  todo |>
    validate[['Todo']]() |>
      expect_error(error)
})

test_that("Todo |> validate[['Todo']]() should throw error if todo has no Task",{
  # Given
  validate <- Todo.Structure.Validation()

  todo  <- data.frame(
    Id = 'Id'
  )
  error <- "todo data frame has no Task"

  # Then
  todo |>
    validate[['Todo']]() |>
      expect_error(error)
})

test_that("todo |> validate[['Todo']]() should throw error if todo has no Status",{
  # Given
  validate <- Todo.Structure.Validation()

  todo  <- data.frame(
    Id     = 'Id',
    Task   = 'Task'
  )
  error <- "todo data frame has no Status"

  # Then
  todo |>
    validate[['Todo']]() |>
      expect_error(error)
})

test_that("Todo.Structure.Validation instance has IdExist validator",{
  # Given
  validator <- Todo.Structure.Validation()

  # Then
  validator[['IdExist']] |>
    is.null() |>
      expect_equal(FALSE)
})

test_that("id |> validate[['IdExist']]() should not throw error if id exist",{
  # Given
  validate <- Todo.Structure.Validation()

  id  <- uuid::UUIDgenerate()

  # Then
  id |>
    validate[['IdExist']]() |>
      expect_no_error()
})

test_that("id |> validate[['IdExist']]() should throw error if id is null",{
  # Given
  validate <- Todo.Structure.Validation()

  id  <- NULL
  error <- "successful validation requires an Id"

  # Then
  id |>
    validate[['IdExist']]() |>
      expect_error(error)
})
