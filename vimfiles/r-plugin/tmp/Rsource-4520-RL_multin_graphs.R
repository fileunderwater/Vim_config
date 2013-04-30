analysis<-read.csv("C:/Users/tobjep/Jobb/Projekt/comparative study on cerambycidae/svn/R/compdata_a5_stand.csv")
analysis_t<-analysis[!is.na(analysis$log31),]

attach(analysis)

RL_order <- ordered(RL,
    levels=c('0', '1', '2', '3', '4', '5'))

multinomial.model <- multinom(RL_order ~ 
	loglength + loghosts + LC_min + spann90 + relevel(overw,"L") +
	loglength*relevel(overw,"L") + loghosts*LC_min + loghosts*spann90 + spann90*relevel(overw,"L"))

summary(multinomial.model, cor=F, Wald=T)
summary(multinomial.model)
