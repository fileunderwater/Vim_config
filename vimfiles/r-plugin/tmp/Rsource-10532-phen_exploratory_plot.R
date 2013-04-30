graphics.off()

yl<-dim(dates)[1]
yvec<-c(1:yl)
nrcounties<-dim(dates)[2]
mtemp<-apply(temperature,2,mean)
sdtemp<-apply(temperature,2,sd)
temp2=t(apply(t(apply(temperature,1,'-',mtemp)),1,'/',sdtemp))

