library(shiny)
library(marker)
library(magrittr)

text <- readr::read_file("../example-text")

ui <- fluidPage(
  use_marker(),
  h2("Regex Basic"),
  tags$head(
    tags$style(
      ".purple{background-color:#c994c7;}"
    )
  ),
  textInput("text", "text to find"),
  pre(id = "text-to-mark", text),
  verbatimTextOutput("result")
)

server <- function(input, output){
  
  marker <- marker$new("#text-to-mark")
  
  observeEvent(input$text, {
    marker$
      unmark(className = "purple")$ # unmark
      mark_regex(input$text, className = "purple") # mark
  })
  
  output$result <- renderText({
    stringr::str_extract_all(text, input$text, simplify = TRUE)
  })
}

shinyApp(ui, server)

