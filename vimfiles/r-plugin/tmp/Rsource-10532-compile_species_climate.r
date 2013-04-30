# Läs in funktionen för att sammanställa medeltemp och medelnederbör landskapsvis, 
# TEMP.PRECIP.SUMMARY()
source("C:/Users/tobjep/Jobb/Projekt/Climate_cerambycidae_NHC/R/func_sammanstall_mtemp&nederb_tjmod.R")
#source("C:/Users/tobjep/Jobb/Projekt/Climate_cerambycidae_NHC/R/")

# Arbetskatalog för att sammanställa klimatdata för export till BUGS
setwd("C:/Users/tobjep/Jobb/Projekt/Climate_cerambycidae_NHC/data/klimat")

# Landskapsnamn som använd för att läsa in väderdatafilerna
landskap = c("Skane","Blekinge","Halland","Smaland_Kalmar","Smaland_Vaxjo","Oland",
	"Gotland","Vastergotland", "Ostergotland","Bohuslan","Dalsland","Sodermanland",
	"Narke", "Varmland","Vastmanland","Uppland", "Gastrikland","Dalarna","Halsingland",
	"Harjedalen", "Medelpad","Jamtland","Angermanland","Vasterbotten","Lappland","Norrbotten")

numlandskap=length(landskap)

#parametrar
firstyear=1900
yearvec=c(firstyear:2000)
years=length(yearvec)

# array för att spara medelklimatdata för varje år (rader), landskap (kolumn, i ordning 
# från vektorn landskap) och månad ("lager")
temperature_all = array(dim=c(years,numlandskap+1, 6)) 
precip_all = array(dim=c(years,numlandskap+1, 6)) 

# Insert years for all 'landskap'
temperature_all[,1,]=yearvec

# Import all temperature data using Tord's function
for(m in 1:length(landskap)){   
	for(n in 4:9){
		test = TEMP.PRECIP.SUMMARY(landsk = landskap[m], n)   
    temperature_all[1:years,m+1,n-3]= test$aggdat[,2]
    precip_all[1:years,m+1,n-3]= test$aggdat[,3]
	#temperature_all[,m+1,n-3]= test$aggdat[,2]
    #precip_all[,m+1,n-3]= test$aggdat[,3]

    }
}

# Import species data
#-------------------------------
species="lepmel" 
#anorub, lepmel, monsut  
rel_months=4:6

#export time period
starty=1930
stopy=2000

y1=starty-1899
y2=stopy-1899

artfil<-read.csv(paste("C:/Users/tobjep/Jobb/Projekt/Climate_cerambycidae_NHC/data/phen_",species,"_county.csv",sep=""), sep=",", header=T)
#remove data before 1900 as we have no climate data there
artfil<-artfil[!(artfil$ar < 1900),]
#change Swedish characters (not used in climate files)  
artfil$landskap<-gsub("[äå]","a",artfil$landskap)
artfil$landskap<-gsub("ö","o",artfil$landskap)
artfil$landskap<-gsub("Ö","O",artfil$landskap)
artfil$landskap<-gsub("[ÅÄ]","A",artfil$landskap)

art_landskapsvis=array(dim=c(years,numlandskap+1,11))
art_landskapsvis[,1,]=yearvec
yearsdf=data.frame(yearvec)	#dataframe of years to use for merge
names(yearsdf)[1]<-"ar"

landskap_art=unique(artfil$landskap)	#counties where species is found
landskap_art=landskap[sort(match(landskap_art,landskap))]
presencetest=c()

for(m in 1:length(landskap)){   
	temp=artfil[(artfil$landskap==landskap[m]),]
	phenlandskap=merge(temp,yearsdf,by="ar",all=TRUE)
	
	art_landskapsvis[,m+1,1]=phenlandskap$first
	art_landskapsvis[,m+1,2]=phenlandskap$median
	art_landskapsvis[,m+1,3]=phenlandskap$mean
	art_landskapsvis[,m+1,4:9]=temperature_all[,m+1,]
	#art_landskapsvis[,m+1,4:9]=temperature_all[,m,]

	
	phen_first_sum=sum(sign(phenlandskap$first[!is.na(phenlandskap$first)]))	#number of years with records
	presencetest=c(presencetest,phen_first_sum)	
	
	#calc mean temp for relevant months for lanskap[m]
	art_landskapsvis[,m+1,10]=rowMeans(temperature_all[,m+1,])	
	art_landskapsvis[,m+1,11]=phenlandskap$X_FREQ

}

select=2
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

#init stuff
datetau=array(dim=c(NoLandscapes),5)
beta0=array(dim=c(NoLandscapes),180)
beta1=array(dim=c(NoLandscapes),4)
beta2=array(dim=c(NoLandscapes),0)
mbeta1= 2
mbeta1tau=5
mbeta2=0
mbeta2tau=5

#write data
years<-dim(dates)[1]
