windows()
effgrid<- ggplot(aes(x=effort_l, y=dates_l),data=spdata) +
	geom_point(size=2) + 
	facet_wrap(~ls_l, ncol=4, scales="free")	+
	geom_smooth(method=lm, se=FALSE)
print(effgrid)

