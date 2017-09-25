library(MASS)
source('supplement.R')
num_sim<-1000
rej<-rep(0,num_sim)
M<-c();Na<-c()


for(f in 1:num_sim){
  
  # Data generation
  
  #set.seed(f)
  
  separate <- function(data_frame, sep_ratio, fake=FALSE){
    set.seed(f)
    if (fake == FALSE){
      choice_sep <- sample(1:dim(data_frame)[1], floor(dim(data_frame)[1]*sep_ratio))
    } else{
      choice_sep <- 1:(floor(dim(data_frame)[1]*sep_ratio))
    }
    A <- data_frame[choice_sep,]
    A <- cbind(A, group=rep(0,dim(A)[1]))
    B <- data_frame[-choice_sep,]
    B <- cbind(B, group=rep(1,dim(B)[1]))
    data_frame <- list()
    data_frame[[1]] <- A
    data_frame[[2]] <- B
    return(data_frame)
  }
  
  A<-separate(people,0.65)[[1]][,1:10]
  B<-separate(people,0.65)[[2]][,1:10]
  
  # Functions
  
  # Empirical cumulative distribution function
  
  edf<-function(x,draw=F){
    Fn_x<-c()
    for(i in 1:length(x)){
      Fn_xi<-length(x[which(x<=sort(x)[i])])/length(x)
      Fn_x<-c(Fn_x,Fn_xi)
    }
    if(draw){
      plot(sort(x),Fn_x,ylab='Fn(x)')
    }
    return(Fn_x)
  }
  
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
    return(expts)
  }
  
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
    return(sum(q))
  }
  
  chi_sqr<-c()
  for(i in 1:type_number){
    chi_sqr<-c(chi_sqr,Q(list(A[,i],B[,i]),lo=20,up=80,sep=20))}
  chi_sqr
  
  # Multiple hypothesis testing (Hochberg`s step-up method is used)
  
  test <- function(lo,up,sep) {
    lo=lo;up=up;sep=sep
    num_categ<-(up-lo)/sep+2
    df<-(length(list(A[,1],B[,1]))-1)*(num_categ-1)
    p_vals<-pchisq(chi_sqr,df,lower.tail=F)
    m=0
    for(j in 1:(type_number-sum(is.na(chi_sqr)))){
      if(sort(p_vals)[j]<=0.05/(type_number-sum(is.na(chi_sqr))+1-j)){m=j}}
    return(m)
  }
  n<-test(20,80,20)
  M<-c(M,n)
  Na<-c(Na,sum(is.na(chi_sqr)))
  if(n>=1){
    rej[f]<-1}
}

print(mean(rej))

