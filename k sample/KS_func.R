library(nnet)
PKS_pvalue <- function(table){
  table <- table + 1e-10
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
  return(list(p.value=p_value, sta=G_square))
}

KS_pvalue <- function(X, size, train_ratio){
  X <- data.frame(X, group=rep(0:(length(size)-1), size))
  
  # train&test via KS test
  choice <- sample(1:sum(size), floor(sum(size)*train_ratio))
  fit <- multinom(group~., data=X[choice, ])
  
  test_set <- X[-choice, ]
  prob <- predict(fit, test_set, "probs")[,1]
  prob <- cut(prob, unique(quantile(prob)), include.lowest = T)
  
  cont.tab <- NA
  for (i in 0:(length(size)-1)){
    cont.tab <- rbind(cont.tab, table(prob[test_set$group==i]))
  }
  cont.tab <- cont.tab[-1,]
  PKS_pvalue(cont.tab)$p.value
}

KS_pvalue.2 <- function(X, size){
  X <- data.frame(X, group=rep(0:(length(size)-1), size))
  fit <- multinom(group~., data=X)
  
  prob <- predict(fit, X, "probs")[,1]
  prob <- cut(prob, seq(0,1,0.1), include.lowest = T)
  cont.tab <- NA
  for (j in 0:(length(size)-1)){
    cont.tab <- rbind(cont.tab, table(prob[X$group==j]))
  }
  cont.tab <- cont.tab[-1,]
  PKS_pvalue(cont.tab)$p.value
}

KS_sta <- function(X, size){
  X <- data.frame(X, group=rep(0:(length(size)-1), size))
  fit <- multinom(group~., data=X)
  
  PKS_sta <- 0
  for (i in 1:(length(size)-1)){
    prob <- predict(fit, X, "probs")[,i]
    prob <- cut(prob, seq(0,1,0.1), include.lowest = T)
    cont.tab <- NA
    for (j in 0:(length(size)-1)){
      cont.tab <- rbind(cont.tab, table(prob[X$group==j]))
    }
    cont.tab <- cont.tab[-1,]
    PKS_sta <- PKS_pvalue(cont.tab)$sta + PKS_sta
  }
  PKS_sta
}

KS_re <- function(X, size, resample_time=300){
  G_0 <- KS_sta(X, size)
  G.boot <- rep(0, resample_time)
  
  for (i in 1:resample_time){ 
    choice <- c()
    for (j in 1:length(size)){ # choose with replacement
      choice <- c(choice, sample(1:nrow(X), size[j], replace=T))
    }
    G.boot[i] <- KS_sta(X[choice, ], size)
  }
  G_0 <= quantile(G.boot, 0.025) | G_0 >= quantile(G.boot, 0.975)
}

KS.pairwise <- function(X, size){
  X <- data.frame(X, group=rep(0:(length(size)-1), size))
  
  sta <- 0
  for (i in 1:(length(size)-1)){
    for (j in (i+1):length(size)){
      A <- X[X$group==i-1,]; A$group <- 0
      B <- X[X$group==j-1,]; B$group <- 1
      pooled <- rbind(A, B)
      glm.fit <- glm(group~., data=pooled, family=binomial)
      prob_test_A <- predict(glm.fit,A,type="response")
      prob_test_B <- predict(glm.fit,B,type="response")  
      KS <- ks.test(prob_test_A, prob_test_B)
      sta <- sta + KS$statistic
    }
  }
  sta
}

KS_re.pairwise <- function(X, size, resample_time=300){
  G_0 <- KS.pairwise(X, size)
  G.boot <- rep(0, resample_time)
  
  for (i in 1:resample_time){ 
    choice <- c()
    for (j in 1:length(size)){ # choose with replacement
      choice <- c(choice, sample(1:nrow(X), size[j], replace=T))
    }
    G.boot[i] <- KS.pairwise(X[choice, ], size)
  }
  G_0 <= quantile(G.boot, 0.025) | G_0 >= quantile(G.boot, 0.975)
}