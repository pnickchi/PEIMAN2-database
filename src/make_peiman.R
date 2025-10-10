make_peiman = function(x){

  message( 'Starting to make the draft of PEIMAN DB ...' )

  start.time <- Sys.time()
  
  temp_peiman  <- lapply(X = x, FUN = get_elements_from_protein_list )
  peiman_temp_db <- data.frame( matrix(unlist(temp_peiman), nrow=length(temp_peiman), byrow=T), stringsAsFactors=FALSE)
  colnames(peiman_temp_db) <- c('AC', 'OS', 'KW', 'FT')
  peiman_temp_db$OS <- str_replace(string = peiman_temp_db$OS, pattern = '\\.', replacement = '')
  
  end.time   <- Sys.time()
  
  message( 'Successfully made draft of PEIMAN DB in ' , end.time - start.time)

  return(peiman_temp_db)
  
}