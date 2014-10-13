# Server

library(e1071)
library(ROCR)
library(shiny)

set.seed(1)
x=matrix(rnorm(200*2),ncol=2)
x[1:100,]=x[1:100,]+2
x[101:150,]=x[101:150,]-2
y=c(rep(1,150),rep(2,50))
dat=data.frame(x=x,y=as.factor(y))

train=sample(200,100)


rocplot <- function(pred,truth, ...){
  predob = prediction(pred,truth)
  perf = performance(predob,"tpr","fpr")
  plot(perf,...)
}


shinyServer(
  function(input, output) {
    gammaset <- reactive({input$gammaset})
    svmfit <- reactive({svm(y~., data=dat[train,],kernel="radial",gamma=gammaset(),cost=1,decision.values=T)})
    
    fitted <- reactive({attributes(predict(svmfit(), dat[train,], decision.values=TRUE))$decision.values})
    fittedTest <- reactive({attributes(predict(svmfit(),dat[-train,],decision.values=T))$decision.values})
    output$myROC <- renderPlot({
      rocplot(fitted(),dat[train,"y"],main="Train ROC")
      rocplot(fittedTest(),dat[-train,"y"],add=T,col="red")
    })
   
   output$myROC2 <- renderPlot({
     plot(svmfit(),dat[-train,],page=FALSE,new=TRUE)
   })
  }
)