source("simulate.R")
source("supplement.R")
source("KS_func.R")
set.seed(1)

sep_ratio <- 0.65
train_ratio <- 0.7
test_times <- 100
bootstrap_times <- 1000

#KS test + bootstrap
reject_ratio = rep(0, test_times)

for (i in 1:test_times){
  # origin p-value
  p_0 <- KS_pvalue(people, sep_ratio, train_ratio, FALSE)
  
  # bootstrap
  p_value <- c()
  for (j in 1:bootstrap_times){
    p_value[j] <- KS_pvalue(people, sep_ratio, train_ratio, FALSE)
  }
  
  #hist(p_value)
  quant <- quantile(p_value,c(0.05))
  reject_ratio[i] <-  p_0<=quant
}
print(mean(reject_ratio))
# [1] 0.03
