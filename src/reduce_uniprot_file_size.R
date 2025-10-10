reduce_uniprot_file_size = function(ifile = paste0('tmp/uniprot_sprot_', Sys.Date(), '.dat') , ofile = paste0('tmp/RED_uniprot_sprot_', Sys.Date(), '.dat')) {
  
  # Check input file exists
  if ( !file.exists(ifile) ){
    stop('Input file: ', ifile, ' does not exist in tmp/ folder.')
  }   

  cat('\n')
  cat( green('Processing/Reading the file: ', ifile, ' to reduce file size ...') )
  cat('\n')

  sourceCpp(file = 'src/reduce_uniprot_rcpp.cpp')
  
  reduce_uniprot_rcpp(ifile, ofile)
  
  cat('\n')
  cat( green('Finished reducing the size of file: ', ifile) )
  cat('\n')

  cat('\n')
  cat( green('The output file with reduced size is generated in: ', ofile) )
  cat('\n')

}

