set.seed(1)
source("supplement.R");
source("KM_func.R");source("ES_func.R");source("KS_func.R")

sep_ratio <- 0.65
test_times <- 200
k <- 10

p_values_ES <- rep(0, test_times)
p_values_KS <- rep(0, test_times)
reject_re <- rep(0, test_times)
reject_re.pair <- rep(0, test_times)

for (j in 1:test_times){
  source("sim_case2.R")
  
  #p_values_ES[j] <- eqdist.etest(people, people_size, R=100)$p.value
  #p_values_KS[j] <- KS_pvalue(people, people_size, 0.7)
  reject_re[j] <- KS_re(people, people_size)
  #reject_re.pair[j] <- KS_re.pairwise(people, people_size)
  cat(j,'\n')
}

print(mean(p_values_ES <= 0.05))
# [1] 0.784

print(mean(p_values_KS <= 0.05))
# [1] 

print(mean(reject_re))
# [1] 0.93

print(mean(reject_re.pair))
# [1] 0.94