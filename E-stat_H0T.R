source('simulate.R')
source('supplement.R')

library('energy')

set.seed(1)

sep_ratio<-0.65
source('Functions_E-stat_Version1.R')
num_sim<-100
rej<-c()
do_test(rej,num_sim,H0=T,B=99,package=T)
# 0.04

num_sim<-100
rej<-c()
do_test(rej,num_sim,H0=T,B=99,package=F)
# 0.05
