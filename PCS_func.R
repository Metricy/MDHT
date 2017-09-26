### Functions for Pearson`s chi-square test

# Empirical cumulative distribution function
edf<-function(x,draw=F){
  Fn_x<-c()
  for(i in 1:length(x)){
    Fn_xi<-length(x[which(x<=sort(x)[i])])/length(x)
    Fn_x<-c(Fn_x,Fn_xi)}
  if(draw){plot(sort(x),Fn_x,ylab='Fn(x)')}
  return(Fn_x)}

# Calculation of expectations of counts in each category.
estimates<-function(x,lo,up,sep){
  expts<-c()
  expt<-length(x[x<lo])/length(x)
  expts<-c(expts,expt)
  for(i in 0:as.integer((up-lo)/sep-1)){
    expt<-length(x[x>=(lo+i*sep)&x<(lo+(i+1)*sep)])/length(x)
    expts<-c(expts,expt)}
  expt<-length(x[x>=up])/length(x)
  expts<-c(expts,expt)
  return(expts)}

# Test statistic
Q<-function(lis,lo,up,sep){
  tot<-c()
  for(k in 1:length(lis)){tot<-c(tot,lis[[k]])}
  expt_prop<-estimates(tot,lo=lo,up=up,sep=sep)
  q<-c()
  for(j in 1:length(lis)){
    expts<-expt_prop*length(lis[[j]])
    obs<-estimates(lis[[j]],lo=lo,up=up,sep=sep)*length(lis[[j]])
    s<-sum(((obs-expts)^2)/expts)
    q<-c(q,s)}
  return(sum(q))}

# Hypothesis testing
test <- function(lo,up,sep,dat,method='Holm`s step-down') {
  num_categ<-(up-lo)/sep+2
  df<-(length(list(A[,1],B[,1]))-1)*(num_categ-1)
  p_vals<-pchisq(dat,df,lower.tail=F)
  if(method=='Hochberg`s step-up'){
    m=0
    for(j in 1:(type_number-sum(is.na(dat)))){
      if(sort(p_vals)[j]<=0.05/(type_number-sum(is.na(dat))+1-j)){m=j}}
    return(list(m,method))
  }
  res<-min(c(na.omit(p_vals)))
  return(list(res,method))}


do_test <- function(pcs=T,ks=T,rej,ksrej,num_sim,H0,
                    NA_check=F,p_values_check=F) {

  min_p_values<-c();Na<-c()
  
  for(f in 1:num_sim){
    
    # Data generation
    res<-separate(people,sep_ratio,fake=!H0)
    A<-res[[1]][,1:type_number]
    B<-res[[2]][,1:type_number]
    
    ### Pearson`s Chi-square Tests on A & B ###
    
    if(pcs){
    
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
    }
    
    ### Kolmogorov-Smirnov Tests on A & B ###
    
    if(ks){
      ksps<-c()
      for(l in 1:type_number){
        ksp<-ks.test(A[,l],B[,l])$p.value
        ksps<-c(ksps,ksp)}
      if(min(c(na.omit(ksps)))<=(0.05/(type_number-sum(is.na(ksps))))){
        ksrej[f]=1}}
  }
  
  if(NA_check){print(Na)}
  if(p_values_check){print(min_p_values)}
  
  result<-list(mean(rej),mean(ksrej))
  names(result)<-c('Pearson`s Chi-square','Kolmogorov-Smirnov')
  return(result)
}
