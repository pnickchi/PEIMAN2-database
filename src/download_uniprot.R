download_uniprot = function(fname = paste0('tmp/uniprot_sprot_', Sys.Date(), '.dat.gz')) {
  
  # Set the URL to download Reviewed (Swiss-Prot)
  url <- 'https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.dat.gz'
  
  if( file.exists(fname) ){
    
    cat( '\n' )
    cat( green('The file already exists - skip to next step. \n') )
    cat( '\n' )
    
  }else{
    
    # Overwrite Rstudio 60 seconds download timeout
    options( timeout = max(600, getOption("timeout")) )
    
    # Download file
    download.file(url = url, destfile = fname, mode = "wb", method = "libcurl")

    cat( '\n' )
    cat( green('Download is completed: ', fname) )
    cat( '\n' )

  }
  
}
