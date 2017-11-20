k_means<-function(A, B, k){
  km <- kmeans(rbind(A, B), k, iter.max=50)
  result <- table(c(rep(0,nrow(A)), rep(1,nrow(B))), km$cluster)
  return(result)
}

PKS_pvalue <- function(table){
  n <- sum(table)
  G_square <- 0
  
  for (i in 1:dim(table)[1]){
    n_i <- sum(table[i,])
    for (j in 1:dim(table)[2]){
      n_j <- sum(table[,j])
      G_square <- G_square + (table[i,j]-n_i*n_j/n)^2/(n_i*n_j/n)
    }
  }
  df <- (dim(table)[1]-1) * (dim(table)[2]-1)
  p_value <- 1-pchisq(G_square, df)
  return(p_value)
}