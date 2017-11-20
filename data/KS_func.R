KS_pvalue <- function(A, B, train_ratio){
  # train&test via KS test
  A <- cbind(A, group=rep(0, nrow(A)))
  B <- cbind(B, group=rep(1, nrow(B)))
  
  choice_train_A <- sample(1:dim(A)[1], floor(dim(A)[1]*train_ratio))
  choice_train_B <- sample(1:dim(B)[1], floor(dim(B)[1]*train_ratio))
  
  train_set <- rbind(A[choice_train_A,],B[choice_train_B,])
  test_set_A <- A[-choice_train_A,]
  test_set_B <- B[-choice_train_B,]
  
  
  glm.fit <- glm(group~., data=train_set, family=binomial)
  prob_test_A <- predict(glm.fit,test_set_A,type="response")
  prob_test_B <- predict(glm.fit,test_set_B,type="response")  
  KS <- ks.test(prob_test_A, prob_test_B)
  return(KS$p.value)
}