Generate_Protein_List               = function(filename){
  
  # 
  # Read the reduced sized text file
  #
  raw_lines <- readLines(filename)
  
  #
  # Identifying the lines that belongs to each protein.
  # In the TEXT file, each protein is separated by _//_
  # So we need to spot the positions where _//_ occurs 
  # and read the lines in between for each protein.
  #
  indx <- which( raw_lines == '_//_' )
  indx <- c(1,indx)
  
  #
  # Reading the information of each protein.
  # Each protein data will be saved in protein_List 
  #
  n <- length(indx)
  protein_List <- list()
  for( i in 1:(n-1) ){
    protein_List[[i]] <- raw_lines[ indx[i]:indx[i+1] ]
  }
  
  return(protein_List = protein_List)
  
}
 
Extract_Elements_From_Protein_List  = function(x){
  
  library(stringr)
  
  # ID column
  # indx_ID <- str_detect(string = x, pattern = "IDHEREID ")
  # ID      <- str_trim( string = str_sub(string = x[indx_ID][1], start = 9, end = nchar(x[indx_ID]) ) , side = "both" )
  # ID      <- ID[1]
  
  # AC column
  indx_AC      <- str_detect(string = x, pattern = "ACHEREAC ")
  end_position <- str_locate(string = x[indx_AC], pattern = ";")[1,2]
  AC           <- str_trim(  string = str_sub(string = x[indx_AC], start = 9, end = end_position-1) , side = "both" )
  AC           <- AC[1]
  
  # OS column
  indx_OS <- str_detect(string = x, pattern = "OSHEREOS ")
  if( length(x[indx_OS]) == 1 ){
    OS      <- x[indx_OS]
    OS      <- str_replace(OS, pattern = "OSHEREOS ", replacement = "")
    OS      <- str_trim(OS)
  }else if(length(x[indx_OS]) > 1) {
    OS      <- x[indx_OS]
    OS      <- str_replace(OS, pattern = "OSHEREOS ", replacement = "")
    OS      <- str_trim(OS)
    OS      <- paste(OS, collapse = " ")
  }else{
    OS      <- NA
  }
  
  # KW column
  indx_KW <- str_detect(string = x, pattern = "KWHEREKW ")
  if( length(x[indx_KW]) == 1 ){
    KW      <- x[indx_KW]
    KW      <- str_replace(KW, pattern = "KWHEREKW ", replacement = "")
    KW      <- str_trim(KW)
  }else if( length(x[indx_KW]) > 1 ){
    KW      <- x[indx_KW]
    KW      <- str_replace(KW, pattern = "KWHEREKW ", replacement = "")
    KW      <- str_trim(KW)
    KW      <- paste(KW, collapse = " ")
    KW      <- str_replace_all(string = KW, pattern = regex(pattern = "[.]"), replacement = "")
  }else{
    KW      <- NA
  }
  
  # FT column
  indx_FT <- str_detect(string = x, pattern = "FTHEREFT ")
  if( length(x[indx_FT]) == 1 ){
    FT      <- x[indx_FT]
    FT      <- str_replace(FT, pattern = "FTHEREFT ", replacement = "")
    FT      <- str_trim(FT)
  }else if( length(x[indx_FT]) > 1 ){
    FT      <- x[indx_FT]
    FT      <- str_replace(FT, pattern = "FTHEREFT ", replacement = "")
    FT      <- str_trim(FT)
    #FT      <- paste(FT, collapse = " ")
  }else{
    FT      <- NA
  }
  

  if( !is.null(FT) ){
    FT           <- Extract_PTM_from_FT(FT)
    #FT           <- stringr::str_trim(string = FT, side = "both")
  }else{
    FT <- ""
  }
  
  
    
  # if( !is.null(FT) ){
  #  xx           <- Extract_PTM_from_FT(FT)
  #  FT_MOD_RES   <- xx[[1]] 
  #  FT_LIPID     <- xx[[2]] 
  #  FT_CROSSLINK <- xx[[3]] 
  # }else{
  #   FT_MOD_RES   <- "" 
  #   FT_LIPID     <- ""
  #   FT_CROSSLINK <- ""
  # }
  
  # CC column
  # indx_CC <- str_detect(string = x, pattern = "CCHERECC ")
  # if( length(x[indx_CC]) == 1 ){
  #   CC      <- x[indx_CC]
  #   CC      <- str_replace(CC, pattern = "CCHERECC ", replacement = "")
  #   CC      <- str_trim(CC)
  # }else if( length(x[indx_CC]) > 1 ){
  #   CC      <- x[indx_CC]
  #   CC      <- str_replace(CC, pattern = "CCHERECC ", replacement = "")
  #   CC      <- str_trim(CC)
  #   CC      <- paste(CC, collapse = " ")
  # }else{
  #   CC      <- NA
  # }
  
  # Return the results as a list
  #return( list(AC = AC, OS = OS, KW = KW, FT_MOD_RES = FT_MOD_RES, FT_LIPID = FT_LIPID, FT_CROSSLINK = FT_CROSSLINK) )
  return( list(AC = AC, OS = OS, KW = KW, FT = FT) )
  
}

