### Functions for Pearson`s chi-square test

# Empirical cumulative distribution function
edf<-function(x,draw=F){
  Fn_x<-c()
  for(i in 1:length(x)){
    Fn_xi<-length(x[which(x<=sort(x)[i])])/length(x)
    Fn_x<-c(Fn_x,Fn_xi)}
  if(draw){plot(sort(x),Fn_x,ylab='Fn(x)')}
  return(Fn_x)}

# Calcularion of expectations of counts in each category.
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

# Multiple hypothesis testing
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
