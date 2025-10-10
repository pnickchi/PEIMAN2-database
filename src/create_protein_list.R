create_protein_list = function( fname = paste0('tmp/RED_uniprot_sprot_', Sys.Date(), '.dat') ){

  # 
  # Read the reduced sized file
  #
  cat('\n')
  cat( green('Reading/Processing file: ', fname) )
  cat('\n')
  raw_lines <- readLines(fname)
  
  #
  # Identifying the lines that belongs to each protein.
  # In the reduced file, each protein is separated by _//_
  # So we need to spot the positions where _//_ occurs 
  # and read the lines in between for each protein.
  #
  indx <- which( raw_lines == '_//_' )
  indx <- c(1,indx)

  
  #
  # Each protein data will be saved in protein_List 
  #
  cat('\n')
  cat( green('Reading proteins ...') )
  cat('\n')
  
  n <- length(indx)
  protein_List <- list()
  for( i in 1:(n-1) ){
    protein_List[[i]] <- raw_lines[ indx[i]:indx[i+1] ]
  }
  
  cat('\n')
  cat( green('Finished reading proteins from: ', fname) )
  cat('\n')

  return(protein_List)

}

