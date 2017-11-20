KS_pvalue <- function(A, B, train_ratio){
  A <- data.frame(cbind(A, group=rep(0, nrow(A))))
  B <- data.frame(cbind(B, group=rep(1, nrow(B))))
  # train&test via KS test
  choice_train_A <- sample(1:dim(A)[1], floor(dim(A)[1]*train_ratio))
  choice_train_B <- sample(1:dim(B)[1], floor(dim(B)[1]*train_ratio))
  
  train_set <- rbind(A[choice_train_A,],B[choice_train_B,])
  test_set_A <- A[-choice_train_A,]
  test_set_B <- B[-choice_train_B,]
  
  
  glm.fit <- glm(group~., data=train_set, family=binomial, maxit=100)
  prob_test_A <- predict(glm.fit,test_set_A,type="response")
  prob_test_B <- predict(glm.fit,test_set_B,type="response")  
  KS <- ks.test(prob_test_A, prob_test_B)
  return(KS$p.value)
}

KS_pvalue_re <- function(A, B, train_ratio, resample_time=100){
  p_0 <- KS_pvalue(A, B, train_ratio)
  p_values <- rep(0, resample_time)
  
  for (i in 1:resample_time){
    pooled <- rbind(A, B)
    choice_A <- sample(1:nrow(pooled), nrow(A))
    p_values[i] <- KS_pvalue(pooled[choice_A,], pooled[-choice_A,], train_ratio)
  }
  return(mean(p_0>=p_values))
}


KS_pvalue.2 <- function(A, B){
  A <- data.frame(cbind(A, group=rep(0, nrow(A))))
  B <- data.frame(cbind(B, group=rep(1, nrow(B))))
  
  pooled <- rbind(A, B)
  glm.fit <- glm(group~., data=pooled, family=binomial)
  prob_test_A <- predict(glm.fit,A,type="response")
  prob_test_B <- predict(glm.fit,B,type="response")  
  KS <- ks.test(prob_test_A, prob_test_B)
  return(KS$p.value)
}

KS_pvalue_re.2 <- function(A, B, resample_time=100){
  p_0 <- KS_pvalue.2(A, B)
  p_values <- rep(0, resample_time)
  
  for (i in 1:resample_time){
    pooled <- rbind(A, B)
    choice_A <- sample(1:nrow(pooled), nrow(A))
    p_values[i] <- KS_pvalue.2(pooled[choice_A,], pooled[-choice_A,])
  }
  return(mean(p_0>=p_values))
}

