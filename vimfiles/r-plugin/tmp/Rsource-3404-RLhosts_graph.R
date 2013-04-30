require(plotrix)
#read data
RLhosts <- read.csv("C:/Users/tobjep/Jobb/Projekt/comparative study on cerambycidae/data/RLnew_hosts.csv", header=TRUE, sep="|")

#calculate occurances at each point
#alt: ctable<-tapply(RLhosts$RL_new, list(RLhosts$loghosts, RLhosts$RL_new), length)
ctable<-table(RLhosts$loghosts, RLhosts$RL_new)
#redefine as "long" format
cmatrix<-as.data.frame(ctable)

#redefine factors as numeric
cmatrix$Var1=as.numeric(as.character(cmatrix$Var1))
cmatrix$Var2=as.numeric(as.character(cmatrix$Var2))
str(cmatrix)	#to check structure
cmatrix$Freq[cmatrix$Freq==0]=NA	#change zeros to NA


#bubble plot
#symbols(crime$murder, crime$burglary, circles=radius)
#sizeplot(RLhosts$loghosts, RLhosts$RL_new, bg="red", xlab="Log(no. larval host species)", ylab="Red list classification") 
#fg="white", bg="red", xlab="Log(no. larval host species)", ylab="Red list classification")
windows()
#postscript("fig_hostsbubble.eps", horizontal = FALSE, onefile = FALSE, paper = "special")	#units in inches
sizeplot(RLhosts$loghosts, RLhosts$RL_new, col="red",xlab="Log(no. larval host species)", ylab="Red list classification",tck=0.015, 
				 frame.plot=FALSE, xlim=c(0, 3), ylim=c(0,5)) 


#labels
text(cmatrix$Var1, cmatrix$Var2, labels=cmatrix$Freq,cex=0.8,pos=3,offset=1)

#alt plot
radius <- sqrt( cmatrix$Freq/ pi )
symbols(cmatrix$Var1, cmatrix$Var2, circles=radius, inches=0.38, fg="white", bg="red",
	tck=0.015, cex.lab=1.2,
	xlab="Log(no. larval host species)", ylab="Red list classification", frame.plot=FALSE)
text(cmatrix$Var1, cmatrix$Var2,cmatrix$Freq,cex=0.8)
#dev.off()
 
