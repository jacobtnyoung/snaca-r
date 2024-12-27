# =============================================================================== #
# Download PHX arrest data files for SNA textbook.
# =============================================================================== #

# ----
# This syntax file builds data files stored in the sna-textbook repo.
# These data files are used in the 507 and the SAND course.
# This script is run once to build the files and export them 
# to the data folder in the sna-textbook repo.

# This file takes the downloaded file and cleans the data.

# ----
# Clear workspace and load needed libraries

rm( list = ls() )

library( here )    # for accessing local directory
library( dplyr )   # for working with the data
library( network ) # for building the networks
library( sna )     # for working with the network data

# ----
# load data file

dat <- readRDS( file = here( "data/build-syntax/build-raw-data/arrest-raw.rds" ) )


# ----
# clean data and restructure for creating networks

dat.edgelist <- dat %>% 
  select( YEAR, UNIQUE_NAME_ID, ARST_OFFICER, HUNDREDBLOCKADDR ) %>%  # keep the variables you need
  group_by( HUNDREDBLOCKADDR, ARST_OFFICER ) %>%                      # group by address then officer id
  filter( n() > 1 ) %>%                                               # only keep cases that involve more than 1 person arrested
  arrange( ARST_OFFICER ) %>%                                         # arrange by arresting officer
  mutate( incident_id = cur_group_id() ) %>%                          # create unique id for event
  ungroup() %>%                                                       # un-group the data
  group_by( UNIQUE_NAME_ID ) %>%                                      # group by unique person id
  mutate( person_id = cur_group_id() ) %>%                            # create a unique person id that is numeric
  ungroup()

dat.edgelist <- dat.edgelist %>% 
  mutate( actor = paste0( "a.", dat.edgelist$person_id ) ) %>%                 # change to character
  mutate( event = paste0( "p.", dat.edgelist$incident_id ) )                   # change to character

# create the networks for each year ----

# check the years
table( dat.edgelist$YEAR )

# write the function
year.network <- function( edgelist, year ) {

  # take the year you want
  dat.edgelist.year <- edgelist %>% 
    select( YEAR, actor, event ) %>%                                            # keep the year, person, and incident id for the edgelist
    arrange( YEAR ) %>%                                                         # arrange by year
    filter( YEAR == year ) %>%                                                  # keep based on year
    select( actor, event ) %>%                                                  # keep the incident and person id for the edgelist
    arrange( actor, event )                                                     # arrange by incident then person id
  
  # clean up duplicates from the edges
  table( duplicated( dat.edgelist.year ) )                                      # check duplicate entries
  dat.edgelist.year <- dat.edgelist.year[ !duplicated( dat.edgelist.year ), ]   # remove the duplicate entries
  
  # build the edgelist
  mat.edgelist.year <- cbind(                                                   
    as.character( dat.edgelist.year$actor ),                                    
    as.character( dat.edgelist.year$event )                                     
  )
  
  # create the network
  netYear <- as.network(                             
    mat.edgelist.year, 
    bipartite=length( unique( mat.edgelist.year[,1] ) ), 
    matrix.type="edgelist"
  )
  
  # identify the first component and create an index
  oneMode <- as.matrix( netYear ) %*% t( as.matrix( netYear ) )                 # create the projection
  cd <- component.dist( as.matrix( oneMode ) )                                  # find the component membership
  max( cd$csize )                                                               # find largest size
  sort( table( cd$membership ), decreasing = TRUE )[1]                          # find which component is the largest
  
  # create the data object
  inComp <- data.frame( 
    ids = rownames( oneMode ), 
    mainComponent = cd$membership
  )
  
  # create the ids to match on
  ids <-inComp$ids[ inComp$mainComponent == as.numeric( names( sort( table( cd$membership ), decreasing = TRUE )[1] ) ) ]
  
  # take those edges in the main component
  mat.edgelist.year.reduced <- mat.edgelist.year[mat.edgelist.year[,1] %in% ids,]
  
  # create the new network based on the reduced edgelist
  netYearReduced <- as.network(                             
    mat.edgelist.year.reduced, 
    bipartite=length( unique( mat.edgelist.year.reduced[,1] ) ), 
    matrix.type="edgelist"
  )
  
  # plot it to see it
  gplot( netYearReduced, gmode = "twomode", usearrows = FALSE )
  
  # function returns an object of class network
  return( netYearReduced )                                 
  
}


# ----
# execute the function for each year

PhxArrestNet2022 <- year.network( edgelist = dat.edgelist, year = 2022 )
PhxArrestNet2023 <- year.network( edgelist = dat.edgelist, year = 2023 )


# ----
# save the objects as .rds files

path <- "/Users/jyoung20/Dropbox (ASU)/GitHub_repos/sna-textbook/data/"

saveRDS( PhxArrestNet2022, paste( path, "data-PHX-arrest-2022-net", ".rds", sep = "" ) )  
saveRDS( PhxArrestNet2023, paste( path, "data-PHX-arrest-2023-net", ".rds", sep = "" ) )  


# =============================================================================== #
# END FILE.
# =============================================================================== #