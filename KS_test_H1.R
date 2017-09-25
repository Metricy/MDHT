source("simulate.R")
source("KS_pvalue.R")
set.seed(1)

sep_ratio <- 0.65
train_ratio <- 0.7
test_times <- 100
bootstrap_times <- 1000

# KS test + bootstrap
reject_ratio = rep(0, test_times)

for (i in 1:test_times){
  # origin p-value fake this time
  p_0 <- KS_pvalue_fake(people, sep_ratio, train_ratio)
  
  # bootstrap
  p_value <- c()
  for (j in 1:bootstrap_times){
    p_value[j] <- KS_pvalue(people, sep_ratio, train_ratio)
  }
  
  #hist(p_value)
  quant <- quantile(p_value,c(0.95))
  reject_ratio[i] <-  p_0<=quant
}
print(mean(reject_ratio))
# [1] 1
