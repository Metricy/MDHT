library(MASS)
setting <- 1

type_number <- 2
people_size <- seq(150, length.out=type_number, by=10)


base <- 3 # number of correlated norm-dist column


mu_range <- seq(-0.5,0.5,0.001)
mu <- list()
for (i in 1:type_number){
  mu[[i]] <- sample(mu_range, base, replace = T)
}

H <- matrix(rnorm(base^2), nrow=base); H <- H %*% t(H);
sigma <- H/median(diag(H))

#sigma <- matrix(c(0.3963938, 0.6683469, 0.524531, 0.6683469, 5.3546752, 0.539836,0.5245310,0.5398360,1.000000), nrow=3)

#sigma <- diag(c(1,1.5,0.6))

people <- NA
for (i in 1:type_number){
  # correlated norm_dist columns
  norm_dist <- mvrnorm(people_size[i], mu[[i]],sigma) 
  
  assign(paste("people_type",i,sep="_"), norm_dist)
  people <- rbind(people, norm_dist)
}
people <- data.frame(people[-1,])


