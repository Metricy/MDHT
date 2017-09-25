library(MASS)
set.seed(1)

k <- 10
type_number <- 10
mu_range <- 0:100
sigma_range <- 1:5
people_size <- rep(1000, type_number)

mu <- list()
for (i in 1:type_number){
  mu[[i]] <- sample(mu_range, type_number, replace = T)
}

sigma <- diag(sample(sigma_range, type_number, replace = T))

people <- NA
for (i in 1:type_number){
  r <- mvrnorm(people_size[i], mu[[i]],sigma)
  r <- cbind(r, type=rep(i,people_size[i]))
  people <- rbind(people,r)
  assign(paste("people_type",i,sep="_"), r)
}
people <- data.frame(people[-1,])


