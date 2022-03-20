library(shiny)
library(magrittr)

text <- readr::read_file("../example-text")

ui <- fluidPage(
  h2("Regex Basic"),
  tags$head(
    tags$style(
      ".purple{
        background-color:#c994c7;
        border: 1px solid purple;
      }"
    )
  ),
  textInput("text", "text to find", width = "100%"),
  htmlOutput("text_marked")
)

server <- function(input, output){
  possibly_match <- purrr::possibly(
    stringr::str_match,
    FALSE
  )
  
  output$text_marked <- renderText({
    if (!isTruthy(input$text)) {
      replaced <- text
    } else {
      expr <-
        stringr::regex(stringr::str_c("(", input$text, ")"), multiline = TRUE)
      
      req(possibly_match(text, expr), cancelOutput = TRUE)
    
      replaced <- text %>% 
        stringr::str_replace_all(
          expr,
          '<span class=purple>\\1</span>'
        )
    }
    
    replaced <- replaced %>% 
      stringr::str_replace_all("\n", "<br>")
      
    return(replaced)
  })
}

shinyApp(ui, server)

