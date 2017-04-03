
### Transfer Functions and State-space representations of Control Systems

The transfer function is a mathematical representation of a linear time invariant dynamic system. It is the ratio of the output of a system
to the input of that system in the Laplace domain.

Consider the simple block model of the following system in Figure 1,

![block diagram](https://github.com/benubah/control-gsoc-test/blob/master/Figure5_blockdiagram.png "Turbine block diagram")

Figure 1: Block diagram for non-reheat turbine

The transfer function for this model where Tt = 0.2 in Octave command is given as:
              sys = tf([1], [0.2, 1]) # where tf(num,den) is the syntax, num is the numerator, den is the denominator.
Transfer function 'sys' from input to output 

     sys:     1 / (0.2 s + 1)

This is a simple Continuous-time model.

To convert from Transfer functions to State-space representation, the following code is used:

      [a,b,c,d] = tf2ss(sys)
      
To convert from State-space back to transfer functions, the following code is used:

      sys = ss(a,b,c,d)

      [num, den] = ss2tf(sys)


