# =============================================================================== #
# Build PAUL REVERE data files for SNA textbook.
# =============================================================================== #


# ----
# This syntax file builds data files stored in the sna-textbook repo.
# These data files are used in the 507 and the SAND course.
# This script is run once to build the files and export them 
# to the data folder in the sna-textbook repo.

# Paul Revere Conspiracy
# The Paul Revere conspiracy dataset concerns relationships between 254 people 
# and their affiliations with seven different organizations in Boston. 
# The dataset refers to Paul Revere, who was responsible for organizing a local militia 
# of Boston's revolutionary movement (see http://en.wikipedia.org/wiki/Sons_of_Liberty). 
# The dataset was analysed by Kieran Healy of Duke University. This dataset has been 
# reconstructed by looking at the information presented in the appendix of the book 
# "Paul Revere's Ride" published by David Fischer (1994).

# Reference: Fischer, D. (1994), "Paul Revere's ride", Oxford University Press. 
# Retrieved from: http://kieranhealy.org/blog/archives/2013/06/09/using-metadata-to-find-paul-revere/. 

# data retrieved from: 
# http://www.casos.cs.cmu.edu/tools/datasets/external/paulrevere/paulrevere.zip


# ----
# Setup.

rm( list=ls() )

library( network ) # for working with the network object


# ----
# Load the data.

matFile <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/build-syntax/build-raw-data/PAUL-REVERE.csv" 

mat <- as.matrix(
  read.csv( 
    matFile,
    as.is = TRUE,
    header = TRUE,
    row.names = 1
  )
)


# ----
# Build the network.

# define number of individuals
N <- dim( mat )[1]

# create the network object
PaulRevereNet <- as.network( 
  mat,
  bipartite = N
)


# ----
# Clean up the names

# reverse the order of the names
firstNames <- sub( ".*\\.", "", network.vertex.names( PaulRevereNet )[1:N] )
lastNames  <- sub( "\\..*", "", network.vertex.names( PaulRevereNet )[1:N] )
actorNames <- paste0( firstNames, sep = " ", lastNames )

# create a set of names that is just the individuals
PaulRevereNet %v% "people.names" <- c( actorNames, rep( NA, dim( mat )[2] ) )

# create a set of places names
PaulRevereNet %v% "place.names" <- c( rep( NA, dim( mat )[1] ), network.vertex.names( PaulRevereNet )[ -c( 1:N ) ] )

# assign as an attribute
PaulRevereNet %v% "names" <- c( actorNames, network.vertex.names( PaulRevereNet )[ -c( 1:N ) ] )


# ----
# save the object as an .rds file

path <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/"

saveRDS( PaulRevereNet, file = paste( path, "data-paul-revere-net", ".rds", sep = "" ) )


# =============================================================================== #
# END FILE.
# =============================================================================== #