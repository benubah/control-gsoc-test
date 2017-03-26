
# This is the server logic for the LFC Shiny web application.
# 
#

library(shiny)
library(RcppOctave)

#load control package in Octave
o_source(text="pkg load control")
o_source(text="pkg load signal")
c <- c()
t <- c()
shinyServer(function(input, output) {

  output$agcPlot <- renderPlot({
    
    
    
    # assign the following variables from R into the Octave session
       o_assign(PL = input$dPL*-1)
    
         #unlist the num variable and make it numeric
         numIn <- as.numeric(unlist(strsplit(input$num,",")))
         o_assign(num = numIn)
    
         #unlist the den variable and make it numeric
         denIn <- as.numeric(unlist(strsplit(input$den,",")))
          o_assign(den = denIn)
    
    # preform the following commands in Octave
    o_source(text="
          
          t = 0:0.02:12;
          sys = tf(num,den); % setup a transfer function model
          c = -PL*step(sys,t);
          tR = t(:); %a range cannot be parsed to R, so make t a vector

    ")
    
        #retrieve the variables, t and c
         t <<- o_get("tR")
         c <<- o_get("c")
   
         f = c*60 # given an electrical network operating frequency of 60 hz
   
   par(mfrow=c(1,2))
   plot(t,f, type="l", col="dark red", lwd=2,main="Frequency Deviation response of a Single Area Power system", xlab="Time,secs", ylab="Frequency, Hertz")
   grid(5, 5, lwd = 2)
   
   R <- input$Sr
   p <- -c/R
   
   plot(t,p, type="l", col="red", lwd=2,main="Power Deviation response of the system", xlab="Time,secs", ylab="Power, p.u")
   grid(5, 5, lwd = 2)
  })
  
  output$TFtext <- renderPrint({
  input$num
    input$den
     o_source(text = " sys = tf(num,den)
                      disp('')
                      disp('Transfer Function to State-Space Conversion')
                      [a,b,c,d] = tf2ss(sys)
             
             ")
  })
  
  
  #function to generate bode plot for  the control system from Octave
  output$imageOut <- renderImage({
    bd <- input$bode
   
          #unlist the num variable and make it numeric
          numIn <- as.numeric(unlist(strsplit(input$num,",")))
          o_assign(num = numIn)
    
          #unlist the den variable and make it numeric
          denIn <- as.numeric(unlist(strsplit(input$den,",")))
           o_assign(den = denIn)
    
    if(bd){
    o_source(text = " sys = tf(num,den); bode(sys); print('figure_1.png','-dpng','-S850,420')")
               filename <- normalizePath(file.path('/home/rpowerlabs/PSAT_S/control-gsoc-test',
                                                       paste('figure_1', '.png', sep='')))
          list(src = filename)
      }
    
  })
  
})
