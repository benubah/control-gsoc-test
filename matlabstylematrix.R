# matlab style matrix creation function
#syntax is c(2,3,4) %;% c(2,2,2) %;% c(2,3,3)
#output is
#      [,1] [,2] [,3]
#[1,]    2    3    4
#[2,]    2    2    2
#[3,]    2    3    3
#basically is used for row binding vectors or matrices
#just a simple experiment without checks for appropriate dimensioning

`%;%` <- function(...) {
  dots <- list(...)
  res=rbind(dots[[1]],dots[[2]])
  return(res)
}

# this is used for column binding vectors or matrices
#syntax is 1 %,% 2 %,% 3
#the output is a 1 x 3 matrix
`%,%` <- function(...) {
  dots <- list(...)
  res=cbind(dots[[1]],dots[[2]])
  return(res)
}
