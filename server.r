library(shiny)
data(mtcars)
mtcars[,2]<-as.factor(mtcars[,2])
mtcars[,8]<-as.factor(mtcars[,8])
mtcars[,9]<-as.factor(mtcars[,9])
mtcars[,10]<-as.factor(mtcars[,10])
pre<-glm(mpg~.,data=mtcars)
ans<-function(cyl,disp,hp,drat,wt,qsec,vs,am,gear,carb){
  cyl<-as.factor(cyl)
  vs<-as.factor(vs)
  am<-as.factor(am)
  gear<-as.factor(gear)
  a=data.frame(cyl,disp,hp,drat,wt,qsec,vs,am,gear,carb)
  predict(pre,newdata=a)
}

am1<-function(am){
  if (am == "0") am <- "automatic" else am <- "manual"  
  am
}
vs1<-function(vs){
  if (vs == "0") vs <- "V" else vs <- "S"
  vs
}


shinyServer(
  function(input,output){
    output$cyl<-renderPrint({input$cyl})
    output$disp<-renderPrint({input$disp})
    output$hp<-renderPrint({input$hp})
    output$drat<-renderPrint({input$drat})
    output$wt<-renderPrint({input$wt})
    output$qsec<-renderPrint({input$qsec})
    output$vs<-renderPrint({vs1(input$vs)})
    output$am<-renderPrint({am1(input$am)})
    output$gear<-renderPrint({input$gear})
    output$carb<-renderPrint({input$carb})
    output$prediction <- renderPrint({as.numeric(ans(input$cyl,input$disp,input$hp,input$drat,input$wt,input$qsec,input$vs,input$am,input$gear,input$carb))})
    output$newplot <- renderPlot({
      boxplot(mtcars[1], ylab='mpg')
      mu <- as.numeric(ans(input$cyl,input$disp,input$hp,input$drat,input$wt,input$qsec,input$vs,input$am,input$gear,input$carb))
      lines(c(0, 2),c(mu, mu),col="red",lwd=5)
    },height=400,width=400)
  }
)