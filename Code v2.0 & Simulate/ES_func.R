library(energy)

ES_pvalue <- function(A, B, resample_times){
  n_a <- nrow(A); n_b <- nrow(B); size<-c(n_a, n_b)
  pooled <- rbind(A, B)
  p_value <- eqdist.etest(pooled, size, R=resample_times)$p.value
  return(p_value)
}