library(shiny)

shinyUI(fluidPage(
  titlePanel("Predict Next->Word"),
  mainPanel(
    tabsetPanel(
      tabPanel("App",
      textInput('id1', h3("Input:"), "What is your", width = '100%'),
      h3('Predictions:'),
      verbatimTextOutput("od1"),
      h6('Top ^ single word recommendation on left'),
      checkboxInput('cb1', h4("Profanity FilterON"), value = TRUE),
      h3(''),
      h3('Plots:'),
      plotOutput('newPlot3'),
      plotOutput('newPlot2')
     ),
     tabPanel("Instructions",
      h3('Input:'),
      h5("Use your device's character input method (talking, clicking, swiping or typing) and wait a few seconds for prediction output."),
      h3('Predictions:'),
      h5("The top 'single word' is the leftmost word offered."),
      h5("The predictions are filtered for profanity by default. Uncheck Profanity FilterON to remove filter."),
      h5("The results may contain a token as defined below:"),
      h6("      <u> = unknown"),
      h6("      <b> = beggining of sentence"),
      h6("      <e> = end of sentence"),
      h6("      <n> = number"),
      h3('Plots'),
      h5("Visualization of the top recommended words.")
     ),
     tabPanel("About",
     h5('Code Repository:'),
     h6('https://github.com/Rick2015/')
     )
  )
)))