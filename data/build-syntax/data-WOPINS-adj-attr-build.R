# =============================================================================== #
# Build WOPINS data files for SNA textbook.
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

# Site 1.
setwd( "/Users/jyoung20/PINS/WOPINS_data/WOPINS_S1_data" )
load( "WOPINS_S1_TRUST_NETWORKS_FOR_ERGMS.RData" )

# Site 2.
setwd( "/Users/jyoung20/PINS/WOPINS_data/WOPINS_S2_data" )
load( "WOPINS_S2_TRUST_NETWORKS_FOR_ERGMS.RData" )


# ----
# create function to build adjacency matrix and write it to .csv

write.adjacency <- function( input.net, file.name ){
  net.out <- network::as.sociomatrix( input.net )
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

# trust networks
write.adjacency( SDD.net     , "data-WOPINS-trust-s1gb-adj" )
write.adjacency( SDD.gb.net  , "data-WOPINS-trust-s2gb-adj" )
write.adjacency( SDD.gp.net  , "data-WOPINS-trust-s2gp-adj" )


# ----
# create the files with the attributes

path <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/"

write.attributes( SDD.net   , c( "Age", "Race" ), "data-WOPINS-s1gb-age-race-attributes" )
write.attributes( SDD.gb.net, c( "Age", "Race" ), "data-WOPINS-s2gb-age-race-attributes" )
write.attributes( SDD.gp.net, c( "Age", "Race" ), "data-WOPINS-s2gp-age-race-attributes" )

write.attributes( SDD.net   , c( "White", "YearsOnUnit" ), "data-WOPINS-s1gb-white-you-attributes" )
write.attributes( SDD.gb.net, c( "White", "YearsOnUnit" ), "data-WOPINS-s2gb-white-you-attributes" )
write.attributes( SDD.gp.net, c( "White", "YearsOnUnit" ), "data-WOPINS-s2gp-white-you-attributes" )


# ----
# create the network objects as .rds files with the attributes


# create a function to run over each of the networks

build.network <- function( networkName, filePath, netFileName, attrPathName ){
  
  # define the network
  networkName <- as.network( 
    as.matrix( 
      read.csv( 
        paste( filePath, netFileName, sep = "" ),
        as.is = TRUE,
        header = TRUE,
        row.names = 1 
      ) 
    ),
    directed = TRUE 
  )
  
  # read the attributes in
  attrDat <- read.csv( 
    paste( filePath, attrPathName, sep = "" ),
    as.is = TRUE,
    header = TRUE
  )
  
  # create the names for the loop
  namesLoop <- names( attrDat )
  
  # loop through and add the attributes
  for( i in 1: length( namesLoop ) ){
    networkName %v% namesLoop[i] <- as.numeric( attrDat[, i ] ) 
  }

return( networkName )  
  
}

trustNetS1 <- build.network(
  networkName = trustNetS1,
  filePath = "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/",
  netFileName = "data-WOPINS-trust-s1gb-adj.csv",
  attrPathName = "data-WOPINS-s1gb-white-you-attributes.csv"
)

trustNetS2gb <- build.network(
  networkName = trustNetS2gb,
  filePath = "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/",
  netFileName = "data-WOPINS-trust-s2gb-adj.csv",
  attrPathName = "data-WOPINS-s2gb-white-you-attributes.csv"
)

trustNetS2gp <- build.network(
  networkName = trustNetS2gp,
  filePath = "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/",
  netFileName = "data-WOPINS-trust-s2gp-adj.csv",
  attrPathName = "data-WOPINS-s2gp-white-you-attributes.csv"
)


# ----
# save the object as an .rds file

path <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/"

saveRDS( trustNetS1,   file = paste( path, "data-WOPINS-s1-trust-net",   ".rds", sep = "" ) )
saveRDS( trustNetS2gb, file = paste( path, "data-WOPINS-s2gb-trust-net", ".rds", sep = "" ) )
saveRDS( trustNetS2gp, file = paste( path, "data-WOPINS-s2gp-trust-net", ".rds", sep = "" ) )


# =============================================================================== #
# END FILE.
# =============================================================================== #