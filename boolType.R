#
# Henry Samuelson
#
# Bool Data Type interpreter 
processBool <- function(x){
  
  #First check the bool type true/false 
  # Then convert to universal T/F 
  if(x == "True" || x == "true" || x == "T"){
    x <- "T"
  } else if( x == "False" | x == "false" || x == "F"){
    x <- "F"
  }
  # Now that we have standardized the input data we can 
}