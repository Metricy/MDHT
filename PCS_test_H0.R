library(MASS)
num_sim<-1000

source('simulate.R')
source('supplement.R')
source('Functions for Pearson`s chi-square test.R')
set.seed(1)


print(mean(rej))
# 0.041 (Pearson`s Chi-square)
print(mean(ksrej))
# 0.035 (Kolmogorov-Smirnov)
