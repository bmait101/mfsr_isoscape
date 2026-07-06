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
library(dplyr)
library(ggplot2)
library(lubridate)

######################################## 
# read in the data frame and set it up for analysis

d1 <- read.csv( here::here( "DataFiles", "Combined_mig_dis_data.csv" ), stringsAsFactors = F ) # read in data
head(d1)
nrow(d1)
sapply(d1, unique)
sapply(d1, class)

######################################## 
# prep the data for JAGS

# Set up and Bundle data
jags.data <- list( n.indv = length(d1$mig.bool), n.HybridClasses=length(unique(d1$HybridClasses2)),  mig.bool = d1$mig.bool2, stray.bool = d1$stray.bool, HybridClass = d1$HC2.int )


# parameters to save
jags.params <- c('b0.mig','b0.stray','p.mig','p.stray','p.disp' )


# Initial values prob scale
inits <- function(){
  list( b0.mig = runif(2,-3,3),
        b0.stray = runif(2,-3,3)
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

jags.model.cat <- jagsUI::jags( jags.data, 
                                  inits, 
                                  jags.params, 
                                  "MigrationDispersal_categorical.txt", 
                                  n.chains = nc,
                                  n.adapt = na,
                                  n.thin = nt, 
                                  n.iter = ni, 
                                  n.burnin = nb,
                                  parallel = TRUE
)

# check out results
jags.model.cat
plot(jags.model.cat)

# save output
saveRDS(jags.model.cat, "cat2_jags.model.rds")


######################################
# Set up and Bundle data
jags.data <- list( n.indv = length(d1$mig.bool), n.HybridClasses=length(unique(d1$HybridClasses3)),  mig.bool = d1$mig.bool2, stray.bool = d1$stray.bool, HybridClass = d1$HC3.int )


# parameters to save
jags.params <- c('b0.mig','b0.stray','p.mig','p.stray','p.disp' )


# Initial values prob scale
inits <- function(){
  list( b0.mig = runif(2,-3,3),
        b0.stray = runif(2,-3,3)
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

jags.model.cat <- jagsUI::jags( jags.data, 
                                inits, 
                                jags.params, 
                                "MigrationDispersal_categorical.txt", 
                                n.chains = nc,
                                n.adapt = na,
                                n.thin = nt, 
                                n.iter = ni, 
                                n.burnin = nb,
                                parallel = TRUE
)

# check out results
jags.model.cat
plot(jags.model.cat)

# save output
saveRDS(jags.model.cat, "cat3_jags.model.rds")