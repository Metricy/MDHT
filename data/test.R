source("KM_func.R");source("ES_func.R");source("KS_func.R")
source("code_for_data.r")

A <- NSCLC
B <- renal

p_values <- rep(0, 3)

k=4
p_values[1] <- PKS_pvalue(k_means(A, B, k))

p_values[2] <- KS_pvalue(A, B, 0.65)

p_values[3] <- ES_pvalue(A, B, 499)

p_values