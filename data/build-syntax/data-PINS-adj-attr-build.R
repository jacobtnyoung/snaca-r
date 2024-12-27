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


# ----
# Load the data.
setwd( "/Users/jyoung20/PINS/PINS_Wave_1_data/" )
load( "PINS_Wave_1_NETWORKS_FOR_ANALYSIS.RData" )


# ----
# create function to build adjacency matrix and write it to .csv

write.adjacency <- function( input.net, file.name ){
  net.out <- as.sociomatrix( input.net )
  write.csv( net.out, paste( path, file.name, ".csv", sep = "" ) )
}


# ----
# create a function to write the attributes to a .csv

write.attributes <- function( input.net, nodeAttributes, file.name ){
  attrList <- list()
  for( i in 1: length( nodeAttributes ) ){
    attrList[[i]] <- list( input.net %v% nodeAttributes[i] )  
  }
  for( i in 1: length( nodeAttributes ) ){
    names( attrList[[i]] ) <- nodeAttributes[[i]]
  }
  dat.out <- as.data.frame( attrList )
  write.csv( dat.out, paste( path, file.name, ".csv", sep = ""), row.names = FALSE )
}


# ----
# create the adjacency matrices

path <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/"

write.adjacency( get.along.norank.net, "data-PINS-getalong-w1-adj" )
write.adjacency( powerinfluence.net  , "data-PINS-power-w1-adj" )
write.adjacency( information.net     , "data-PINS-info-w1-adj" )


# ----
# create the files with the attributes

path <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/"

write.attributes( get.along.norank.net, c( "Age", "Race" ), "data-PINS-w1-age-race-attributes" )



# =============================================================================== #
# END FILE.
# =============================================================================== #