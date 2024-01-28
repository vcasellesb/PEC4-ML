# petites funcions per a computar diverses mètriques en cas de multi-class classification

f1_score <- function(cm) {
  ## from: https://stackoverflow.com/a/36843900
  cm <- cm$table
  precision <- diag(cm) / colSums(cm)
  recall <- diag(cm) / rowSums(cm)
  f1 <-  ifelse(precision + recall == 0, 0, 2 * precision * recall / (precision + recall))
  
  #Assuming that F1 is zero when it's not possible compute it
  f1[is.na(f1)] <- 0
  
  #Binary F1 or Multi-class macro-averaged F1
  mean(f1)
}

recall <- function(cm) {
  cm <- cm$table
  recall <- diag(cm) / rowSums(cm)
  mean(recall)
}

