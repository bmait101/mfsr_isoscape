rm(list=ls())
################################################################################ 
################################################################################ 
# Jeff Strait
# 2/22/22
# modeling migration and dispersal probability as a function of pRBT 
# simulate the range of admixture and use posterior distributions of betas 
# from migration and dispersal models to estimate the joint probability 

######################################## 
# load libraries
library(here)
library(dplyr)
library(ggplot2)
library(lubridate)

######################################## 
# read in the data frame and set it up for analysis

d1 <- read.csv( here('DataFiles',"Combined_mig_dis_data.csv" ), stringsAsFactors = F ) # read in data
head(d1)

######################################## 
# logit transform pRBT

logit <- function(x){
  return(log(x/(1-x)))
}

d2 <- d1 %>% filter(., !is.na(prbt) ) %>% mutate(., lprbt = car::logit(prbt)) 
head(d2)

# distribution of pRBT
ggplot(data=d2, aes(x=prbt)) + geom_histogram(col="black")

# distribution of logit transformed pRBT
ggplot(data=d2, aes(x=lprbt )) + geom_histogram(col="black")

# pRBT vs lpRBT
ggplot(data=d2, aes(x=prbt, y=lprbt )) + geom_point(col="black") + geom_abline(intercept = 0, slope = 1, linetype="dashed")


######################################## 
# prep the data for JAGS

# Set up and Bundle data
jags.data <- list( n.ind = length(d2$mig.bool), mig.bool = d2$mig.bool, stray.bool = d2$stray.bool, pRBT = d2$lprbt)

# parameters to save
jags.param <- c('p.mig','p.stray','p.disp','int.mig','int.stray','d1.mig','d1.stray')


# Initial values prob scale
inits <- function(){
  list( int.mig = runif(1,-5,5),
        int.stray = runif(1,-5,5),
        d1.mig = runif(1,-5,5),
        d1.stray = runif(1,-5,5)
      )
}



# MCMC settings
ni <- 5000
nt <- 1
nb <- 1000
nc <- 3
na = 100

######################################    
# Call JAGS from R 

jags.model <- jagsUI::jags( jags.data, 
                                  inits, 
                                  jags.param, 
                                  "MigrationDispersal_prbt.txt", 
                                  n.chains = nc,
                                  n.adapt = na,
                                  n.thin = nt, 
                                  n.iter = ni, 
                                  n.burnin = nb,
                                  parallel = TRUE
)

# check out results
jags.model
plot(jags.model)

# save output
saveRDS(jags.model, "prbt_jags.model.rds")

