windows()
spann90fig<-ggplot(data=sp90frame,aes(x = s90, y = trend_s90) ) + 
	geom_point(shape=16,size=3)  + # add a scatterplot; constant size, shape/fill depends on lesion
	geom_smooth(method=lm, se=FALSE, color ="black", size=1) + # Add linear regression lines & no shaded confidence region 
	scale_x_continuous("Adult activity period residuals", breaks=-2:3) + # have tick marks for each session
  scale_y_continuous("Log(trend) residuals", limits = c(-1.5, 2.5), breaks=seq(-1, 3, by = 1)) + # rescale Y axis slightly
	theme_bw() + 
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
		axis.text.y = element_text(size=10)
	)
print(spann90fig)
