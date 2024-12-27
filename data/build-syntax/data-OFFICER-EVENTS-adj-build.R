# =============================================================================== #
# Build OFFICER EVENTS data files for SNA textbook.
# =============================================================================== #


# ----
# This syntax file builds data files stored in the sna-textbook repo.
# These data files are used in the 507 and the SAND course.
# This script is run once to build the files and export them 
# to the data folder in the sna-textbook repo.

# Officer Events
# This dataset comes from a study of police officers

# Reference: Young, J. T. N., & Ready, J. T. (2015). Diffusion of Ideas and Technology: 
# The Role of Networks in Influencing the Endorsement and Use of On-Officer Video Cameras. 
# Journal of Contemporary Criminal Justice, 31(3), 243-261. https://doi.org/10.1177/1043986214553380


# ----
# Setup.

rm( list=ls() )

library( network ) # for working with the network object


# ----
# load the data

edgeFile <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/build-syntax/build-raw-data/OFFICER-EVENTS.csv" 

edgelist <- as.matrix(
  read.csv(
    edgeFile, 
    as.is=TRUE, 
    header=TRUE 
    )
  )

# create the empty adjacency matrix
mat <- matrix( 
  0, 
  length( unique( edgelist[,1] ) ), 
  length( unique( edgelist[,2] ) ) 
  )

# name the rows and columns
rownames( mat ) <- unique( edgelist[,1] )
colnames( mat ) <- unique( edgelist[,2] )

# fill edgelist indexed edges with a 1
mat[edgelist] <- 1   

# define number of officers
N <- length( unique( edgelist[,1] ) )

# create the network object
OfficerEventsNet <- as.network( 
  mat,
  bipartite = N
)


# ----
# create function to build adjacency matrix and write it to .csv

write.adjacency <- function( input.net, file.name ){
  net.out <- network::as.sociomatrix( input.net )
  write.csv( net.out, paste( path, file.name, ".csv", sep = "" ) )
}


# ----
# save the object as a .csv file

path <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/"

write.adjacency( OfficerEventsNet, "data-officer-events-adj" )


# =============================================================================== #
# END FILE.
# =============================================================================== #