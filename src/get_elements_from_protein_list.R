library(stringr)

get_elements_from_protein_list  = function(x){
  
  # AC column
  indx_AC      <- str_detect(string = x, pattern = 'ACHEREAC ')
  end_position <- str_locate(string = x[indx_AC], pattern = ';')[1,2]
  AC           <- str_trim(  string = str_sub(string = x[indx_AC], start = 9, end = end_position-1) , side = 'both' )
  AC           <- AC[1]
  
  # OS column
  indx_OS <- str_detect(string = x, pattern = 'OSHEREOS ')
  if( length(x[indx_OS]) == 1 ){
    OS      <- x[indx_OS]
    OS      <- str_replace(OS, pattern = 'OSHEREOS ', replacement = '')
    OS      <- str_trim(OS)
  }else if(length(x[indx_OS]) > 1) {
    OS      <- x[indx_OS]
    OS      <- str_replace(OS, pattern = 'OSHEREOS ', replacement = '')
    OS      <- str_trim(OS)
    OS      <- paste(OS, collapse = ' ')
  }else{
    OS      <- NA
  }
  
  # KW column
  indx_KW <- str_detect(string = x, pattern = 'KWHEREKW ')
  if( length(x[indx_KW]) == 1 ){
    KW      <- x[indx_KW]
    KW      <- str_replace(KW, pattern = 'KWHEREKW ', replacement = '')
    KW      <- str_trim(KW)
  }else if( length(x[indx_KW]) > 1 ){
    KW      <- x[indx_KW]
    KW      <- str_replace(KW, pattern = 'KWHEREKW ', replacement = '')
    KW      <- str_trim(KW)
    KW      <- paste(KW, collapse = ' ')
    KW      <- str_replace_all(string = KW, pattern = regex(pattern = '[.]'), replacement = '')
  }else{
    KW      <- NA
  }
  
  # FT column
  indx_FT <- str_detect(string = x, pattern = 'FTHEREFT ')
  if( length(x[indx_FT]) == 1 ){
    FT      <- x[indx_FT]
    FT      <- str_replace(FT, pattern = 'FTHEREFT ', replacement = '')
    FT      <- str_trim(FT)
  }else if( length(x[indx_FT]) > 1 ){
    FT      <- x[indx_FT]
    FT      <- str_replace(FT, pattern = 'FTHEREFT ', replacement = '')
    FT      <- str_trim(FT)
  }else{
    FT      <- NA
  }
  
  
  if( !is.null(FT) ){
    FT           <- get_PTM_from_FT(FT)
  }else{
    FT <- ''
  }
  
  # Return the results as a list
  #return( list(AC = AC, OS = OS, KW = KW, FT = FT) )
  return( list(AC = AC, OS = OS, KW = KW, FT = FT) )
  
}
