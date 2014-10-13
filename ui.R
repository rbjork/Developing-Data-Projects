# UI for ROC
shinyUI(pageWithSidebar(
  headerPanel("ROC plot"),
  sidebarPanel(
    sliderInput('gammaset', label='Set the Gamma',value = 1, min = 0, max = 10, step = .5)
  ),
  mainPanel(
    plotOutput('myROC'),
    plotOutput('myROC2')
  )
))