set.seed(1)
source("Rand.R")

k_means<-function(data_frame, sep_ratio, k, fake){
  data_frame <- separate(data_frame, sep_ratio, fake)
  data <- rbind(data_frame[[1]],data_frame[[2]])
  c <- data[1:(dim(data)[2]-2)]
  km <- kmeans(c,k)
  result1 <- table(data$type, km$cluster)
  result2 <- table(data$group, km$cluster)
  result3 <- result2[1,]/result2[2,]
  
  j=c()
  for(i in 0:99){
    rd <- rand_mes(list(data$type[(100*i+1):(100*(i+1))],km$cluster[(100*i+1):(100*(i+1))]))
    j <- c(j,rd)
  }
  
  similarity <- mean(j)
  result <- list()
  result[[1]] <- result1
  result[[2]] <- result2
  result[[3]] <- result3
  result[[4]] <- similarity
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