

################################################

conf_int_hmtl <- function(x){
  
  type = x$type
  value = x$between  
  
  rez = paste0("Confidence Interval: ",type,"% CI[",paste(value[[1]],collapse = ", "),"]")
  
  return(rez) 
}

title_html <- function(x,rank=1){
  paste0("<h",rank,">", x, "</h",rank,">")
}


indicateur_html <- function(x,type){
  rez <- ""
  rez <- paste0(type, ": ")
  
  
  if ( "values" %in% names(x)){
    rez <- paste(rez , paste(x$values[[1]],collapse = ", "))
  } 
  if ("between"  %in% names(x)){
    rez <- paste(rez, "entre",paste(x$between[[1]],collapse = ", "))
  } 
  if ("Confidence interval" %in% names(x)){
    rez <- paste(rez, conf_int_hmtl(x[["Confidence interval"]])) 
  } 
  
  other <- names(x)[!names(x) %in% c("values","between","Confidence interval")]
  for(i in other){
    rez <- paste(rez, "\n",i,": ",paste(x[i][[1]],collapse = ", "))
  }
    
  

  # else if ("between" %in% names(x)& length(x$between[[1]])!= 0){
  #   
  #   rez <- paste0(rez, "entre ",paste(x$between[[1]],collapse = ", "))
  # }
  # else if ("Confidence interval" %in% names(x)& !is.null(x$`Confidence interval`$between[[1]]) ){
  #   rez <- paste0(rez, conf_int_hmtl(x$`Confidence interval`)) 
  # }
  return(rez)
}


test_data <- function(x){
  t = names(x) %in% c("values", "between", "Confidence interval" )
  if(length(t)==0) t = F
  if(sum(t)>0) t = T 
  if(length(t)!=1) t = F
  return(t)
}


test_rec <- function(x,last_state, Name, rank=1, rez = ""){
  
  if(typeof(x)=="list" & !test_data(x) ){
    
    # print(x)
    for (n in 1:length(x)){
      
      if(typeof(x[[n]])=="list" &!test_data(x[[n]])){ 
        title = title_html(names(x[n]),rank = rank)
        # print(title)
        rez <- paste0(rez , title)
      }
      rez = test_rec(x[[n]],last_state = x, Name= names(x[n]), rank = rank +1, rez = rez) 
    }
    
  } else {
    # print("====== not list")
    # print(x)
    # print(Name)
    # print(names(last_state))
    
    if(test_data(x)) {
      ind = indicateur_html(x,Name)
      rez <- paste0(rez , ind, "\n")
      # print(ind)
    } else {
      ind = paste0(Name, ": ", x[1])
      rez <- paste0(rez , ind, "\n")
      # print(ind)
    }
  }
  # cat(rez)
  rez <- gsub("\n", "<br>", rez)
  return(rez)
} 



###########################



# 
# 
# library(dplyr)
# library(mongolite)
# 
# 
# 
# 
# connection_string = 'mongodb://localhost:27017/'
# trips_collection = mongo(collection="Scales", db="IdeeScaleDb", url=connection_string)
# trips_collection$count()
# request <- paste0('{"_id": {"$oid":"', "68aecfb22ae6b4abd2207495" , '"}}')
# cat(request,"\n")
# scale_data <- trips_collection$find(query= request)
# 
# 
# x = scale_data$validity
# t = test_rec(x)
# cat(t)
# 
# x = x$`factor analysis`$invariance$gender$factor$CFI
# 
# test_data(x)
# t = indicateur_html(x,type="test")
# 
# 
# cat(gsub("\n", "<br>", t))
# x$alpha

