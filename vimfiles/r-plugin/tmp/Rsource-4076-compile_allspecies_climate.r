# Skript för att plocka samman data för klimat för olika landskap och sätta 
# samman dem med artdata.
#
# Modifierad från Tords orginalfil "Sammanställ bagg- och förklaringsdata (BASFIL)3"
rm(list=ls())

library(maptools) # loads sp library too
library(maps)
library(BRugs)
library(R2OpenBUGS)

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
spfile<- "phen_all_ngt100_county" 
# "phen_all_ngt20_county"

rel_months=2:4 # 1=april, 6=sept

#export time period
starty=1930
stopy=2000

y1=starty-1899
y2=stopy-1899
years2<- y2-y1+1

artfil<-read.csv(paste("C:/Users/tobjep/Jobb/Projekt/Climate_cerambycidae_NHC/data/",spfile,".csv",sep=""), sep=",", header=T)
#remove data before 1900 as we have no climate data there
artfil<-artfil[!(artfil$ar < 1900),]

#check number of species in file
spnames<- unique(artfil$art)
nspecies<- length(spnames)

#change Swedish characters (not used in climate files)  
artfil$landskap<-gsub("[äå]","a",artfil$landskap)
artfil$landskap<-gsub("ö","o",artfil$landskap)
artfil$landskap<-gsub("Ö","O",artfil$landskap)
artfil$landskap<-gsub("[ÅÄ]","A",artfil$landskap)

# Create arrays for storage
datesf<- array(dim=c(years,numlandskap,nspecies))
datesm<- array(dim=c(years,numlandskap,nspecies))
effort_all<- array(dim=c(years,numlandskap,nspecies))
temperature_pr<- array(dim=c(years,numlandskap+1))
temperature_pa<- array(dim=c(years,numlandskap+1))
temperature_fix<- array(dim=c(years,numlandskap+1))
species.ids<- c()
#species.names<- c()

#datesf[,1,]=yearvec
#datesm[,1,]=yearvec
#effort_all[,1,]=yearvec
temperature_pr[,1]=yearvec
temperature_pa[,1]=yearvec
temperature_fix[,1]=yearvec

yearsdf=data.frame(yearvec)	#dataframe of years to use for merge
names(yearsdf)[1]<-"ar"

splandskap<- array(dim=c(nspecies))
#landskap_art=unique(artfil$landskap)	#counties where species is found
#landskap_art=landskap[sort(match(landskap_art,landskap))]

#number of records in county for it to be included
select=3

for(aa in 1:nspecies){
	
	sptemp<-artfil[artfil$art==spnames[aa],]
	presencetest=c()
	species.ids<- c(species.ids, sptemp$artid[1])
	#species.names<- c(species.names, as.character(sptemp$art[1]))

	for(m in 1:length(landskap)){   
		ltemp=sptemp[(sptemp$landskap==landskap[m]),]
		phenlandskap=merge(ltemp,yearsdf,by="ar",all=TRUE)
		
		datesf[,m,aa]<-phenlandskap$first
		datesm[,m,aa]<-phenlandskap$median
		effort_all[,m,aa]<-phenlandskap$n		

		phen_first_sum=sum(sign(phenlandskap$first[!is.na(phenlandskap$first)]))		#number of years with records
		# make entire county NA if the number of records < select
		if(phen_first_sum < select){
			datesf[,m,aa]<-NA
			datesm[,m,aa]<-NA
			effort_all[,m,aa]<-NA	
		}	

		presencetest=c(presencetest,phen_first_sum)	
		
	}
	splandskap[aa]<-sum(sign(presencetest[presencetest>0]))
}	

