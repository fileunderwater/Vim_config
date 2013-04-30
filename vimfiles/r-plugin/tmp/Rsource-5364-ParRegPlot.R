windows()
spann90fig<-ggplot(data=sp90frame,aes(x = s90, y = trend_s90) ) + 
	geom_point(shape=16,size=2)  + # add a scatterplot; constant size, shape/fill depends on lesion
	geom_smooth(method=lm, se=FALSE, color ="black", size=0.5) + # Add linear regression lines & no shaded confidence region 
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
		axis.title.x = element_text(size=9, vjust=-0.1),
          	axis.title.y = element_text(size=9, angle=90, vjust=0.25),
		axis.text.x = element_text(size=9),
		axis.text.y = element_text(size=9),
		text=element_text(family="Times")
	)
print(spann90fig)
ggsave(spann90fig,file="fig_parreg_adultact_83x6.pdf",width=8.3,height=6,units="cm")

