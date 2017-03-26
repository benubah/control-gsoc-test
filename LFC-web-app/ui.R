
# This is the user-interface definition of the LFC Shiny web application.
# 
#
# 
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  headerPanel("Load Frequency Control - Automatic Generation Control for an Isolated Electric Utility",
              tags$head(
                conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                                 tags$div(style="padding-left:50%; position:absolute; top:40%; bottom:50%; z-index=2000;",
                                          tags$img(src="loading-gif-animation2.gif",height="32px",width="32px")),
                                 tags$div(style="padding-top:30px;position:absolute; top:50%; bottom:50%; left:45%; z-index=2001; color:red;
                                          background-color:; font-family:arial; font-size:16px;",
                                          "Please wait...")
                ),
                tags$title("Load Frequency Control - Automatic Generation Control for an Isolated Electric Utility"),
                tags$style(type='text/css', 'body {background-color: #F0EBDB;}'),
                tags$style(type='text/css', '#bar1 {background-color: grey75; width:320px;}'),
                tags$style(type='text/css', '.tab1 {background-color:#F0EBDB; margin-left:-20px;}'),
                tags$style(type='text/css', 'h1 {border-bottom: 5px solid #560503; font-family:arial; font-size:22px; color:#9A0A05; background:#F7F3EA;}')
               
                )
              ),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(id="bar1",    
               
               sliderInput("dPL", 
                           "Step Change in Load (per unit), PL:", 
                           min = -1.0, 
                           max = 1.0, 
                           value = -0.2, step = 0.1),
               textInput("num","Transfer Function, Numerator", "0.1, 0.7, 1, 0"),
               textInput("den","Transfer Function, Denominator", "1, 7.08, 10.56, 20.8, 7"),
               numericInput("Sr","Speed Regulation, p.u", 0.05),
               checkboxInput("bode", "Bode Plot", value = FALSE),
               checkboxInput("rlocus", "Root Locus", value = FALSE),
               br(),
               helpText("This program simulates the frequency deviation response of an isolated power system
                        due to a step load change. By varying the PL, the frequency variation of the
                        system is re-plotted against time. 
                        Whenever the load connected to the power system changes, there is a frequency deviation
                        from the nominal; the power deviates too. The speed governors respond based on the speed
                        regulation value to restore the system to nominal frequency and ramp up generation to
                        meet up the new load requirement.
                        The program calls the STEP function from Octave control toolbox, through the 
                        RcppOctave package to perform this simulation as R does not have a control
                        toolbox.")
               
               ),
  
  
  
  # Show a plot of the generated distribution
  mainPanel(
    
    
        plotOutput(outputId="agcPlot", height="320px"),
          verbatimTextOutput(outputId="TFtext"),
              imageOutput(outputId="imageOut")
        
       
    
    
  )
  ))
