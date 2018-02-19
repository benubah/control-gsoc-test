require("control")
require("CVXR")

A = rbind(c(0, 1), c(0, 0))
B = rbind(c(0, 0), c(1, -1))
C = rbind(c(1, 0), c(0, 1))
D = rbind(c(0, 0), c(1, -1))
Ts = 0.1
N = 20

sys_c = control::ss(A, B, C, D)
sys_d = control::c2d(sys_c, Ts)

n = nrow(A)  # number of states
m = ncol(B)  # number of inputs

# optimization variables
x = Variable(n, N+1)
u = Variable(m, N)

states = c()
x0 = c(1, 0)
xf = c(0, 0)
u_max = 1

for(t in 1:N){
  cost = sum_entries(u[, t])
constr = list(
  x[, t+1] == sys_d$A %*% x[, t] + sys_d$B %*% u[, t],
  u[, t] >= 0,
  u[, t] <= u_max
)
states = c(states, Problem(Minimize(cost), constr) )
}
prob <- Reduce("+", states)
#prob = sum(states)

constraints(prob) <- c(constraints(prob), x[, 1] == x0)
constraints(prob) <- c(constraints(prob), x[, N + 1] == xf)
sol <- solve(prob)
plot(sol$getValue(x[1,]), type = "l")
plot(sol$getValue(u[1,]), type = "l")
