tempcoef<- c()
tempcoef.se<- c()

#tempcoef_noeff<- c()
#tempcoef_noeff.se<- c()

for(sp in 1:nspecies){
	
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
		spfit<-lmer(dates_l ~ ls_l + stemp_l + log(effort_l) + (stemp_l|ls_l), data=spdata)
		#summary(spfit)}
		#number of fixed effects
		nfix<- length(fixef(spfit))-1
		#store mean temperature effect
		tempcoef<- c(tempcoef, fixef(spfit)[[nfix]])
		tempcoef.se<- c(tempcoef.se, sqrt(diag(vcov(spfit)))[nfix])
		#can also use se.fixef(spfit) from library 'arm'
		
		#spfit_noeff<-lmer(dates_l ~ ls_l + stemp_l + (stemp_l|ls_l), data=spdata)
		#nfix_noeff<- length(fixef(spfit_noeff))-1
		##tempcoef.noeff<- c(tempcoef_noeff, fixef(spfit_noeff)[[nfix_noeff]])
		#tempcoef_noeff.se<- c(tempcoef_noeff.se, sqrt(diag(vcov(spfit_noeff)))[nfix_noeff])		
	}
	else{
		tempcoef<- c(tempcoef, NA)		
		tempcoef.se<- c(tempcoef.se, NA)			
		#spfit<-glm(dates_l ~ stemp_l + log(effort_l), data=spdata)
		
		#tempcoef_noeff<- c(tempcoef_noeff, NA)		
		#tempcoef_noeff.se<- c(tempcoef_noeff.se, NA)	
	}

	
	#spfit_noeff<-lmer(dates_l ~ ls_l + stemp_l  + (stemp_l|ls_l), data=spdata)
	#summary(spfit_noeff)
	
}	#end species loop

xorder<- 1:nspecies
df<-data.frame(xorder,tempcoef,tempcoef.se)
#df_noeff<-data.frame(xorder,tempcoef_noeff,tempcoef_noeff.se)

windows()
hist(tempcoef,breaks=10)

windows()
tempplot<- ggplot(data=na.omit(df), aes(x=xorder, y=tempcoef)) + 
    geom_errorbar(aes(ymin=tempcoef-1.96*tempcoef.se, ymax=tempcoef+1.96*tempcoef.se), width=.1) +
    geom_point() +
	geom_hline(yintercept=0, linetype=2) +
	xlab("Species") +
	ylab("Temperature effect") +
	theme_bw()
	
print(tempplot)

