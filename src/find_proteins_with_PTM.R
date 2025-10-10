find_proteins_with_PTM = function(tmp_db){
 
  library(stringr)
  
  KW_url         <- 'https://rest.uniprot.org/keywords/KW-9991.json'
  KW_Search_List <- jsonlite::fromJSON(KW_url)
  KW_Search_List <- KW_Search_List$children$keyword$name
  
  indx_proteins_with_ptm <- apply(X = tmp_db, MARGIN = 1, FUN = detecting_proteins_with_PTM, search_list = KW_Search_List)

  return( list(indx_proteins_with_ptm, KW_Search_List) )
  
}


detecting_proteins_with_PTM = function(x, search_list){
  
  KW_Check         <- stringr::str_detect(string = x[3], pattern = search_list)
  KW_Check         <- as.logical( sum(KW_Check) )
  FT               <- x[4] != ""
  res <- KW_Check | FT
  return(res)
}
