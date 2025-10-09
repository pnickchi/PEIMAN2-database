get_PTM_keywords_table_from_uniprot = function(){

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
