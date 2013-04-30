#with ggplot
windows()
hostbubble<-ggplot(cmatrix,aes(x=Var1,y=Var2, size=Freq,label=Freq)) +
geom_point(colour='white', fill='red', shape=21)+
scale_size_area(max_size = 23)+
scale_x_continuous(name="Log(no. larval host species)", limits=c(-0.2,3))+
scale_y_continuous(name="Red list classification", limits=c(-0.2,5))+
geom_text(size=4)+
theme_bw() +
theme(legend.position = "none",	#remove legend
		panel.grid.major = element_blank(), # switch off major gridlines
		panel.grid.minor = element_blank(), # switch off minor gridlines
		panel.border = element_blank(),	# strip box
		axis.line = element_line(),	# add axes
		axis.title.x = element_text(face="bold", size=12, vjust=-0.2),
    axis.title.y = element_text(face="bold", size=12, angle=90, vjust=0.1),	 #face="bold"
		axis.text.x = element_text(size=10),
		axis.text.y = element_text(size=10)
		)
print(hostbubble)
ggsave(hostbubble,file="fig_hostsbubble.eps",width=14,height=12, units="cm")

