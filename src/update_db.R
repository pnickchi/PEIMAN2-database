update_db = function(){
  
  # Compare the latest local version with online repo to see if we need to update

  # Download from UniProt
  download_uniprot()

  # Extract the gz file
  extract_gz_file()
  
  # Reduce the size of file by selecting 4 needed features
  reduce_uniprot_file_size()

  # Create Protein List
  protein_List <- create_protein_list()

  # Make PEIMAN
  #peiman_temp_db <- make_peiman(x = protein_List)
  peiman_temp_db <- make_peiman_parallel(x = protein_List)

  # Download PTM keywords table from UniProt
  cat('\n')
  cat( green('Get PTM keywords table from uniprot ...') )
  cat('\n')
  uniprot_ptm_list <- get_PTM_keywords_table_from_uniprot()

  # Get indices of proteins with PTM
  tmp <- find_proteins_with_PTM(tmp_db = peiman_temp_db)
  indx_proteins_with_ptm <- tmp[[1]]
  KW_Search_List <- tmp[[2]]

  rm(tmp)

  NO_PTM_DB      <- peiman_temp_db[!indx_proteins_with_ptm, ]
  peiman_temp_db <- peiman_temp_db[indx_proteins_with_ptm,  ]

  # Build the final database
  cat('\n')
  cat( green('Building the final database ...') )
  cat('\n')
  
  peiman_database <- make_final_peiman_db(tmp_db = peiman_temp_db,
                                          tmp_db_no_ptm = NO_PTM_DB,
                                          search_list_kw = KW_Search_List,
                                          ptm_list = uniprot_ptm_list)

  cat('\n')
  cat( green('Finished building the final database!') )
  cat( '\n ')

  return(peiman_database)

}

