library(stringr)

get_PTM_from_FT = function(x){

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
  
  FT <- c(FT_MOD_RES, FT_LIPID, FT_CROSSLNK)
  FT <- paste(FT, collapse = ";")
  
  return(FT)

}
