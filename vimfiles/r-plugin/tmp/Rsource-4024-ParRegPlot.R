
#final model - trend
# use method="g" for partial serach with genetic algorith (faster for larger model sets)
multimodel_rl<-glmulti(y="RL_new", xr= c("LC_min", "spann90", "spann", "overw", "loghosts", "loglength"),
										data=analysis_t, level=2, method="g", crit="aicc",
										fitfunction="vglm.glmulti",
										family="cumulative(parallel=TRUE)")	# , intercept=FALSE
summary(multimodel_rl)

