#
# Henry Samuelson 6/27/18
# 
# This is the main interpreter. This is used to read through the file and call the respective libraries
# 




script <- readLines("mainScript.txt")
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
    if(script[i,] == "**R" || script[i,] == "**python" || script[i,] == "**js"){
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
#for(i in 1:length(titleRows)){
processFunction <- function(indexIn, argument = ""){
  w <- script[(as.integer(allbounds[indexIn,1])+1):(as.integer(allbounds[indexIn,2])- 1),]
  
  if(script[titleRows[indexIn],] == "**R"){
    # Write to file and run
    file.create("runner.R")
    writeLines(as.character(w), con = "runner.R", sep = "\n",  useBytes = FALSE) # auto indents lines
    result <- shell(paste(paste0(Sys.getenv("R_HOME"), "/bin/Rscript.exe", collapse =""), "runner.R", argument), intern = T)
    file.remove("runner.R")
    #print(result)
    return(result)
  }
  if(script[titleRows[indexIn],] == "**python"){
    # Write to file and run
    file.create("runner.py")
    writeLines(as.character(w), con = "runner.py", sep = "\n",  useBytes = FALSE) 
    result <- shell(paste("python runner.py", argument), intern = T)
    file.remove("runner.py")
    #print(result)
    return(result)
    
  }
  if(script[titleRows[indexIn],] == "**js"){
    file.create("runner.js")
    writeLines(as.character(w), con = "runner.js", sep = "\n", useBytes = FALSE)
    result <- shell(paste("node runner.js", argument), intern = T)
    file.remove("runner.js")
    #print(result)
    return(result)
    
  }
}

testPiper <- function(firstFunc, secondFunc){
  
  #Run first return output
  firstFunc <- processFunction(match(firstFunc, allbounds[,3])) #Now it has the output val of first funct
  secondFunc <- processFunction(match(secondFunc,allbounds[,3]), firstFunc)
  return(secondFunc)
  
}
master <- function(){
  for(i in 1:length(script)){
    
    # Ignore Spaces
    if(length(strsplit(script[i], " ")[[1]]) != 0){ #If its zero then its def a space
      
      headTag <- strsplit(script[i], " ")[[1]]
      
      #Process function call
      #
      # THis the main function runner #####
      # 
      # ############
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
          print(testPiper(headTag[1], headTag[3]))
        }
      }
    }
  }
}
master()
