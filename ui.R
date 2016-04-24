library(shiny)

shinyUI(fluidPage(
  titlePanel("Predict Next->Word"),
  mainPanel(
    tabsetPanel(
      tabPanel("App",
      textInput('id1', h3("Input:"), "What is your", width = '100%'),
      h3('Predictions:'),
      verbatimTextOutput("od1"),
      h5('Top ^ single word recommendation on left'),
      checkboxInput('cb1', h4("Profanity FilterON"), value = TRUE),
      h3(''),
      h3('Plots:'),
      plotOutput('newPlot3'),
      plotOutput('newPlot2')
     ),
     tabPanel("Instructions",
      h3('Input:'),
      h4("Use your device's character input method (talking, clicking, swiping or typing) and wait a few seconds for prediction output."),
      h3('Predictions:'),
      h4("The top 'single word' is the leftmost word offered."),
      h4("The predictions are filtered for profanity by default. Uncheck Profanity FilterON to remove filter."),
      h4("The results may contain a token as defined below:"),
      h5("      <u> = unknown"),
      h5("      <b> = beggining of sentence"),
      h5("      <e> = end of sentence"),
      h5("      <n> = number"),
      h3('Plots'),
      h4("Visualization of the top recommended words using ggplot2.")
     ),
     tabPanel("About",
     h3('Code Repository:'),
     h4(a("https://github.com/Rick2015/Capstone_Project", href="https://github.com/Rick2015/Capstone_Project")),
     h3('App Presentation:'),
     h4(a("http://rpubs.com/Rick2015/Capstone_Presentation", href="http://rpubs.com/Rick2015/Capstone_Presentation"))
     )
  )
)))