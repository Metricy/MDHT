library(MASS)
setting <- 1

type_number <- 3
people_size <- seq(100, length.out=type_number, by=10)


base <- 3 # number of correlated norm-dist column


mu_range <- seq(-0.3,0.3,0.01)
mu <- sample(mu_range, base, replace = T)


H <- matrix(rnorm(base^2), nrow=base); H <- H %*% t(H);
sigma <- H/median(diag(H))

#sigma <- diag(c(1,1.5,0.6))

people <- NA
for (i in 1:type_number){
  # correlated norm_dist columns
  norm_dist <- mvrnorm(people_size[i], mu,sigma) 
  
  assign(paste("people_type",i,sep="_"), norm_dist)
  people <- rbind(people, norm_dist)
}
people <- data.frame(people[-1,])


