extract_gz_file = function(fname = paste0('tmp/uniprot_sprot_', Sys.Date(), '.dat.gz')) {
  
  chk_file <- paste0('tmp/uniprot_sprot_', Sys.Date(), '.dat')
  
  if( file.exists(chk_file) ){
    
    cat( '\n' )
    cat( green('The file ', chk_file, ' already exists. Skip to the next step ...') )
    cat( '\n' )
    
    return(0)
    
  }
  
  if( file.exists(fname) ){
    
    # Use gunzip to extract, keep original file
    system(command = paste('gunzip -k', fname))
    
    cat( '\n' )
    cat( green('Extraction is completed: ', sub("\\.gz$", "", fname)) )
    cat( '\n' )

  }else{

    cat( '\n' )
    stop( red('Cannot find the file: ', fname) )
    cat( '\n' )
    
  }
  
}
