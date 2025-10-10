# Create the log file
sink( paste0('log/log_runtime_at_', Sys.Date(), '.txt'), append = TRUE ) 

# Prints out the run time log
cat( paste0('--------- Run at ', Sys.Date(), ' ---------') )


# 
# Load packages
#
library(tidyverse)
library(dplyr)
library(lubridate)
library(stringr)
library(crayon)
library(Rcpp)
library(parallel)


#
# Source functions from src into R env
#
source_files <- list.files(path = 'src/', pattern = "\\.R$")
source_files <- paste0('src/', source_files)
tmp <- lapply(X = source_files, FUN = source)

# Defined tmp to avoid console printing. Remove it as not needed anymore.
rm(tmp)


# 
# Call update_db() function to update PEIMAN
#
peiman_database  <- update_db()
uniprot_ptm_list <- get_PTM_keywords_table_from_uniprot()



#
# Save files 
#
cat('\n')
cat( green('Saving database in DBLog/ folder ... \n') )
saveRDS( object = peiman_database,  file = paste0('DBLog/peiman_database_',  Sys.Date(), '.rds'), compress = 'xz')
saveRDS( object = uniprot_ptm_list, file = paste0('DBLog/uniprot_ptm_list_', Sys.Date(), '.rds'), compress = 'xz')
cat('\n')


#
# Clean after code!
#
cat('\n')
fname <- paste0('tmp/uniprot_sprot_', Sys.Date(), '.dat.gz')
if( file.exists(fname) ){
  file.remove(fname)
  cat( green('Succesfully deleted ', fname) )
}


cat('\n')
fname <- paste0('tmp/uniprot_sprot_', Sys.Date(), '.dat')
if( file.exists(fname) ){
  file.remove(fname)
  cat( green('Succesfully deleted ', fname) )
}


cat('\n')
fname <- paste0('tmp/RED_uniprot_sprot_', Sys.Date(), '.dat')
if( file.exists(fname) ){
  file.remove(fname)
  cat( green('Succesfully deleted ', fname), '\n' )
}
cat('\n')


cat( paste0('--------- End of run at ', Sys.Date(), ' ---------') )
