make_peiman_parallel = function(x){

  num_cores <- detectCores()
  
  cat('\n')
  cat( green(num_cores, ' cores found in your system ...') )
  cat('\n')
  
  cat('\n')
  cat( green('Starting to make the draft of PEIMAN DB in parallel with ', num_cores - 1, ' cores ...') )
  cat('\n')
  
  start.time <- Sys.time()
  temp_peiman <- mclapply(X = x, FUN = get_elements_from_protein_list, mc.cores = num_cores - 1)
  peiman_temp_db <- data.frame(matrix(unlist(temp_peiman), nrow = length(temp_peiman), byrow = TRUE), stringsAsFactors = FALSE)
  colnames(peiman_temp_db) <- c("AC", "OS", "KW", "FT")
  end.time   <- Sys.time()
  
  run.time <- end.time - start.time

  cat('\n')
  cat( green('Run time: ', run.time) )
  cat('\n')

  cat('\n')
  cat( green('Successfully made draft of PEIMAN DB in ' , end.time - start.time) )
  cat('\n')

  peiman_temp_db$OS <- str_replace(string = peiman_temp_db$OS, pattern = '\\.', replacement = '')

  return(peiman_temp_db)
  
}