
pr_h <- profile(ordered.hosts)
plot(pr_h)
pairs(pr)
1-pchisq(deviance(ordered.hosts),df.residual(ordered.hosts))

exp(ordered.hosts$coefficients)

#Creating effect display
predictors_hosts <- data.frame(expand.grid(list(loghosts=-2:3 
    )))

p.fit_hosts <- predict(ordered.hosts, predictors_hosts, type='probs')

plot(c(-2,3), c(0,1), 
    type='n', xlab="log(hosts)", ylab='Fitted Probability',
    main="Larvae")
lines(predictors_hosts$loghosts, p.fit_hosts[, '0'], lty=1, lwd=3)
lines(predictors_hosts$loghosts, p.fit_hosts[, '1'], lty=2, lwd=3)
lines(predictors_hosts$loghosts, p.fit_hosts[, '2'], lty=3, lwd=3)
lines(predictors_hosts$loghosts, p.fit_hosts[, '3'], lty=4, lwd=3)
lines(predictors_hosts$loghosts, p.fit_hosts[, '4'], lty=5, lwd=3)
lines(predictors_hosts$loghosts, p.fit_hosts[, '5'], lty=6, lwd=3)

legend(locator(1), lty=1:6, lwd=3, 
    legend=c('LC', 'NT', 'VU', 'EN', 'CR', 'RE'))  

