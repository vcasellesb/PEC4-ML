# En aquest fitxer .R deixaré la meva implementació d'un algoritme kNN 
# que vaig "desenvolupar" per a la PEC1. Per a generar aquest fitxer i 
# fer-lo funcionar des de el fitxer Rmd he seguit el següent tutorial:
# https://www.earthdatascience.org/courses/earth-analytics/
# multispectral-remote-sensing-data/source-function-in-R/

get_distance_obs <- function(vector1, vector2){
  # función que calcula la l-2 norm entre
  # dos vectores
  return(sqrt(sum((vector1 - vector2)**2)))
}

vectorize_obs_and_train_data <- function(y, train_obs){
  # esta función permite vectorizar el calculo de la distancia
  # de una observación vs todas las observaciones de training
  # data
  y_matrix = matrix(rep(as.numeric(y), nrow(train_obs)), 
                    byrow=TRUE, ncol=ncol(y))
  train_obs = unname(as.matrix(train_obs))
  
  matrix_all_data = cbind(train_obs, y_matrix)
  return(matrix_all_data)
}
compute_distance_y_to_train_observations <- function(y, train_obs){
  ## Returns a vector of distances of all training observations to y
  ## so a nd-vector where n is the number of training observations
  matrix_all_data = vectorize_obs_and_train_data(y, train_obs)
  distances = apply(X=matrix_all_data, MARGIN=1, 
                    FUN = function(x) get_distance_obs(x[1:ncol(y)],
                                                       x[(ncol(y)+1):ncol(matrix_all_data)]))
  return(distances)
}

subset_k_distances <- function(vector_distances, k, seed=NULL){
  # Returns indices of values that minimize our distance function
  # seed es para reproducibilidad ya que hay factor aleatorio en caso de empate
  
  max_distance_well_get = max(sort(vector_distances, decreasing = F)[1:k])
  
  k_min_distances = which(vector_distances < max_distance_well_get)
  k_min_distances_tied = which(vector_distances == max_distance_well_get)
  
  if (length(k_min_distances_tied) > 1){
    if (!is.null(seed)){set.seed(seed)}
    k_min_distances_tied = sample(k_min_distances_tied)}
  
  how_many_are_we_missing = k - length(k_min_distances)
  k_min_distances = append(k_min_distances, 
                           k_min_distances_tied[1:how_many_are_we_missing])
  
  stopifnot(length(k_min_distances) == k)
  return(k_min_distances)
}

get_labels_corresponding_to_k_neighbors <- function(train_labels, indices){
  # self-explanatory
  return(train_labels[indices])
}

predict_one_observation <- function(y_obs, train_data, 
                                    k, train_labels, prob=F, seed=NULL){
  # básicamente esta es la funcion que, data una nueva observación 
  # i el conjunto de observaciones training, computa la prediccción de 
  # la nueva observación, dadas k
  # seed es para reproducibilidad ya que hay factor aleatorio en caso de empate
  distances_to_train_data <- compute_distance_y_to_train_observations(y_obs, 
                                                                      train_data)
  k_distance_indices = subset_k_distances(distances_to_train_data, k=k, 
                                          seed=seed)
  labels_sliced = get_labels_corresponding_to_k_neighbors(train_labels, 
                                                          k_distance_indices)
  k_votes = summary(factor(labels_sliced))
  max_vote = max(k_votes)
  names_max_votes = which(k_votes == max_vote)
  
  is_there_a_tie = length(names_max_votes) > 1
  
  if (is_there_a_tie){
    if (!is.null(seed)){set.seed(seed)}
    names_max_votes = sample(names_max_votes)
    res = names(names_max_votes[1])
  } else{res = names(sort(k_votes, decreasing = T)[1])}
  
  if (prob == T){
    # si queremos las probabilidades, retornamos (rip Gustavo Adolfo Bécquer) 
    # la máxima (que corresponde al nearest neighbor)
    probabilities = k_votes/sum(k_votes)
    attr(res, 'prob') = max(probabilities)
  }
  
  stopifnot(length(res)==1)
  return(res)
}

predict_all_observations <- function(newdata, train_data, 
                                     k, train_labels, prob=F,
                                     seed=NULL){
  # aquesta és bàsicament la funció que amplia la funció anterior pero per a un
  # dataframe amb moltes observacions. Itera per totes les observacions (no gaire
  # cool)
  # seed es para reproducibilidad ya que hay factor aleatorio en caso de empate
  
  predicted_labels = c() # aquí guardarem les noves prediccions
  
  # preparo el vector de les probabilitats en el cas de que les necessitem
  if (prob == T){probabilities = c()}
  
  if (!is.data.frame(newdata)){stop("Non supported data type")}
  n_observations_to_predict = nrow(newdata)
  for (obs in 1:n_observations_to_predict){
    predicted_label = predict_one_observation(y_obs=newdata[obs, ], 
                                              train_data = train_data, 
                                              k=k, 
                                              train_labels = train_labels, 
                                              prob = prob, seed = seed)
    predicted_labels = append(predicted_labels, predicted_label)
    if (prob == T){
      probabilities = append(probabilities, attr(predicted_label, 'prob'))
    }
  }
  # copiat descaradament del codi de la funció knn de class
  if (prob==T){attr(predicted_labels, 'prob') = probabilities}
  return(predicted_labels)
}

accuracy = function(y, ypred){
  equality = factor(y) == factor(ypred)
  return(sum(equality)/length(y))
}