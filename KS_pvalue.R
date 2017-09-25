set.seed(1)
KS_pvalue <- function(data_frame, sep_ratio, train_ratio){
  choice_sep <- sample(1:dim(data_frame)[1], floor(dim(data_frame)[1]*sep_ratio))
  A <- data_frame[choice_sep,]
  A <- cbind(A, group=rep(0,dim(A)[1]))
  B <- data_frame[-choice_sep,]
  B <- cbind(B, group=rep(1,dim(B)[1]))
  
  # train&test via KS test
  choice_train_A <- sample(1:dim(A)[1], floor(dim(A)[1]*train_ratio))
  choice_train_B <- sample(1:dim(B)[1], floor(dim(B)[1]*train_ratio))
  
  train_set <- rbind(A[choice_train_A,],B[choice_train_B,])
  test_set_A <- A[-choice_train_A,]
  test_set_B <- B[-choice_train_B,]
  
  
  glm.fit <- glm(group~.-type, data=train_set, family=binomial)
  prob_test_A <- predict(glm.fit,test_set_A,type="response")
  prob_test_B <- predict(glm.fit,test_set_B,type="response")  
  KS <- ks.test(prob_test_A, prob_test_B)
  return(KS$p.value)
}

KS_pvalue_fake <- function(data_frame, sep_ratio, train_ratio){
  A <- data_frame[1:floor(dim(data_frame)[1]*sep_ratio),]
  A <- cbind(A, group=rep(0,dim(A)[1]))
  B <- data_frame[floor(dim(data_frame)[1]*sep_ratio)+1:dim(people)[1],]
  B <- cbind(B, group=rep(1,dim(B)[1]))
  
  # train&test via KS test
  choice_train_A <- sample(1:dim(A)[1], floor(dim(A)[1]*train_ratio))
  choice_train_B <- sample(1:dim(B)[1], floor(dim(B)[1]*train_ratio))
  
  train_set <- rbind(A[choice_train_A,],B[choice_train_B,])
  test_set_A <- A[-choice_train_A,]
  test_set_B <- B[-choice_train_B,]
  
  
  glm.fit <- glm(group~.-type, data=train_set, family=binomial)
  prob_test_A <- predict(glm.fit,test_set_A,type="response")
  prob_test_B <- predict(glm.fit,test_set_B,type="response")  
  KS <- ks.test(prob_test_A, prob_test_B)
  return(KS$p.value)
}
