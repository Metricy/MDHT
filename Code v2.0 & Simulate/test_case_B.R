set.seed(1)
source("supplement.R");
source("KM_func.R");source("ES_func.R");source("KS_func.R")

sep_ratio <- 0.65
test_times <- 1000
k <- 10

p_values_ES <- rep(0, test_times)
p_values_KS <- rep(0, test_times)
p_values_KS_re <- rep(0, test_times)
p_values_KM <- rep(0, test_times)

for (j in 1:test_times){
  source("sim_case_B.R")
  data_frame <- separate(people, sep_ratio, TRUE)
  A <- data_frame[[1]]; A <- A[,1:(ncol(A)-1)]
  B <- data_frame[[2]]; B <- B[,1:(ncol(B)-1)]
  
  #A <- people_type_1
  #B <- people_type_2
  #p_values_ES[j] <- ES_pvalue(A, B, 100)
  #p_values_KS[j] <- KS_pvalue(A, B, 0.7)
  p_values_KS_re[j] <- KS_pvalue_re.2(A, B)
  #p_values_KM[j] <- PKS_pvalue(k_means(A, B, k))
  #if (p_values_KM[j] >= 0.05){
  #  break()
  #}
}

print(mean(p_values_ES <= 0.05))
# [1] 0.367

print(mean(p_values_KS <= 0.05))
# [1] 0.732

print(mean(p_values_KS_re <= 0.05))
# [1] 0.866

print(mean(p_values_KM <= 0.05))
# [1] 0.127
