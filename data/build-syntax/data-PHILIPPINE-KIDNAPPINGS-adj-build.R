# =============================================================================== #
# Build PHILIPPINE KIDNAPPINGS data files for SNA textbook.
# =============================================================================== #


# ----
# This syntax file builds data files stored in the sna-textbook repo.
# These data files are used in the 507 and the SAND course.
# This script is run once to build the files and export them 
# to the data folder in the sna-textbook repo.

# Philippine Kidnappings
# Data refers to the Abu Sayyaf Group (ASG), a violent non-state actor operating 
# in the Southern Philippines. In particular, this data is related to the Salast 
# movement that has been founded by Aburajak Janjalani, a native terrorist of the 
# Southern Philippines in 1991. ASG is active in kidnapping and other kinds of 
# terrorist attacks (Gerdes et al. 2014). The reconstructed 2-mode matrix 
# combines terrorist kidnappers and the terrorist events they have attended.

# Reference: Gerdes, Luke M., Kristine Ringler, and Barbara Autin (2014). 
# "Assessing the Abu Sayyaf Group's Strategic and Learning Capacities." 
# Studies in Conflict & Terrorism 37, no. 3: 267-293. 
# Retreived from: http://www.tandfonline.com/eprint/cCV3RJihmG3miPFECpV7/full.


# ----
# Setup.

rm( list=ls() )

library( network ) # for working with the network object


# ----
# Load the data.

matFile <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/build-syntax/build-raw-data/PHILIPPINE-KIDNAPPINGS.csv" 

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
PhilKidnapNet <- as.network( 
  mat,
  bipartite = N
)


# ----
# save the object as an .rds file

path <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/"

saveRDS( PhilKidnapNet, file = paste( path, "data-philippine-kidnappings-net", ".rds", sep = "" ) )


# =============================================================================== #
# END FILE.
# =============================================================================== #