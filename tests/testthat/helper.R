expect.exist      <- \(component) component |> is.null() |> expect_equal(FALSE)
expect.list       <- \(members) members |> is.list() |> expect_equal(TRUE)