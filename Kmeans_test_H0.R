set.seed(1)
source("simulate.R")
source("supplement.R")
source("KM_func.R")

# use k-means to find Contingency table
k <- 10
sep_ratio <- 0.65
test_time <- 100

reject_ratio <- rep(0, test_time)

for (i in 1:test_time){
  result <- k_means(people, sep_ratio, k, FALSE)
  result <- result[[2]]
  p_value <- PKS_pvalue(result)
  reject_ratio[i] <- p_value<=0.05
}

print(mean(reject_ratio))
# [1] 0.06

