
windows()
#postscript("fig_parreg_gentime.eps",horizontal=FALSE, paper="special",height=3.46,width=5.6)
LC_fig<-ggplot(data=lcframe, aes(x = lc, y = trend_lc, group = g2) ) + # g becomes a classifying factor
	#qplot(lc,trend_lc,colour=g) + 
	geom_point(aes(shape=g, fill=g), size=2) + # add a scatterplot; constant size, shape/fill depends on lesion
	geom_smooth(method=lm, se=FALSE, color ="black", size=1, aes(linetype = g)) + # Add linear regression lines & no shaded confidence region
	scale_shape_manual(values=c(21,21)) + # set shape of classes
    scale_fill_manual(values=c("black","white")) + # set colour of classes
	scale_x_continuous("Generation time residuals", breaks=-2:3) + # have tick marks for each session
    scale_y_continuous("Log(trend) residuals", limits = c(-1.5, 2.5), breaks=seq(-1, 3, by = 1)) + # rescale Y axis slightly
	theme_bw() +
	#theme_set(theme_bw(24)) +
	theme(legend.key = element_blank(), # switch off the rectangle around symbols in the legend
		legend.position = c(0.85,0.9), # manually position the legend (numbers being from 0,0 at bottom left of whole plot to 1,1 at top right)
		legend.title = element_blank(), # switch off the legend title
		panel.grid.major = element_blank(), # switch off major gridlines
		panel.grid.minor = element_blank(), # switch off minor gridlines
		panel.border = element_blank(),	# strip box
		axis.line = element_line(),	# add axes
		axis.title.x = element_text(size=9, vjust=-0.1),					#face="bold", 
    axis.title.y = element_text(size=9, angle=90, vjust=0.25),#face="bold", 
		axis.text.x = element_text(size=9),
		axis.text.y = element_text(size=9),
		text=element_text(family="Times")
		#plot.margin = unit(c(1, 1, 0.8, 0.5), "lines")
		#panel.background=theme_blank(),
		#strip.text.y = theme_text(),
		)
print(LC_fig)
ggsave(LC_fig,file="fig_parreg_gentime_8x6.pdf",width=8,height=6, units="cm")

