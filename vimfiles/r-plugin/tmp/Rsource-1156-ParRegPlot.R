
library(ggplot2)

analysis<-read.csv("C:/Users/tobjep/Jobb/Projekt/comparative study on cerambycidae/svn/R/compdata_a5_stand.csv")
analysis_t<-analysis[!is.na(analysis$log31),]

#final model - trend
full<-glm(log31 ~ LC_min + spann90 + relevel(overw,"L")+ LC_min*relevel(overw,"L"),data=analysis_t)
summary(full)


# LC_min
trend_lc <- glm(log31 ~ spann90 + relevel(overw,"L"),data=analysis_t)$res
lc <- glm(LC_min ~ spann90 + relevel(overw,"L"),data=analysis_t)$res
g <-glm(LC_min ~ spann90 + relevel(overw,"L"),data=analysis_t)$data$overw
g2<-as.numeric(g)
lcframe <- data.frame(lc,trend_lc,g)
lcframe$g <- factor(lcframe$g, levels=c("A", "L"), labels=c("Adults", "Larvae"))
lcframe2 <- lcframe[order(-lcframe[,2]),]

