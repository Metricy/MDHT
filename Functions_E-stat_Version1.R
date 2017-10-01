### FUNCTIONS FOR TESTING EQUAL DISTRIBUTIONS BESED ON E_STATISTIC ###

# Version 1.

# The difference between versions is the estimation of p-value after Monte Carlo
# test, since there are permutations omitted for testing by Monte Carlo methods.
# In this version, the "naive" estimator of the p-value of the approximate 
# permutation test is adopted, where:
# ^p=(1/B)sum(b=1:B)(I{epsilon_b>=epsilon_observed}).

# Generate random permutation
permute<-function(dat){
  org<-1:dim(dat)[1]
  nxt<-sample(org,dim(dat)[1],replace=F)
  dat[org,]<-dat[nxt,]
  new_dat<-dat
  return(new_dat)
}

do_test <- function(rej,num_sim,H0,B,
                    package=T,p.value.check=T) {
  pvalues<-c()

  for(f in 1:num_sim){
    
    # Initial pooled samples
    res<-separate(people,sep_ratio,fake=!H0)
    A1<-res[[1]][,1:type_number]
    A2<-res[[2]][,1:type_number]
    n1<-nrow(A1);n2<-nrow(A2);size<-c(n1,n2)
    pooled_0<-rbind(A1,A2)
    
    if(!package){
      # Observed E-statistic
      e_obs<-as.numeric(eqdist.e(pooled_0,c(n1,n2)))
      
      # Monte Carlo sampling
      m<-c();itr<-B;e_stats<-c()
      for(j in 1:length(size)){m[j]<-sum(size[1:j])}
      for(b in 1:itr){
        pooled_b<-permute(pooled_0)
        A1_b<-pooled_b[1:m[1],];A2_b<-pooled_b[(m[1]+1):m[2],]
        e_b<-as.numeric(eqdist.e(pooled_b,c(n1,n2)))
        e_stats[b]<-e_b
      }
      
      # Estimate p-value & testing
      p_val<-sum(e_stats>=e_obs)/length(e_stats)
      pvalues[f]<-p_val
      rej[f]<-p_val<=0.05}
    
    # Directly use function in package "energy" for test
    if(package){
      p_val<-eqdist.etest(pooled_0,size,R=B)$p.value
      pvalues[f]<-p_val
      rej[f]<-p_val<=0.05}
  }
  if(p.value.check){
    print(pvalues)
  }
  return(mean(rej))
}
    
