make_final_peiman_db = function(tmp_db, tmp_db_no_ptm, search_list_kw, ptm_list){
  
  #
  t1 <- tmp_db$AC
  t2 <- tmp_db$OS
  all_in_uniprot <- data.frame(AC = t1, OS = t2)
  #

  KW_database <- tmp_db[, c('AC','OS','KW') ]
  FT_database <- tmp_db[, c('AC','OS','FT') ]
  
  # 1. KW:
  KW_database     <- separate_rows(KW_database, KW, sep = ';')
  KW_database$KW  <- stringr::str_trim(string = KW_database$KW, side = 'both')
  KW_database$KW  <- str_replace(string = KW_database$KW, pattern = regex(pattern = '[.]'), replacement = '' )
  KW_database     <- KW_database %>% filter(KW %in% search_list_kw)
  
  # 2. FT:
  FT_database      <- separate_rows(FT_database, FT, sep = ';')
  empty_rows_in_FT <- which( FT_database$FT == '' )
  
  if( length(empty_rows_in_FT) != 0 ){
    FT_database <- FT_database[-empty_rows_in_FT,]
  }
  FT_database$FT <- stringr::str_trim(string = FT_database$FT, side = 'both')
  
  FT_Search_List <- unique(ptm_list$ID)
  FT_database    <- FT_database %>% filter( FT %in% FT_Search_List)
  
  
  AC  <- c(KW_database$AC, FT_database$AC)
  OS  <- c(KW_database$OS, FT_database$OS)
  PTM <- c(KW_database$KW, FT_database$FT)
  
  peiman_database <- data.frame(AC = as.character(AC), OS = as.character(OS), PTM = as.character(PTM) )
  rownames(peiman_database) <- seq(1:nrow(peiman_database))
  
  peiman_database <- peiman_database[ !duplicated(peiman_database), ]

  ac  <- tmp_db_no_ptm$AC
  os  <- tmp_db_no_ptm$OS
  noptm <- rep('No ptm', length(ac))
  d  <- data.frame(AC = ac, OS = os, PTM = noptm)
  d  <- d[ !duplicated(d), ]
  peiman_database <- dplyr::bind_rows(peiman_database, d)
  missing_ids  <- setdiff(all_in_uniprot$AC,peiman_database$AC)
  missing_data <- all_in_uniprot %>% filter(AC %in% missing_ids)
  missing_data <- missing_data %>% mutate(PTM = 'No ptm')
  peiman_database <- dplyr::bind_rows(peiman_database, missing_data)
  
  return(peiman_database)
  
}