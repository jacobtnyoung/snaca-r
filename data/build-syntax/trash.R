


  dat.edgelist.year <- dat.edgelist %>% 
    select( YEAR, actor, event ) %>%                                  # keep the year, person, and incident id for the edgelist
    arrange( YEAR ) %>%                                                         # arrange by year
    filter( YEAR == 2023 ) %>%                                                  # keep based on year
    select( actor, event ) %>%                                        # keep the incident and person id for the edgelist
    arrange( actor, event )                                           # arrange by incident then person id
  
  
  # clean up duplicates from the edges
  table( duplicated( dat.edgelist.year ) )                                      # check duplicate entries
    dat.edgelist.year <- dat.edgelist.year[ !duplicated( dat.edgelist.year ), ] # remove the duplicate entries
  
  
  # take a random sample of edges
  #set.seed ( 507 )
  #dat.edgelist.year <- sample_n( dat.edgelist.year, 5000 )                      # sample 1,000 rows
  
  
  mat.edgelist.year <- cbind(                                                   # build the edgelist
    as.character( dat.edgelist.year$actor ),
    as.character( dat.edgelist.year$event )
  )
  
  
  netYear <- as.network(                             # create the network
    mat.edgelist.year, 
    bipartite=length( unique( mat.edgelist.year[,1] ) ), 
    matrix.type="edgelist"
  )
  
  # create the projection
  oneMode <- as.matrix( netYear ) %*% t( as.matrix( netYear ) )
  
  # find the component membership
  cd <- component.dist( as.matrix( oneMode ) )
  
  # find largest size
  max( cd$csize )
  
  # find which component is the largest
  sort( table( cd$membership ), decreasing = TRUE )[1]
  
  # assign membership as a attribute
  as.numeric( names( sort( table( cd$membership ), decreasing = TRUE )[1] ) )
  
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
  
  gplot(netYearReduced,gmode = "twomode", usearrows = FALSE)
  
  return( netYearReduced )                                 # function returns an object of class network
  
}
  