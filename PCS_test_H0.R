library(MASS)
num_sim<-1000
rej<-rep(0,num_sim)
min_p_values<-c();Na<-c()

ksrej<-rep(0,num_sim)

source('simulate.R')
source('supplement.R')
source('Functions for Pearson`s chi-square test.R')


### Main entry ###

set.seed(1)

for(f in 1:num_sim){

  # Data generation
  res<-separate(people,0.65)
  A<-res[[1]][,1:10]
  B<-res[[2]][,1:10]
  
  # Test statistic generation
  chi_sqr<-c()
  for(i in 1:type_number){
    chi_sqr<-c(chi_sqr,Q(list(A[,i],B[,i]),lo=20,up=80,sep=20))}
  n<-test(20,80,20,chi_sqr)
  
  # Check number of NAs generated in each trial if necessary
  Na<-c(Na,sum(is.na(chi_sqr)))
  
  # Judging whether to reject H0
  if(n[[2]]=='Holm`s step-down'){
    # Check minimum values of p-values if want to
    min_p_values<-c(min_p_values,n[[1]])
    if(n[[1]]<=(0.05/(type_number-sum(is.na(chi_sqr))))){rej[f]=1}
  }
  if(n[[2]]=='Hochberg`s step-up'){
    if(n[[1]]>=1){rej[f]<-1}}
  
  ### Kolmogorov-Smirnov Tests on A & B ###
  
  ksps<-c()
  for(l in 1:type_number){
    ksp<-ks.test(A[,l],B[,l])$p.value
    ksps<-c(ksps,ksp)}
  if(min(c(na.omit(ksps)))<=(0.05/(type_number-sum(is.na(ksps))))){
    ksrej[f]=1}
}

print(mean(rej))
# 0.041
print(mean(ksrej))
# 0.035
