
#storage for effects
timecoef<- c()
timecoef.se<- c()

#timecoef_noeff<- c()
#timecoef_noeff.se<- c()

for(sp in 1:97){
	
	# -------------------------------------
	# setup data
	
	dates=datesf[,,sp][y1:y2,]
	temperature=temperature_pr[y1:y2,2:(NoLandscapes+1)]
	temperature2=temperature_pa[y1:y2,2:(NoLandscapes+1)]
	effort=effort_all[,,sp][y1:y2,]
	yearsexp<-dim(dates)[1]
	
	#standardized version of temperature
	mtemp<-apply(temperature,2,mean)
	sdtemp<-apply(temperature,2,sd)
	stemp=t(apply(t(apply(temperature,1,'-',mtemp)),1,'/',sdtemp))
	
	mtemp2<-apply(temperature2,2,mean)
	sdtemp2<-apply(temperature2,2,sd)
	stemp2=t(apply(t(apply(temperature2,1,'-',mtemp2)),1,'/',sdtemp2))
		
	#dataframe for lmer
	dates_l<- c()
	temp_l<- c()
	temp2_l<- c()
	stemp_l<- c()
	stemp2_l<- c()
	effort_l<- c()
	ls_l<- c()

	for(ii in 1:NoLandscapes){
		dates_l<- c(dates_l,dates[,ii])
		temp_l<- c(temp_l,temperature[,ii])
		temp2_l<- c(temp2_l,temperature2[,ii])
		effort_l<- c(effort_l,effort[,ii])
		ls_l<- c(ls_l,rep(landskap[ii],yearsexp))
		stemp_l<- c(stemp_l,stemp[,ii])
		stemp2_l<- c(stemp2_l,stemp2[,ii])
	}
	ys<-rep(1:71,NoLandscapes)
	spdata<- data.frame(dates_l,effort_l,temp_l,stemp_l,stemp2_l,ls_l,ys)
		
	#-------------------------------------------
	# analysis

	if(splandskap[sp]>3){
		spfit.time<-lmer(dates_l ~ ls_l + ys + log(effort_l) + (ys|ls_l), data=spdata)
		#summary(spfit.time)}
		#number of fixed effects
		nfix<- length(fixef(spfit.time))-1
		#store mean temperature effect
		timecoef<- c(timecoef, fixef(spfit.time)[[nfix]])
		timecoef.se<- c(timecoef.se, sqrt(diag(vcov(spfit.time)))[nfix])
		#can also use se.fixef(spfit.time) from library 'arm'
		
		#spfit.time_noeff<-lmer(dates_l ~ ls_l + stemp_l + (stemp_l|ls_l), data=spdata)
		#nfix_noeff<- length(fixef(spfit.time_noeff))-1
		##timecoef.noeff<- c(timecoef_noeff, fixef(spfit.time_noeff)[[nfix_noeff]])
		#timecoef_noeff.se<- c(timecoef_noeff.se, sqrt(diag(vcov(spfit.time_noeff)))[nfix_noeff])		
	}
	else{
		timecoef<- c(timecoef, NA)		
		timecoef.se<- c(timecoef.se, NA)			
		#spfit.time<-glm(dates_l ~ ys + log(effort_l), data=spdata)
		
		#timecoef_noeff<- c(timecoef_noeff, NA)		
		#timecoef_noeff.se<- c(timecoef_noeff.se, NA)	
	}

	
	#spfit.time_noeff<-lmer(dates_l ~ ls_l + stemp_l  + (stemp_l|ls_l), data=spdata)
	#summary(spfit.time_noeff)
	
}	#end species loop

xorder<- 1:97
df<-data.frame(xorder,timecoef,timecoef.se)
#df_noeff<-data.frame(xorder,timecoef_noeff,timecoef_noeff.se)

windows()
hist(timecoef,breaks=10)

windows()
tempplot<- ggplot(data=na.omit(df), aes(x=xorder, y=timecoef)) + 
    geom_errorbar(aes(ymin=timecoef-1.96*timecoef.se, ymax=timecoef+1.96*timecoef.se), width=.1) +
    geom_point() +
	geom_hline(yintercept=0, linetype=2) +
	xlab("Species") +
	ylab("Trend") +
	theme_bw()
	
print(tempplot)

