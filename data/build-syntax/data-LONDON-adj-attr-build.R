# =============================================================================== #
# Build LONDON data files for SNA textbook.
# =============================================================================== #


# ----
# This syntax file builds data files stored in the sna-textbook repo.
# These data files are used in the 507 and the SAND course.
# This script is run once to build the files and export them 
# to the data folder in the sna-textbook repo.

# Data is on co-offending in a London-based inner-city street gang, 2005-2009, 
# operating from a social housing estate. Data comes from anonymised police arrest 
# and conviction data for "all confirmed" members of the gang. 
# 1-Mode matrix 54 x 54 persons by persons, undirected, valued. 
# Network tie values:1 (hang out together); 2 (co-offend together); 
# 3 (co-offend together, serious crime); 4 (co-offend together, serious crime, kin).
# Attributes: Age, Birthplace (1 = West Africa, 2= Caribbean, 3= UK, 4= East Africa), 
# Residence, Arrests, Convictions, Prison, Music.

# Reference: How to Cite: Grund, T. and Densley, J. (2015) Ethnic Homophily and 
# Triad Closure: Mapping Internal Gang Structure Using Exponential Random Graph Models. 
# Journal of Contemporary Criminal Justice, Vol. 31, Issue 3, pp. 354-370

# data retrieved from: http://www.casos.cs.cmu.edu/tools/datasets/external/index.php

# ----
# Setup.

rm( list=ls() )

library( network ) # for working with the network object


# ----
# Load the data.

matFile <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/build-syntax/build-raw-data/LONDON_GANG.csv" 

mat <- as.matrix(
  read.csv( 
    matFile,
    as.is = TRUE,
    header = TRUE,
    row.names = 1
    )
  )

# recode the matrix to be binary
matBin <- mat
matBin[ mat > 1 ] <- 1

# create the network object
LondonGangNet <- as.network( 
  matBin, 
  directed = FALSE
  )


# ----
# attach the attributes

attrFile <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/build-syntax/build-raw-data/LONDON_GANG_ATTR.csv" 

attrDat <- read.csv( 
    attrFile,
    as.is = TRUE,
    header = TRUE,
    row.names = 1
  )


# create the names for the loop
namesLoop <- names( attrDat )

# loop through and add the attributes
for( i in 1: length( namesLoop ) ){
  LondonGangNet %v% namesLoop[i] <- as.numeric( attrDat[, i ] ) 
}


# ----
# clean workspace

rm( list = ls()[! ls() %in% c( 
  "LondonGangNet" 
)])


# ----
# save the object as an .rds file

path <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/"

saveRDS( LondonGangNet, file = paste( path, "data-london-gang-net", ".rds", sep = "" ) )


# =============================================================================== #
# END FILE.
# =============================================================================== #