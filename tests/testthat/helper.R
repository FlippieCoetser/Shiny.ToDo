expect.exist      <- \(component) component |> is.null() |> expect_equal(FALSE)
expect.equal      <- \(actual, expected) actual |> expect_equal(expected)
expect.list       <- \(members) members |> is.list() |> expect_equal(TRUE)
expect.empty      <- \(entities) entities |> nrow() |> expect_equal(0)