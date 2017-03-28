# Automatic Generation Control of Electric Power Systems

## Formulation

Electric power system generators are interconnected into a grid and automatic voltage regulators (AVR) and load frequency control (LFC)
equipment are installed for each generator. These controllers are set to take care of small changes in consumer load
demand to maintain the frequency and voltage magnitude within specified limits so as to avoid electric power collapse.

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

However, R does not have a control toolbox, therefore, the solution here was to interface R with Octave's control
toolbox on Ubuntu Linux using the RcppOctave R package. This is not a best solution as the RcppOctave package 
is still under development to be installable on a variety of operating systems (e.g. MS Windows).

For a more visual and interactive analysis, and ease of use, the Shiny package was used to deploy the solution as a web application

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
