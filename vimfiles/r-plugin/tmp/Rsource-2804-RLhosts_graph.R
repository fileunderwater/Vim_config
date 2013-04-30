#alt plot
radius <- sqrt( cmatrix$Freq/ pi )
symbols(cmatrix$Var1, cmatrix$Var2, circles=radius, inches=0.38, fg="white", bg="red",
	tck=0.015, cex.lab=1.2,
	xlab="Log(no. larval host species)", ylab="Red list classification")
text(cmatrix$Var1, cmatrix$Var2,cmatrix$Freq,cex=0.8)
