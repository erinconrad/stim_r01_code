library(statmod)

# R01 aim 3 (prospective aim), corresponds to prospective_power_analysis
p1 <- 0.833
p2 <- 0.1
power.fisher.test(p1,p2,8,8,alpha=0.05,nsim=100,alternative="two.sided") # yields 0.8 power

# R01 aim 1, corresponds to power_analysis_ccep
delta <- -0.072
sd <- 0.069
power.t.test(n = NULL,delta,sd,sig.level = 0.05,power = 0.8,type ="paired",alternative = "two.sided")