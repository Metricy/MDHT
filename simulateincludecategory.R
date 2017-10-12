
generatecategory <- function(category,prob,n){
  newcolumn=c()
  for (i in 1:length(category)){
    categorynum=category[i]
    newcolumn=rbind(newcolumn,sample(0:(category[i]-1),n,replace=TRUE,prob[[i]]))
  }
  newcolumn=t(newcolumn)
  return(newcolumn)
}


k <- 10
type_number <- 10
mu_range <- 0:100
sigma_range <- 1:5
people_size <- rep(1000, type_number)
## this "category" vector specifies the number of categorical columns and the number of 
#categories in each column. eg: there're 4 categorical columns and have 2,3,2,2 categories respectively
category=c(2,3,2,2)

mu <- list()
probability=list()
for (i in 1:type_number){
  mu[[i]] <- sample(mu_range, type_number, replace = T)
  prob=list()
  for (j in 1:length(category)){
    categorynum=category[j]
    x<-runif(categorynum,min=0,max=1)
    x<-x/sum(x)
    prob[[j]]=x
  }
  probability[[i]]=prob
}

sigma <- diag(sample(sigma_range, type_number, replace = T))


people <- NA
for (i in 1:type_number){
  r <- mvrnorm(people_size[i], mu[[i]],sigma)
  categories=generatecategory(category,probability[[i]],people_size[i])
  r <- cbind(r,categories)
  r <- cbind(r, type=rep(i,people_size[i]))
  people <- rbind(people,r)
  assign(paste("people_type",i,sep="_"), r)
}
people <- data.frame(people[-1,])
