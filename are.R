#--------------------------------------------------------------------------
  #
  # are
#
  # Syntax: X = are(A,B,C)
  #
    # Algebraic Riccati Equation solution.
  # X = are(A, B, C) returns the stablizing solution (if it
                                                       # exists) to the continuous-time Riccati equation:
    #
    #        A'*X + X*A - X*B*X + C = 0
  #
  # assuming B is symmetric and nonnegative definite and C is
  # symmetric.
  #
  # see also: ric
  #--------------------------------------------------------------------------
 # require schord
  library(Matrix) #schur
  
  #Only bug - The Schur function from the matrix package returns incomplete results. Coerces imaginary parts of the matrix
  
  
  are = function(A,B,C)
  {
  
  eps = .Machine$double.eps;
  # check for correct input problem
  nr = nrow(A);
  nc = ncol(A); 
  n  = nr;
  if (nr != nc) {
  stop("Nonsquare A matrix"); 
  }
  nr = nrow(B);
  nc = ncol(B);
  if (nr!=n || nc!=n) {
  #stop("Incorrectly dimensioned B matrix"); 
  }
  nr = nrow(C);
  nc = ncol(C);
  if (nr!=n || nc!=n) {
   stop("Incorrectly dimensioned C matrix"); 
  }
  
  var1= rbind(cbind(A,-B), cbind(-C, t(-A)));
  #print(var1)
  val=var1*(1.0+eps*eps*sqrt(as.complex(-1)));
 # print(val)
  tmp = Schur(val);    # This function from the matrix package returns incomplete results. Coerces imaginary parts of the matrix
 # print(tmp)
q = as.matrix(tmp$Q);
t = as.matrix(tmp$T); 
tol = 10.0*eps*max(abs(diag(t)));	# ad hoc tolerance
#print(tol)
ns = 0;
#
  #  Prepare an array called index to send message to ordering routine 
#  giving location of eigenvalues with respect to the imaginary axis.
#  -1  denotes open left-half-plane
#   1  denotes open right-half-plane
#   0  denotes within tol of imaginary axis
#  
  index = c();
for (i in 1:(2*n))
{
  if (Re(t[i,i]) < -tol) {
    index = cbind(index, -1) ;
    ns = ns + 1;
    }else if (Re(t[i,i]) > tol) {
      index = cbind(index, 1) ;
      }else{
        index = cbind(index, 0) ;
      }
  }

if (ns != n) {
  stop("No solution: (A,B) may be uncontrollable or no solution exists"); 
}
  
  res = schord(q,t,index);
  qo= res$Qo
  to= res$To

X = Re(qo[(n+1):(n+n),1:n]/q[1:n,1:n]);

return(X)
  }


#----------------------------------------------------------------------
  #
  # schord
#
  # Syntax: </Qo; To/> = schord(Qi, Ti, index)
  #
    #	Ordered schur decomposition.
  #	</Qo; To/> = schord(Qi, Ti, index)  Given the square (possibly 
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
    #
      #----------------------------------------------------------------------
     # require givens
    
    
    
    #
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
                  
                  