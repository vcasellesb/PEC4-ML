parse_from_csv <- function(cm_csv){
  ## takes a confusion table from a csv and returns a matrix valid for
  ## passing it to confusionMatrix from caret
  
  df <- read.csv(cm_csv, row.names = 1)
  
  mat <- as.matrix(df); rownames(mat) <- colnames(mat) 
  
  cm <- confusionMatrix(mat)
  
  return(cm)
}
