# Interactive Applications in R

This repository contains a sample `Shiny` application which can be used as a boilerplate when developing enterprise-level applications using the R programming languages.

The unique feature of the ToDo App includes a:

1. Custom Styling
2. Custom Shiny Module
3. Custom Event Handler
4. Custom Data Layer
5. Units Test with 100% Data Layer Coverage
6. Github Workflow with Automated Unit Testing

## Getting Started

### Installation

Whether your development environment is based on RStudio or VS Code the installation follows the same steps:

1. R `devtools` is required. Install and Reboot:

```r
install.packages("devtools")
```

If you have difficulty, please consult this [page](https://www.r-project.org/nosvn/pandoc/devtools.html) for manual installation instructions.

2. Install the application dependencies:

```r
install.packages("shiny")
install.packages("shinydashboard")
install.packages("dplyr")
install.packages("DT")
install.packages("shinytest2")
install.packages("uuid")
```

3. Install a Mock Storage Service from GitHub:

```r
devtools::install_github("https://github.com/FlippieCoetser/Storage")
```

4. Clone this repository:

```bash
git clone https://github.com/FlippieCoetser/Shiny.ToDo.git
```

### Run Application

Follow these steps to run the application:

1. Open your development environment and ensure your working directory is correct.
   Since the repository is called `Shiny.ToDo`, you should have such a directory in the location where your cloned the repository.
   In RStudio or VS Code R terminal, you can use `getwd()` and `setwd()` to get or set the current working directory.
   Example:

```r
getwd()
# Prints: "C:/Data/Shiny.Todo"
```

3. Load `Shiny` Package

```r
library(shiny)
```

4. Run the application:

```r
runApp()
```

5. Application should open with this screen:

![Enterprise Application Hierarchy](/man/figures/App.Final.PNG)

## Shiny Software Architecture

### Functional Decomposition

In textbooks focusing on software architecture, it is typical to see a software application segmented into three layers: `User Interface`, `Business Logic`, and `Data`.

![Architecture](/man/figures//ToDo.Module.png)

Although this is not the only way to design software architecture, it aligns well with this ToDo sample application.

Before we dive into the details of each layer, it is important to understand just like `vue.js` and `react` in Javascript or `Blazor` in C#, R has the `Shiny` application framework. Shiny is an open-source framework made available as an R package that allows users to build interactive web applications directly from R. Shiny is intended to simplify the process of producing web-friendly, interactive data visualizations and makes it easier for R users who might not necessarily have the expertise in web development languages like HTML, CSS, and Javascript.

So, we will focus on the Shiny framework when discussing the different layers. I will refer to the code in this `ToDo` to keep the discussion relevant.

- The `User Interface (UI)` layer is responsible for the look and feel of the application using `layout`, `input` and `output` widgets. When using Shiny the UI layer is defined, by convention, in a file called `ui.R`.

Here is an example of the contents of a `ui.R` file:

```r
header  <- dashboardHeader(
  disable = TRUE
)
sidebar <- dashboardSidebar(
  disable = TRUE
)
body    <- dashboardBody(
  Todo.View("todo")
)

dashboardPage(
  header,
  sidebar,
  body
)
```

From a layout perspective, you can see we have a `dashboardPage` which contains `header`, `sidebar` and `body` widgets. For simplicity, the `header` and `sidebar` elements are disabled. The `body` element contains a custom shiny widget: `Todo.View`. Using custom shiny widgets allows us to build modular UI components, which increase reusability and scalability.

<details>
  <summary>Custom Shiny UI Widget</summary>

Here are the contents of the `Todo.View` file:

```r
Todo.View <- \(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      box(
        title = div(icon("house")," Tasks"),
        status = "primary",
        solidHeader = TRUE,
        DT::dataTableOutput(
          ns("todos")
        ),
        textInput(
          ns("newTask"),
          ""
        ),
        On.Enter.Event(
          widget = ns("newTask"),
          trigger = ns("create"))
      )
    ),
    conditionalPanel(
      condition = "output.isSelectedTodoVisible",
      ns = ns,
      fluidRow(
        box(title = "Selected ToDo",
            status = "primary",
            solidHeader = TRUE,
            textInput(ns("task"), "Task"),
            textInput(ns("status"), "Status"),
            column(6,
                  align = "right",
                  offset = 5,
                  actionButton(ns("update"), "Update"),
                  actionButton(ns("delete"), "Delete")
            )
        )
      )
    )
  )
}
```

Notice the many different types of UI widgets used:

- Layout: `fluidRow`, `conditionalPanel`, `box`, `column`
- Input: `textInput`
- Output: `dataTableOutput`
- Actions: `actionButton`
- Events: `On.Enter.Event` (example of a custom event)

There are many more widgets available in the Shiny framework. You can find a complete list [here](https://shiny.rstudio.com/gallery/widget-gallery.html).

</details>

- The `Business Logic (BL)` layer is responsible for the logic used to react to events from input widgets and updating of contents in output widgets. Shiny has many different reactive functions which are defined, again by convention, in a file called `server.R`.

Here is an example of the contents of a `server.R` file:

```r
# Mock Storage
configuration <- data.frame()
storage       <- configuration |> Storage::Mock.Storage.Service()

# Data Access Layer
data  <- storage |> Todo.Orchestration()

shinyServer(\(input, output, session) {
  Todo.Controller("todo", data)
})
```

When using a custom shiny widget, like `Todo.View`, an accompanied business logic component is required: `Todo.Controller`.

<details>
  <summary>Custom Shiny Controller</summary>

Here are the contents of the `Todo.Controller` file:

```r
Todo.Controller <- \(id, data) {
  moduleServer(
    id,
    \(input, output, session) {
      # Local State
      state <- reactiveValues()
      state[["todos"]] <- data[['Retrieve']]()
      state[["todo"]]  <- NULL

      # Input Binding
      observeEvent(input[['create']], { controller[['create']]() })
      observeEvent(input[["todos_rows_selected"]], { controller[["select"]]() }, ignoreNULL = FALSE )
      observeEvent(input[["update"]], { controller[["update"]]() })
      observeEvent(input[["delete"]], { controller[["delete"]]() })

      # Input Verification
      verify <- list()
      verify[["taskEmpty"]]    <- reactive(input[["newTask"]] == '')
      verify[["todoSelected"]] <- reactive(!is.null(input[["todos_rows_selected"]]))

      # User Actions
      controller <- list()
      controller[['create']] <- \() {
        if (!verify[["taskEmpty"]]()) {
          state[["todos"]] <- input[["newTask"]] |> Todo.Model() |> data[['UpsertRetrieve']]()
          # Clear the input
          session |> updateTextInput("task", value = '')
        }
      }
      controller[['select']] <- \() {
        if (verify[["todoSelected"]]()) {
          state[["todo"]] <- state[["todos"]][input[["todos_rows_selected"]],]

          session |> updateTextInput("task", value = state[["todo"]][["Task"]])
          session |> updateTextInput("status", value = state[["todo"]][["Status"]])

        } else {
          state[["todo"]] <- NULL
        }
      }
      controller[['update']] <- \() {
        state[['todo']][["Task"]]   <- input[["task"]]
        state[['todo']][["Status"]] <- input[["status"]]

        state[["todos"]] <- state[['todo']] |> data[["UpsertRetrieve"]]()
      }
      controller[['delete']] <- \() {
        state[["todos"]] <- state[["todo"]][["Id"]] |> data[['DeleteRetrieve']]()
      }

      # Output Bindings
      output[["todos"]] <- DT::renderDataTable({
        DT::datatable(
          state[["todos"]],
          selection = 'single',
          rownames = FALSE,
          colnames = c("", ""),
          options = list(
            dom = "t",
            ordering = FALSE,
            columnDefs = list(
              list(visible = FALSE, targets = 0),
              list(width = '50px', targets = 1),
              list(className = 'dt-center', targets = 1),
              list(className = 'dt-left', targets = 2)
            )
          )
        )
      })
      output[["isSelectedTodoVisible"]] <- reactive({ is.data.frame(state[["todo"]]) })
      outputOptions(output, "isSelectedTodoVisible", suspendWhenHidden = FALSE)
    }
  )
}
```

The `Todo.Controller` is a `reactive` function which takes two arguments: `id` and `data`. The `id` is used to identify the custom shiny widget, and the `data` is used to inject the data access layer into the business logic. We will look at the data access layer in the next section. Key elements in the `Todo.Controller` are:

1. Input Events: `observeEvent`
2. Input Validation: `reactive`
3. User Actions: `controller`
4. Output Bindings: `output`

Many more Reactive programming functions are available as part of the Shiny framework. You can find a complete list under the Reactive Programming section [here](https://shiny.posit.co/r/reference/shiny/latest/).

</details>

- The `Data (Data)` layer is responsible for `creating`, `retrieving`, `updating` and `deleting` data in long-term storage. Most applications build with Shiny are for interactive reports and dashboards. Meaning data is only ingested from storage. However, when developing enterprise-level applications being able to create, retrieve, update or delete data in storage is a very common practice. Unfortunately, unlike `Entity Framework` in C#, R has no framework to build `Data Layers`. Typically a data access Layer includes features which translate R code to, for example, SQL statements. Input, Output and Structural Validation and Exception handling are also included. Injecting the data access layer into a Shiny application is trivial.

Here is an example of how a data access layer is injected into the sample application:

```r
# Mock Storage
configuration <- data.frame()
storage       <- configuration |> Storage::Mock.Storage.Service()

# Data Access Layer
data  <- storage |> Todo.Orchestration()

shinyServer(\(input, output, session) {
  Todo.Controller("todo", data)
})
```

<details>
  <summary>Custom Data Layer</summary>

The typical components in a Data Layer include:

1. Broker
2. Service
3. Processing
4. Orchestration
5. Validator
6. Exceptions

You can read all about the details of each of these components [here](https://github.com/hassanhabib/The-Standard). Here is an high-level overview of each component:

The Todo application uses a Mock Storage Service. The Mock Storage Service is a simple in-memory data structure which implements the Broker interface. The Broker interface is used to perform primitive operations against the data in storage, while the service is used to perform input and output validation. The Validator Service is used to perform structural and logic validation. The Exception Service is used to handle exceptions. The Processing Service is used to perform higher-order operations, and lastly, the Orchestration Service is used to perform a sequence of operations as required by the application.

Also, if you look closely at the `Todo.Controller` code previously presented, you will notice the use of the data layer:

1. Create Todo: `state[["todos"]] <- input[["newTask"]] |> Todo.Model() |> data[['UpsertRetrieve']]()`
2. Retrieve Todo: `state[["todos"]] <- data[['Retrieve']]()`
3. Update Todo: `state[["todos"]] <- state[['todo']] |> data[["UpsertRetrieve"]]()`
4. Delete Todo: `state[["todos"]] <- state[["todo"]][["Id"]] |> data[['DeleteRetrieve']]()`

</details>

Application architecture is a complex topic. This section aimed to provide a high-level overview of enterprise-level software development with a focus on R and its ecosystem. The information presented is simplified and generalized as much as possible. The best way to learn Shiny is by experimenting: clone the sample application and start playing with the code.
