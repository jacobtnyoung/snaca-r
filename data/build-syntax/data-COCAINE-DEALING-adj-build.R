# =============================================================================== #
# Build COCAIN DEALING data files for SNA textbook.
# =============================================================================== #


# ----
# This syntax file builds data files stored in the sna-textbook repo.
# These data files are used in the 507 and the SAND course.
# This script is run once to build the files and export them 
# to the data folder in the sna-textbook repo.

# Cocaine Dealing Natarajan
# This dataset comes from an investigation into to a large cocaine trafficking 
# organization in New York City. DATA: 1-mode matrix 28 x 28 persons by persons. 
# Directed binary relations are communications exchanges / flows of information. 
# Data come from police wiretappings (transcripts of 151 telephone conversations).

# References: Natarajan, M. (2006). Understanding the Structure of a Large Heroin 
# Distribution Network: A Quantitative Analysis of Qualitative Data. Quantitative Journal of Criminology, 22(2), 171-192.

# data retrieved from: http://www.casos.cs.cmu.edu/tools/datasets/external/index.php

# ----
# Setup.

rm( list=ls() )

library( network ) # for working with the network object


# ----
# load the data

matFile <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/build-syntax/build-raw-data/COCAINE_DEALING.csv" 

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
CocaineDealingNet <- as.network( 
  matBin, 
  directed = TRUE
  )


# ----
# save the object as an .rds file

path <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/"

saveRDS( CocaineDealingNet, paste( path, "data-cocaine-dealing-net", ".rds", sep = "" ) )  


# =============================================================================== #
# END FILE.
# =============================================================================== #