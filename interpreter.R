#
# Henry Samuelson 6/27/18
# 
# This is the main interpreter. This is used to read through the file and call the respective libraries
# 

# TO read console input for ths program
rm(list=ls()) #This clears all system vars to avoid errors
args <- commandArgs(trailingOnly = TRUE)
loadScript <- function(){
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
if (!require("foreach")) install.packages("foreach", repos='http://cran.us.r-project.org') # The new parallel version requires library parallels
library(foreach)



# From loading from a file have to conver to table matrix
#script <- suppressWarnings(readLines(loadScript()))

## UNCOMMENT THESE FOR DEV

script <- suppressWarnings(readLines("mainScript.interOp")) #This triggers a warning but not an concern
#script <- suppressWarnings(readLines("wrapper.interOp")) #This triggerss a warning but not an concern
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
    first <- strsplit(script[i,], " ")[[1]][1]
    if(!is.na(first)){
      
      if(first == "**R" || first == "**python" || first == "**js" || first == "**lua" || first == "**go" || first == "**Elixir" || first == "**bat" || first == "**rust" || first == "**ruby" || first == "**perl" || first == "**dart" || first == "**java"){
        lowerBound <- i
        moduleName <- strsplit(script[i,], " ")[[1]][2]
        outPutType <- strsplit(script[i,], " ")[[1]][3]
        for(j in i:length(script[,1])){
          if(script[j,] == "**/"){
            upperBound <- j
            return(c(lowerBound, upperBound, moduleName, outPutType))
          }
        }
      }
    }
  }
}


processBounds <- function(){
  counter <- 1
  bounds <- c("lower", "upper", "moduleName", "outputType")
  for( i in 1:length(script[,1])){
    bounds <- rbind(bounds, findBounds(script, startingVal = counter))
    counter <- findBounds(script, startingVal = counter)[2]
    if(is.null(counter)) {
      #print(i)
      break()
      }
    if(counter == length(script[,1])){
      break
    }
  }
  bounds <- bounds[-1,]
  return(bounds)
}

#Send Processing calls 

allbounds <- processBounds()
# If there is only one function assigning a row wont always work
# so we need to check first how many functions their are.
if(length(allbounds) != 3) {
  titleRows <- as.integer(allbounds[,1])
  
} else if(length(allbounds) == 3 ) {
  allbounds <- rbind(allbounds)
  titleRows <- as.integer(allbounds[1])
} else {
  print("faital script error")
}
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

      if(!is.na(headTag[2])){
        if(headTag[2] == "**<<"){
          funcList[counter] <- script[i]
          counter = counter + 1
        }
      }
    }
  }
  # Make sure there are actual function calls:
  if(length(funcList) == 0) {
    return("No Function Calls. What are you doing?")
  }
  #parallelLoop
  tt <- suppressWarnings(foreach(i=1:length(funcList)) %do% { # defining this to tt to avoid unwanted console output
    
    headTag <- strsplit(funcList[i], " ")[[1]]
    if(headTag[1] == "**"){ #function decloration syntax
      
      #Run function
      funcName <- headTag[2]
      allBoundsIndex <- match(funcName, allbounds[,3])
      if(length(headTag) == 3){
        print("Head Tag is 3")
        print(headTag[3])
        output <- processFunction(allBoundsIndex, argument = headTag[3])
      } else {
        print("not 3")
        print(headTag)
        output <- processFunction(allBoundsIndex)
      }
      print(output)
      
    }
    ################
    if(!is.na(headTag[2])){
      if(headTag[2] == "**<<"){
        #Then we need to pass both func bounds
        #print(headTag)
        print(Piper(headTag[3], headTag[1]))
      }
    }
  })
}
start_time <- Sys.time()
master()
end_time <- Sys.time()
end_time - start_time




