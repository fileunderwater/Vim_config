
select=0
#select only landskap where the species has been found, and remove column of years.
art_temp = art_landskapsvis[,2:(numlandskap+1),][,(presencetest > select),]
landskap_selected = landskap[(presencetest > select)]
species_summary = list(years=yearvec,landskap=landskap_selected,phen=art_temp[,,1:3],
		temperature=art_temp[,,4:10], months=rel_months)

#NoLandscapes<-length(species_summary$landskap)
NoLandscapes<-length(landskap_selected)

#create init for phenology where there is NA
initna=is.na(species_summary$phen)		#find NAs
#means over all landscapes and years
init_mean=mean(colMeans(species_summary$phen[,,3],na.rm=TRUE))	
initna[initna==TRUE]<-init_mean		#set to overall mean if NA
initna[initna==0]<-NA		#set to NA if FALSE (now 0)


#set up output data
setwd("C:/Users/tobjep/Jobb/Projekt/Climate_cerambycidae_NHC/data/openbugs/")
dates=species_summary$phen[,,1][y1:y2,]
temperature=species_summary$temperature[,,7][y1:y2,]
init=initna[,,1][y1:y2,]
effort=art_temp[,,11][y1:y2,]
mtemp<-apply(temperature,2,mean)
sdtemp<-apply(temperature,2,sd)
temp2=t(apply(t(apply(temperature,1,'-',mtemp)),1,'/',sdtemp))