Extract_PTM_from_FT                 = function(x){
  
  library(stringr)
  
  #x <- unlist( strsplit(x, split = '/') )
  n <- length(x)
  
  
  FT_MOD_RES   <- x[ which( str_detect(string = x, pattern = 'MOD_RES') ) + 1 ]
  FT_LIPID     <- x[ which( str_detect(string = x, pattern = 'LIPID') ) + 1 ]
  FT_CROSSLNK  <- x[ which( str_detect(string = x, pattern = 'CROSSLNK') ) + 1 ]

  FT_MOD_RES  <- str_replace_all(string = FT_MOD_RES,  pattern = "/note=\"", replacement = "")
  FT_MOD_RES  <- str_replace_all(string = FT_MOD_RES,  pattern = "\"", replacement = "")
  
  FT_LIPID    <- str_replace_all(string = FT_LIPID,    pattern = "/note=\"", replacement = "")
  FT_LIPID    <- str_replace_all(string = FT_LIPID,    pattern = "\"", replacement = "")
  
  FT_CROSSLNK <- str_replace_all(string = FT_CROSSLNK, pattern = "/note=\"", replacement = "")
  FT_CROSSLNK <- str_replace_all(string = FT_CROSSLNK, pattern = "\"", replacement = "")
  
  # FT_MOD_RES   <- c()
  # FT_LIPID     <- c()
  # FT_CROSSLINK <- c()
  # 
  # for(i in 1:n){
  #   
  #   if( str_detect(string = x[i], pattern = "MOD_RES") ){
  #     FT_MOD_RES[i] <- str_trim( str_sub(string = x[i+1], start = 7), side = "both" )
  #   }
  #   
  #   if( str_detect(string = x[i], pattern = "LIPID") ){
  #     FT_LIPID[i] <- str_trim( str_sub(string = x[i+1], start = 7), side = "both" )
  #   }
  #   
  #   if( str_detect(string = x[i], pattern = "CROSSLNK") ){
  #     FT_CROSSLINK[i] <- str_trim( str_sub(string = x[i+1], start = 7), side = "both" )
  #   }
  #   
  # }
  
  if( !is.null(FT_MOD_RES) ){
    FT_MOD_RES   <- FT_MOD_RES[!is.na(FT_MOD_RES)]
  }
  
  if( !is.null(FT_LIPID) ){
    FT_LIPID     <- FT_LIPID[!is.na(FT_LIPID)]
  }
  
  if( !is.null(FT_CROSSLNK) ){
    FT_CROSSLNK <- FT_CROSSLNK[!is.na(FT_CROSSLNK)]
  }
  
  FT_MOD_RES   <- unique(FT_MOD_RES)
  FT_LIPID     <- unique(FT_LIPID)
  FT_CROSSLNK  <- unique(FT_CROSSLNK)
  
  # FT_MOD_RES   <- paste(FT_MOD_RES,  collapse = '')
  # FT_LIPID     <- paste(FT_LIPID,    collapse = '')
  # FT_CROSSLNK  <- paste(FT_CROSSLNK, collapse = '')
  
  # FT_MOD_RES   <- str_replace_all(string = FT_MOD_RES,   pattern = '"', replacement = ';')
  # FT_LIPID     <- str_replace_all(string = FT_LIPID,     pattern = '"', replacement = ';')
  # FT_CROSSLINK <- str_replace_all(string = FT_CROSSLINK, pattern = '"', replacement = ';')
  
  FT <- c(FT_MOD_RES, FT_LIPID, FT_CROSSLNK)
  FT <- paste(FT, collapse = ";")
  return(FT)
#  return( list(FT_MOD_RES = FT_MOD_RES, FT_LIPID = FT_LIPID, FT_CROSSLINK = FT_CROSSLINK) )
}

