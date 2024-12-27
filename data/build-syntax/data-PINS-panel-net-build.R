# =============================================================================== #
# Build PINS data files for SNA textbook.
# =============================================================================== #


# ----
# This syntax file builds data files stored in the sna-textbook repo.
# These data files are used in the 507 and the SAND course.
# This script is run once to build the files and export them 
# to the data folder in the sna-textbook repo.


# ----
# Setup.

rm( list=ls() )

library( network ) # for working with the network object
library( sna )     # for the subgraph induction for W2

# ----
# Load the data.
setwd( "/Users/jyoung20/PINS/PINS_Wave_1_data/" )
load( "PINS_Wave_1_NETWORKS_FOR_ANALYSIS.RData" )

setwd( "/Users/jyoung20/PINS/PINS_Wave_2_data/" )
load( "PINS_Wave_2_NETWORKS_FOR_ANALYSIS.RData" )


# ----
# create a function to create the network object you want for the panel data

write.network <- function( input.net ){
  
  # create the subgraph
  net.sub <- get.inducedSubgraph( input.net, 
    v = which( input.net %v% "in.survey.w1" == TRUE 
               & input.net %v% "in.survey.w2" == TRUE ) )
  
  # create the matrix
  mat.out <- as.sociomatrix( net.sub )
  
  # create the network
  net.out <- as.network( mat.out, matrix.type = "adjacency",  directed = TRUE )
  
  # pull off the attributes
  race     <- net.sub %v% "race"
  socdist1 <- net.sub %v% "social.distance.w1"
  socdist2 <- net.sub %v% "social.distance.w2"
  dep1     <- net.sub %v% "depression.w1"
  dep2     <- net.sub %v% "depression.w2"
  smoke1   <- net.sub %v% "smoker.w1"
  smoke2   <- net.sub %v% "smoker.w2"
  
  # assign the attributes
  net.out %v% "race" <- race
  net.out %v% "socdist.w1"    <- socdist1
  net.out %v% "socdist.w2"    <- socdist2
  net.out %v% "depression.w1" <- dep1
  net.out %v% "depression.w2" <- dep2
  net.out %v% "smoker.w1"     <- smoke1
  net.out %v% "smoker.w2"     <- smoke2
  
  # output the rebuilt network
  return( net.out )
}

# ----
# create the objects

getAlongW1Net <- write.network( get.along.norank.net.w1 )
getAlongW2Net <- write.network( get.along.norank.net.w2 )


# ----
# save the object as an .rds file

path <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/"

saveRDS( getAlongW1Net, file = paste( path, "data-pins-ga-panel-w1-net", ".rds", sep = "" ) )
saveRDS( getAlongW2Net, file = paste( path, "data-pins-ga-panel-w2-net", ".rds", sep = "" ) )


# =============================================================================== #
# END FILE.
# =============================================================================== #