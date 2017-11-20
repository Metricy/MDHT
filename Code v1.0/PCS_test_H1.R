set.seed(1)
library(MASS)

num_sim<-1000
rej<-rep(0,num_sim)
ksrej<-rep(0,num_sim)

source('simulate.R')
source('supplement.R')
source('Functions for Pearson`s chi-square test.R')

do_test(pcs=T,ks=T,rej,ksrej,num_sim,H0=F)

# Output:

$`Pearson`s Chi-square`
[1] 1

$`Kolmogorov-Smirnov`
[1] 1
