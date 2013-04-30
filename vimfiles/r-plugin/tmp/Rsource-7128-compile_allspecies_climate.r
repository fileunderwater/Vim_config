
for(mm in 1:numlandskap){
	landskap[,mm]<-rowMeans(temperature_all[,mm+1,])
}	

