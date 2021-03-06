# Automatic Generation Control of Electric Power Systems

## Formulation

Electric power system generators are interconnected into a grid and automatic voltage regulators (AVR) and load frequency control (LFC)
equipment are installed for each generator. These controllers are set to take care of small changes in consumer load
demand to maintain the frequency and voltage magnitude within specified limits so as to avoid electric power collapse.
The purpose of this example is to obtain the frequency response due to change in consumer load of an isolated electric power system.

The diagram of Fig.1 is the schematic representation of the automatic voltage regulator and frequency control of a 
generator.
![alt text](https://github.com/benubah/control-gsoc-test/blob/master/Fig1_powersystem%20_schematicdiagram.png "Figure 1")

### Figure 1


The primary step in the design and analysis of such a control system is its mathematical model with two most common
approaches - the transfer function and state space approach.
The state space approach is more robust and could be applied to analyze linear and nonlinear systems.


A part of Fig.1 consisting of the Speed Governor, Steam Turbine and Load is modeled using control theory in Fig. 2
The values for the unknowns could be obtained from a power system data sheet.

![alt text](https://github.com/benubah/control-gsoc-test/blob/master/Fig2blockmodel.png "Figure 2")

### Figure 2 


Using control theory to analyze the closed loop transfer function of Fig.2 results in:

Applying the following values:

Governor Time constant, Tg = 0.2 sec

Turbine Time constant, Tt = 0.5 sec

Governor inertia constant, H = 5 sec

Governor speed regulation, R = 0.05 per unit


![alt text](https://github.com/benubah/control-gsoc-test/blob/master/tf.png "Transfer equation")

## Problem:

To obtain the frequency and power deviation response due to a step change (0.2 per unit) in consumer load connected to this
generating utility.
The above problem can now be analyzed using a control toolbox within a scientific computational tool. 

## Solution

However, since R does not have a control toolbox, therefore, the solution here was to interface R with Octave's control
toolbox on Ubuntu Linux using the RcppOctave R package. This is not a best solution as the RcppOctave package 
is still under development to be installable on a variety of operating systems (e.g. MS Windows).

The core part of the problem can be easily solved using a control-toolkit in the following way after obtaining the transfer function:
 
First, I created a time range for which I want to observe the deviation and restoration of frequency. For this problem, it was from 0 to 12 seconds with a time step of 0.02. See following code.
 
           t = 0:0.02:12;
           
Second, I obtained a transfer function model from the transfer function equation above, collecting the coefficients of the numerator and denominator into the variables, 'num' and 'den' respectively:
 
          num = [0.1 0.7 1];
          
          den = [1 7.08 10.56 20.8]
  
          sys = tf(num,den); % setup a transfer function model
          
Third, I added a negative step consumer load to the step responce of the transfer function model. This obtained the frequency response of the system taken into account the step change in load. The value of PL was set to 0.2.

          c = -PL*step(sys,t);

Finally, the frequency response was plotted using the following code:
      
      f = c*60 # given an electrical network operating frequency of 60 hz
      plot(t,f, type="l", col="dark red", lwd=2,main="Frequency Deviation response of a Single Area Power system",               
      xlab="Time,secs",    ylab="Frequency, Hertz")
      grid(5, 5, lwd = 2)
      
I used the following code to obtain the plot of the power deviation from the results obtained above:
              
              R <- input$Sr         # speed regulation of the generator
              p <- -c/R             # power response
              plot(t,p, type="l", col="red", lwd=2,main="Power Deviation response of the system", xlab="Time,secs", ylab="Power, p.u")
              grid(5, 5, lwd = 2)

For a more visual and interactive analysis, and ease of use, the Shiny package was used to provide the solution as a web application

A screenshot is shown below in Fig. 3
![alt text](https://github.com/benubah/control-gsoc-test/blob/master/Fig3.png "Figure 3")
### Figure 3

## Results

Due to the step change (of 0.2 per unit) in consumer load, the frequency of the power system experienced a deviation of about 1 Hz and finally stabilized at around 0.1 Hz (considering a power system operating at a nominal frequency of 60Hz it would be deviation to about 59Hz and back to a stable operating frequency of 59.9Hz)

[See one similar way Mitsubishi Electric uses control theory here](http://www.meppi.com/Products/GeneratorExcitationProducts/Static%20Excitation%20System/Power%20System%20Stabilizer.pdf)

## Code

The code for this application can be found [here](https://github.com/benubah/control-gsoc-test/tree/LFC-web-app/LFC-web-app)

## References

[1] Hadi Saadat, Power System Analysis, Tata McGraw Hill, New Delhi, 1999
