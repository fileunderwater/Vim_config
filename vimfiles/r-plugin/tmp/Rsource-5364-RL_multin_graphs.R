windows()
RLadultact<-ggplot(data=analysis, aes(x = spann90, y = RL_new, group = overw) ) + # g becomes a classifying factor
	geom_point(aes(shape=overw, fill=overw), size=2, position=position_jitter(width=0, height=0.25)) + # add a scatterplot; constant size, shape/fill depends on lesion
	#geom_jitter(aes(shape=overw, fill=overw), size=3) + # add a scatterplot; constant size, shape/fill depends on lesion
	geom_smooth(method=lm, se=FALSE, color ="black", size=0.5, aes(linetype = overw)) + # Add linear regression lines & no shaded confidence region
	scale_shape_manual(values=c(21,21)) + # set shape of classes
     	scale_fill_manual(values=c("black","white")) + # set colour of classes
	scale_x_continuous("Adult activity period", limits= c(-2.1,3.2)) + #breaks=-2:3), have tick marks for each session
    	scale_y_continuous("Red list classification", limits = c(-0.3,5.2), breaks=0:5) + 
	theme_bw() +
	#theme_set(theme_bw(24)) +
	theme(legend.key = element_blank(), # switch off the rectangle around symbols in the legend
		legend.position = c(0.85,0.9), # manually position the legend (numbers being from 0,0 at bottom left of whole plot to 1,1 at top right)
		legend.title = element_blank(), # switch off the legend title
		panel.grid.major = element_blank(), # switch off major gridlines
		panel.grid.minor = element_blank(), # switch off minor gridlines
		panel.border = element_blank(),	# strip box
		axis.line = element_line(),	# add axes
		axis.title.x = element_text(size=9, vjust=-0.1),
    axis.title.y = element_text(size=9, angle=90, vjust=0.25),
		axis.text.x = element_text(size=9),
		axis.text.y = element_text(size=9),
		text=element_text(family="Times")
		#plot.margin = unit(c(1, 1, 0.8, 0.5), "lines")
		#panel.background=theme_blank(),
		#strip.text.y = theme_text(),
		)
print(RLadultact)
ggsave(RLadultact,file="fig_RLadultact_83x6.pdf",width=8.3,height=6, units="cm")

