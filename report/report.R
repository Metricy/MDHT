set.seed(1)
source("KM_func.R");source("ES_func.R");source("KS_func.R")
library(MASS)

setting <- 2
test_times <- 1000
k <- 5

p_values_ES <- rep(0, test_times)
p_values_KS <- rep(0, test_times)
p_values_KS_re <- rep(0, test_times)
p_values_KM <- rep(0, test_times)

if (setting == 1){
  mu.1 <- seq(0,by=0.2, length.out=5)
  mu.2 <- mu.1+0.1
} else{
  mu.1 <- seq(0,by=0.2, length.out=5)
  mu.2 <- c(1, -0.5, 0, 0.5, -1)
}

H <- matrix(rnorm(5^2), nrow=5); H <- H %*% t(H);
sigma <- H/median(diag(H))
#sigma <- diag(c(2,2,2,2,2))
#sigma <- matrix(c(1.5,1,1,1,1,
#                  1,1.5,1,1,1,
#                  1,1,1.5,1,1,
#                  1,1,1,1.5,1,
#                  1,1,1,1,1.5), byrow=T, ncol=5)
n.1 <- 50
n.2 <- 100

for (j in 1:test_times){
  A <- mvrnorm(n.1, mu.1,sigma) 
  B <- mvrnorm(n.2, mu.2,sigma) 

  p_values_ES[j] <- ES_pvalue(A, B, 100)
  p_values_KS[j] <- KS_pvalue(A, B, 0.7)
  p_values_KS_re[j] <- KS_pvalue_re.2(A, B)
  p_values_KM[j] <- PKS_pvalue(k_means(A, B, k))
  print(j)
}

print(mean(p_values_ES <= 0.05))
# [1] 0.051

print(mean(p_values_KS <= 0.05))
# [1] 0.801

print(mean(p_values_KS_re <= 0.05))
# [1] 1

print(mean(p_values_KM <= 0.05))
# [1] 0.032
