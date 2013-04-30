windows()
hostbubble<-ggplot(cmatrix,aes(x=Var1,y=Var2, size=Freq,label=Freq)) +
geom_point(colour='white', fill='red', shape=21)+
scale_size_area(max_size = 23)+
scale_x_continuous(name="Log(no. larval host species)", limits=c(-0.05,3))+
scale_y_continuous(name="Red list classification", limits=c(-0.25,5))+
geom_text(size=3)+
theme_bw() +
theme(legend.position = "none",	#remove legend
		panel.grid.major = element_blank(), # switch off major gridlines
		panel.grid.minor = element_blank(), # switch off minor gridlines
		panel.border = element_blank(),	# strip box
		axis.line = element_line(),	# add axes
		axis.title.x = element_text(size=9, vjust=-0.1),
    axis.title.y = element_text(size=9, angle=90, vjust=0.25),	 #face="bold"
		axis.text.x = element_text(size=9),
		axis.text.y = element_text(size=9),
		text=element_text(family="Times")
		)
print(hostbubble)
ggsave(hostbubble,file="fig_hostsbubble_14x9.pdf",width=14,height=9, units="cm")