Get_PTM_Keywords_Table_From_UniProt = function(){
  
  #  
  # Define the url address where we can read all the UniProt PTM list
  #
  #target_url <- 'https://www.uniprot.org/docs/ptmlist.txt'
  #target_url <- 'https://www.uniprot.org/keywords/KW-9991'
  target_url <- 'https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/docs/ptmlist'
  
  
  

  #
  # Read the lines of the file
  #
  raw_lines <- readLines(con = target_url)
  raw_lines <- raw_lines[48:length(raw_lines)]
  
  #
  # Identifying the end of each term
  #
  indx <- which( raw_lines == '//' )
  indx <- c(1,indx)
  
  
  #
  # Reading the information of each PTM term seperately.
  #
  n <- length(indx)
  ptm_list <- list()
  for( i in 1:(n-1) ){
    ptm_list[[i]] <- raw_lines[ indx[i]:indx[i+1] ]
  }
  
  
  library(stringr)
  
  n <- length(ptm_list)
  ID <- list()
  AC <- list()
  KW <- list()
  FT <- list()
  for(i in 1:n){
     
    # ID column
    x       <- ptm_list[[i]][ str_detect(string = ptm_list[[i]], pattern = "ID ") ]
    x       <- str_trim( string = str_sub(string = x, start = 3, end = nchar(x) ) , side = "both" )
    ID[[i]] <- x[1]
    
    # AC column
    x            <- ptm_list[[i]][ str_detect(string = ptm_list[[i]], pattern = "AC ") ]
    x            <- str_trim(  string = str_sub(string = x, start = 3, end = nchar(x)) , side = "both" )
    AC[[i]]      <- x[1]
  

    # KW column
    x       <- ptm_list[[i]][ str_detect(string = ptm_list[[i]], pattern = "KW ") ]
    if( length(x) != 0 ){
      KW[[i]]           <- str_trim(  string = str_sub(string = x, start = 3, end = nchar(x)-1) , side = "both" )[1]
    }else{
      KW[[i]] <- NA
    }

  
    # FT column
    x       <- ptm_list[[i]][ str_detect(string = ptm_list[[i]], pattern = "FT ") ]
    if( length(x) != 0 ){
      FT[[i]]         <- str_trim(  string = str_sub(string = x, start = 3, end = nchar(x)) , side = "both" )
    }else{
      FT[[i]]         <- NA
    }
    
  }
  
  table_list <- data.frame( ID = unlist(ID), 
                            AC = unlist(AC), 
                            KW = unlist(KW), 
                            FT = unlist(FT),
                            stringsAsFactors=FALSE)
  
  return(table_list)

}

Detecting_proteins_with_PTM         = function(x, search_list){
  
  KW_Check         <- stringr::str_detect(string = x[3], pattern = search_list)
  KW_Check         <- as.logical( sum(KW_Check) )
  FT               <- x[4] != ""
  # FT_MOD_RES_Check <- x[4] != "" 
  # FT_LIPID_Check   <- x[5] != "" 
  # FT_CROSSLINK     <- x[6] != ""
  
#  res <- KW_Check | FT_MOD_RES_Check | FT_LIPID_Check | FT_CROSSLINK
  res <- KW_Check | FT
  return(res)
}

