set.seed(1)

# separate peolpe into Group A/B 
# fake FALSE means random | TRUE means direct cut by sep_ratio

separate <- function(data_frame, sep_ratio, fake=FALSE){
  if (fake == FALSE){
    choice_sep <- sample(1:dim(data_frame)[1], floor(dim(data_frame)[1]*sep_ratio))
  } else{
    choice_sep <- 1:(floor(dim(data_frame)[1]*sep_ratio))
  }
  A <- data_frame[choice_sep,]
  A <- cbind(A, group=rep(0,dim(A)[1]))
  B <- data_frame[-choice_sep,]
  B <- cbind(B, group=rep(1,dim(B)[1]))
  data_frame <- list()
  data_frame[[1]] <- A
  data_frame[[2]] <- B
  return(data_frame)
}
