# =============================================================================== #
# Build MAFIA data files for SNA textbook.
# =============================================================================== #


# ----
# This syntax file builds data files stored in the sna-textbook repo.
# These data files are used in the 507 and the SAND course.
# This script is run once to build the files and export them 
# to the data folder in the sna-textbook repo.

# Cocaine Dealing Natarajan
# This dataset comes from a stufy of a Mafia organization that operated in 
# Sicily during the first decade of 2000s. 
# There are two different networks, capturing phone calls and physical meetings

# References:  Disrupting resilient criminal networks through data analysis: The case of Sicilian Mafia
# Cavallaro L, Ficara A, De Meo P, Fiumara G, Catanese S, et al. (2020) Disrupting 
# resilient criminal networks through data analysis: The case of Sicilian Mafia. 
# PLOS ONE 15(8): e0236476. https://doi.org/10.1371/journal.pone.0236476

# data retrieved from: 
# https://github.com/lcucav/criminal-nets/blob/master/dataset/Montagna_phonecalls_edgelist.csv
# https://github.com/lcucav/criminal-nets/blob/master/dataset/Montagna_meetings_edgelist.csv


# ----
# Setup.

rm( list=ls() )

library( network ) # for working with the network object


# ----
# Build the function to create the networks

build.net <- function( fileLoc ){
  
  # load the file
  edges <- as.matrix(
    read.csv( 
      fileLoc,
      as.is = TRUE
    )
  )
  
  # sort the edges
  edges <- edges[ order( edges[,1] ), ]
  
  # coerce to characters
  edges[,1] <- as.character( edges[,1] )
  
  # create the network object from the edgelist
  netCreated <- network(
    edges[,c( 1,2 )],
    matrix.type = "edgelist",
    directed = FALSE
  )
  
  # return the object
  return( netCreated )
  
}


# ----
# Create the meetings data file

# location
meetingFile <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/build-syntax/build-raw-data/MAFIA-MEETINGS.csv" 

# run the function
MafiaMeetNet <- build.net( meetingFile )

# set the path
path <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/"

# save the file
saveRDS( MafiaMeetNet, paste( path, "data-mafia-meetings-net", ".rds", sep = "" ) )  


# ----
# Create the phonecalls data file

# location
callFile <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/build-syntax/build-raw-data/MAFIA-PHONECALLS.csv" 

# run the function
MafiaCallNet <- build.net( callFile )

# set the path
path <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/"

# save the file
saveRDS( MafiaCallNet, paste( path, "data-mafia-calls-net", ".rds", sep = "" ) )  


# =============================================================================== #
# END FILE.
# =============================================================================== #