MakePEIMAN = function(dt){

  #
  # Step 1. Get all the proteins as a list in R
  #
  protein_List <- Generate_Protein_List(filename = readLines('OUTPUT.txt', warn = FALSE) )
  message('Step 1 done!')
  
  
  
  #
  # Step 2: Extract 4 elements from protein_List and create the temporary PEIMAN database
  #
  start.time <- Sys.time()
  temp_list  <- lapply(X = protein_List, FUN = Extract_Elements_From_Protein_List )
  end.time   <- Sys.time()
  print(end.time-start.time)
  peiman_temp_database <- data.frame( matrix(unlist(temp_list), nrow=length(temp_list), byrow=T), stringsAsFactors=FALSE)
  colnames(peiman_temp_database) <- c("AC","OS","KW","FT")
  peiman_temp_database$OS <- str_replace(string = peiman_temp_database$OS, pattern = '\\.', replacement = '')
  #
  t1 <- peiman_temp_database$AC
  t2 <- peiman_temp_database$OS
  all_in_uniprot <- data.frame(AC = t1, OS = t2)
  #
  message('Step 2 done!')
  
  
  
  #
  # Step 3: Screening: Keep proteins with any PTM annotations in KW or FT
  #
  
  # Get the updated list of ptm terms.
  uniprot_ptm_list <- Get_PTM_Keywords_Table_From_UniProt()
  
  library(stringr)
  # KW_Search_List <- unique( uniprot_ptm_list$KW )
  # KW_Search_List <- unlist( strsplit(x = KW_Search_List, split = ";") )
  # KW_Search_List <- stringr::str_trim(string = KW_Search_List, side = "both")
  # KW_Search_List <- unique( KW_Search_List )
  # KW_Search_List <- KW_Search_List[ complete.cases(KW_Search_List) ]
  
  KW_Search_List         <- jsonlite::fromJSON('https://rest.uniprot.org/keywords/KW-9991.json')
  KW_Search_List         <- KW_Search_List$children$keyword$name
  indx_proteins_with_ptm <- apply(X = peiman_temp_database, MARGIN = 1, FUN = Detecting_proteins_with_PTM, search_list = KW_Search_List)
  NO_PTM_DB              <- peiman_temp_database[!indx_proteins_with_ptm,]
  peiman_temp_database   <- peiman_temp_database[indx_proteins_with_ptm,]
  message('Step 3 done!')
  
  
  
  #
  # Step 4: Extracting proteins with PTM and building the final database
  # 
  library(tidyr)
  library(dplyr)
  KW_database <- peiman_temp_database[, c("AC","OS","KW") ]
  FT_database <- peiman_temp_database[, c("AC","OS","FT") ]
  
  # 1. KW:
  KW_database     <- separate_rows(KW_database, KW, sep = ';')
  KW_database$KW  <- stringr::str_trim(string = KW_database$KW, side = "both")
  KW_database$KW  <- str_replace(string = KW_database$KW, pattern = regex(pattern = "[.]"), replacement = "" )
  KW_database     <- KW_database %>% filter(KW %in% KW_Search_List)
  
  
  # 2. FT:
  FT_database      <- separate_rows(FT_database, FT, sep = ';')
  empty_rows_in_FT <- which( FT_database$FT == "" )
  
  if( length(empty_rows_in_FT) != 0 ){
    FT_database <- FT_database[-empty_rows_in_FT,]
  }
  FT_database$FT <- stringr::str_trim(string = FT_database$FT, side = "both")
  
  FT_Search_List <- unique(uniprot_ptm_list$ID)
  FT_database <- FT_database %>% filter( FT %in% FT_Search_List)
  
  
  AC  <- c(KW_database$AC, FT_database$AC)
  OS  <- c(KW_database$OS, FT_database$OS)
  PTM <- c(KW_database$KW, FT_database$FT)
  peiman_database <- data.frame(AC = as.character(AC), OS = as.character(OS), PTM = as.character(PTM) )
  rownames(peiman_database) <- seq(1:nrow(peiman_database))
  
  peiman_database <- peiman_database[ !duplicated(peiman_database), ]
  message('Step 4 done!')
  
  
  ac  <- NO_PTM_DB$AC
  os  <- NO_PTM_DB$OS
  noptm <- rep('No ptm', length(ac))
  d  <- data.frame(AC = ac, OS = os, PTM = noptm)
  d  <- d[ !duplicated(d), ]
  peiman_database <- dplyr::bind_rows(peiman_database, d)
  missing_ids  <- setdiff(all_in_uniprot$AC,peiman_database$AC)
  missing_data <- all_in_uniprot %>% filter(AC %in% missing_ids)
  missing_data <- missing_data %>% mutate(PTM = NA)
  peiman_database <- dplyr::bind_rows(peiman_database, missing_data)
  
  save(x = peiman_database,  file = paste0('/home/payman/peiman_database_', dt, '.RData') )
  save(x = uniprot_ptm_list, file = paste0('/home/payman/uniprot_ptm_list', dt, '.RData') )
  message('Saved curated files!')
  
}