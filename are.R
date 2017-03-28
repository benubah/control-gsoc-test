# Medium Test number 2
# X = are(A,B,C)
# A , B, and C are all matrices
# Syntax: X = are(A,B,C)
# Algebraic Riccati Equation solution.
# X = are(A, B, C) returns the stablizing solution (if it
# exists) to the continuous-time Riccati equation:
#        A'*X + X*A - X*B*X + C = 0
# assuming B is symmetric and nonnegative definite and C is
# symmetric.
library(Matrix) 
are = function(A,B,C) {
  
      eps = .Machine$double.eps
  
      # check for correct input problem
      nr = nrow(A)
      nc = ncol(A) 
      n  = nr;
        
      if (nr != nc) {
              stop("Nonsquare A matrix")
      }
      
      nr = nrow(B)
      nc = ncol(B)
  
      if (nr!=n || nc!=n) {
              stop("Incorrectly dimensioned B matrix") 
       }
  
      nr = nrow(C)
      nc = ncol(C)
  
      if (nr!=n || nc!=n) {
             stop("Incorrectly dimensioned C matrix") 
      }
  
      var1= rbind(cbind(A,-B), cbind(-C, t(-A)))
  
  
      val= var1*(1.0+(eps*eps)*sqrt(as.complex(-1)))
 
      tmp = Schur(val)    
  
      q = as.matrix(tmp$Q)
      t = as.matrix(tmp$T) 
      tol = 10.0*eps*max(abs(diag(t)))	# ad hoc tolerance

      ns = 0

  #  Prepare an array called index to send message to ordering routine 
#  giving location of eigenvalues with respect to the imaginary axis.
#  -1  denotes open left-half-plane
#   1  denotes open right-half-plane
#   0  denotes within tol of imaginary axis
#  
      index = c()

    for (i in 1:(2*n)){
      
        if (Re(t[i,i]) < -tol) {
          
                index = cbind(index, -1)
                ns = ns + 1
                
        } else if (Re(t[i,i]) > tol) {
     
                index = cbind(index, 1)
        } else {
                index = cbind(index, 0)
        }
  }

      if (ns != n) {
              stop("No solution: (A,B) may be uncontrollable or no solution exists"); 
      }

  
      res = schord(q,t,index);
      qo= res$Qo
      to= res$To

      X = Re(qo[(n+1):(n+n),1:n]) %*% solve(Re(qo[1:n,1:n]));

      return(X)
 }


#-REQUIRED BY are.R
  # schord
#
  # Syntax: </Qo; To/> = schord(Qi, Ti, index)
  #
    #	Ordered schur decomposition.
  #	result = schord(Qi, Ti, index)  Given the square (possibly 
                                                           #	complex) upper-triangular matrix Ti and orthogonal matrix Qi
  #	(as output, for example, from the function SCHUR),
  #	SCHORD finds an orthogonal matrix Q so that the eigenvalues
  #	appearing on the diagonal of Ti are ordered according to the
  #	increasing values of the array index where the i-th element
  #	of index corresponds to the eigenvalue appearing as the
  #	element  Ti(i,i).
  #
    #	The input argument list may be [Qi, Ti, index] or [Ti, index].
  #	The output list may be [Qo, To] or [To].
  #
    #	The orthogonal matrix Q is accumulated in Qo as  Qo = Qi*Q.
    #     	If Qi is not given it is set to the identity matrix.
    #
      #          *** WARNING: SCHORD will not reorder REAL Schur forms.
    schord = function(Qi, Ti, index)
    {
      n = nrow(Ti);
      if (nrow(Ti) != ncol(Ti)){ stop("Nonsquare Ti"); }
      if (nargs() == 2)
      {
        index = Ti; 
        To = Qi;
        }else{
          To = Ti;
      }
      
      if (nargs() > 2) {
        Qo = Qi; 
        }else {
          Qo = diag(1,n,n);
      }
      #
        for (i in 1:(n-1)){
          # -- find following element with smaller value of index --
            move = 0; 
            k = i;
            for (j in (i+1):n) {
              if (index[j] < index[k]) {
                k = j; 
                move = 1; 
              }
            }
            
            # -- propagate eigenvalue up the diagonal from k-th to i-th entry --
              if (move)
              {
                for (l in seq(k,(i+1),-1))
                {
                  l1 = l-1; 
                  l2 = l;
                  t = givens(To[l1,l1]-To[l2,l2], To[l1,l2]);
                  t = rbind(t[2,],t[1,]);
                  To[,l1:l2] = To[,l1:l2]*t; 
                  To[l1:l2,] = t(t)*To[l1:l2,];
                  Qo[,l1:l2] = Qo[,l1:l2]*t;
                  ix = index[l1]; 
                  index[l1] = index[l2]; 
                  index[l2] = ix;
                }
              }
        }
                  return(list(Qo=Qo, To=To));
    }

#-REQUIRED BY schord.R-----------------------------------------------------
  # givens
  # syntax: g = givens(x,y)
  #      Givens rotation matrix.
  #	G = givens(x,y) returns the complex Givens rotation matrix
  #
    #	    | c       s |                  | x |     | r | 
    #	G = |           |   such that  G * |   |  =  |   |
      #          |-conj(s) c |                  | y |     | 0 |
      #	                                
      #	where c is real, s is complex, and c^2 + |s|^2 = 1. 
 #----------------------------------------------------------------------
        givens = function(x,y)
        {
          absx = abs(x);
          if (absx == 0.0)
          {
            c = 0.0; s = 1.0;
           } else{
              nrm = norm(cbind(x,y),"2");
            c = absx/nrm;
            s = x/absx*(Conj(y)/nrm);
           }
          val = rbind(cbind(c,s), cbind(-Conj(s),c));
          return(val);
        }
        
                  
# The are(A,B,C) program could be tested using the following R code below:
a = matrix(c(-3, 2,1, 1), byrow = TRUE, ncol = 2)
b = matrix(c(0, 1, 1,0), nrow = 2) # must be dimensioned as matrix a
c = matrix(c(1, -1), ncol=2)

d=t(c)%*%c

result = are(a,b,d);
# The result is:
# > result
#          [,1]     [,2]
#[1,] 0.4299933 1.385913
#[2,] 1.3859133 8.478139

# The result is identical with that of Octave below

#Octave results:
# X =

#   0.42999   1.38591
#   1.38591   8.47814
#
# In R and RLabPlus, the input and output objects are the same.
# However, MATLAB had this same input and output objects as R and RLabPlus, 
# but in recent times, MATLAB remodified the function to be [X,L,G] = care(A,B,Q) with more
# outputs L and G. Where G = gain matrix and L = vector of closed-loop eigenvalues
