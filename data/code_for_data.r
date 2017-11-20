library('energy')
set.seed(1)
nci.data <- read.table("nci.data.txt",header=F)
real.data <- NA
for (i in 1:dim(nci.data)[1]){
  if (sum(nci.data[i,]==0) == 0 ){
    real.data <- rbind(real.data,nci.data[i,])
  }
}
real.data <- data.frame(real.data[-1,])

NSCLC <- data.frame(t(real.data[,c(9,10,19,31,32,33,53,54,55)]))
CNS <- data.frame(t(real.data[,c(1,2,3,6,7)]))
renal <- data.frame(t(real.data[,c(4,11:17,20)]))
melanoma <- data.frame(t(real.data[,c(23,56,59:64)]))
colon <- data.frame(t(real.data[,c(42:48)]))
ovarian <- data.frame(t(real.data[,c(22,25:29)]))