
figure<- ggplot(data=datas, aes(x = xx, y = yy)) + # group = g 
	geom_point(size=3) + # add a scatterplot; aes(shape=g, fill=g),
	geom_smooth(method=lm, se=TRUE, color ="black", size=1 ) + # Add linear regression lines & no shaded confidence region, aes(linetype = g)
	#scale_shape_manual(values=c(21)) + # set shape of classes
  #scale_fill_manual(values=c("black")) + # set colour of classes
	scale_x_continuous("Predictor") + # breaks= -2:3 
  scale_y_continuous("Response") + # , limits = c(-1.5, 2.5), breaks=seq(-1, 3, by = 1)
	theme_bw() +	#theme_set(theme_bw(24)) +
	theme(legend.key = element_blank(), # switch off the rectangle around symbols in the legend
		legend.position = c(0.85,0.9), # manually position the legend (numbers being from 0,0 at bottom left of whole plot to 1,1 at top right)
		legend.title = element_blank(), # switch off the legend title
		panel.grid.major = element_blank(), # switch off major gridlines
		panel.grid.minor = element_blank(), # switch off minor gridlines
		panel.border = element_blank(),	# strip box
		axis.line = element_line(),	# add axes
		axis.title.x = element_text(face="bold", size=12, vjust=-0.2),
    axis.title.y = element_text(face="bold", size=12, angle=90, vjust=0.1),
		axis.text.x = element_text(size=10),
		axis.text.y = element_text(size=10),
		text=element_text(family="Helvetica")	# "Times"
		#plot.margin = unit(c(1, 1, 0.8, 0.5), "lines")
		#panel.background=theme_blank(),
		#strip.text.y = theme_text(),
		)
print(figure)

