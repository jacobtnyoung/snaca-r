# =============================================================================== #
# Download PHX arrest data files for SNA textbook.
# =============================================================================== #

# ----
# This syntax file builds data files stored in the sna-textbook repo.
# These data files are used in the 507 and the SAND course.
# This script is run once to build the files and export them 
# to the data folder in the sna-textbook repo.

# This file downloads the arrest data and creates
# a raw file to work with.

# A file is saved to R so that file can be cleaned without
# and storing a file locally.


# ----
# clear workspace and load libraries

rm( list = ls() )

library( here ) # for calling local directory


# ----
# Download the data from the portal

url <- paste(
  "https://www.phoenixopendata.com/dataset/6f58a024-6fc2-4405-9306-15f2021c3c06/resource/",
  "1eaee7f1-ccd0-4057-af55-e5749a934258/download/arrests_adult-arrests-details_arrestdetail.csv",
  sep = ""
  )

dat <- read.csv(
  url, 
  as.is = TRUE,
  header = TRUE
)


# ----
# Save the file

saveRDS(
  dat, 
  file = here( "data/build-syntax/build-raw-data/arrest-raw.rds" ) )

# readRDS( file = here( "data/build-syntax/build-raw-data/arrest-raw.rds" ) )


# =============================================================================== #
# END FILE.
# =============================================================================== #