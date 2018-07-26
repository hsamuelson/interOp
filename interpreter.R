#
# Henry Samuelson 6/27/18
# 
# This is the main interpreter. This is used to read through the file and call the respective libraries
# 

# TO read console input for ths program
rm(list=ls()) #This clears all system vars to avoid errors
args <- commandArgs(trailingOnly = TRUE)
loadScrit <- function(){
  fileName <- ""
  if(is.na(args[1])){
    fileName <- choose.files()
  } else if(args[1] == 1){
    fileName <- "mainScript.interOp"
  } else {
    fileName <- args[1]
  }
  return(fileName)
}

script <- suppressWarnings(readLines("mainScript.interOp")) #This triggers a warning but not an concern
# From loading from a file have to conver to table matrix
script <- as.matrix(script)

# Remove all comments  #######THIS COULD ALL BE NOT WORKING BC YOU HAVENT REDEFINED IT AS A MATRIX?
# updatedScript <- 0
# counter <- 1
# # Remove Spaces
# for(i in 1:length(script)){
#   if(script[i] != ""){
#     updatedScript[counter] <- script[i]
#     counter = counter + 1
#   }
# }
# 
# for(i in 1:length(script)){
#   if(isTRUE(strsplit(script[i], "")[[1]][1] != "#")){
#     updatedScript[counter] <- script[i]
#     counter = counter + 1
#   }
# }
# script <- updatedScript

# takes the processed script as input
findBounds <- function(script, startingVal = 1){
  lowerBound <- 0
  upperBound <- 0
  moduleName <- 0
  for(i in startingVal:length(script[,1])){
    if(script[i,] == "**R" || script[i,] == "**python" || script[i,] == "**js" || script[i,] == "**lua" || script[i,]== "**go" || script[i,] == "**Elixir" || script[i,] == "**bat" || script[i,] == "**rust" || script[i,] == "**ruby" || script[i,] == "**perl" || script[i,] == "**dart" || script[i,] == "**java"){
      lowerBound <- i
      moduleName <- script[i-1,]
      for(j in i:length(script[,1])){
        if(script[j,] == "**/"){
          upperBound <- j
          return(c(lowerBound, upperBound, moduleName))
        }
      }
    }
  }
}


processBounds <- function(){
  counter <- 1
  bounds <- c("lower", "upper", "moduleName")
  for( i in 1:length(script[,1])){
    bounds <- rbind(bounds, findBounds(script, startingVal = counter))
    counter <- findBounds(script, startingVal = counter)[2]
    if(counter == length(script[,1])){
      break
    }
  }
  bounds <- bounds[-1,]
  return(bounds)
}

#Send Processing calls 

allbounds <- processBounds()
titleRows <- as.integer(allbounds[,1])
source("processRequest.R")

Piper <- function(firstFunc, secondFunc){
  
  #Run first return output
  firstFunc <- processFunction(match(firstFunc, allbounds[,3])) #Now it has the output val of first funct
  secondFunc <- processFunction(match(secondFunc,allbounds[,3]), firstFunc)
  return(secondFunc)
  
}
master <- function(){
  #
  # This is the parallel version 7/26/18
  #
  # Instead of normally reading through the script while processing,
  # this loop reads through the script and compiles a new script which 
  # is comprized of only function calls and interOp operations. This list
  # Is then run in parallel.
  counter <- 1
  funcList <- numeric() # This will be the list of preprocessed functions passed to the foreach()
  for(i in 1:length(script)){
    
    # Ignore Spaces
    if(length(strsplit(script[i], " ")[[1]]) != 0){ #If its zero then its def a space
      
      headTag <- strsplit(script[i], " ")[[1]]

      if(headTag[1] == "**"){ #function decloration syntax
        funcList[counter] <- script[i]
        counter = counter + 1
      }

      if(length(headTag) == 3){
        if(headTag[2] == "**<<"){
          funcList[counter] <- script[i]
          counter = counter + 1
        }
      }
    }
  }
  #parallelLoop
  tt <- foreach(i=1:length(funcList)) %do% { # defining this to tt to avoid unwanted console output
    
    headTag <- strsplit(funcList[i], " ")[[1]]
    if(headTag[1] == "**"){ #function decloration syntax
      
      #Run function
      funcName <- headTag[2]
      allBoundsIndex <- match(funcName, allbounds[,3])
      if(length(headTag) == 3){
        output <- processFunction(allBoundsIndex, argument = headTag[3])
      } else {
        output <- processFunction(allBoundsIndex)
      }
      print(output)
      
    }
    ################
    if(length(headTag) == 3){
      if(headTag[2] == "**<<"){
        #Then we need to pass both func bounds
        #print(headTag)
        print(Piper(headTag[3], headTag[1]))
      }
    }
  }
}
#start_time <- Sys.time()
master()
#end_time <- Sys.time()
#end_time - start_time




