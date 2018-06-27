#
# Henry Samuelson
# 
# This is the main parser. This is used to read through the file and call the respective libraries
# 




script <- readLines("mainScript.txt")
# From loading from a file have to conver to table matrix
script <- as.matrix(script)

# Remove all comments
updatedScript <- 0
counter <- 1
for(i in 1:length(script)){
  if(isTRUE(strsplit(script[i], "")[[1]][1] != "#")){
    updatedScript[counter] <- script[i]
    counter = counter + 1
  }
}
script <- updatedScript

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
processFunction <- function(indexIn){
  w <- script[(as.integer(allbounds[indexIn,1])+1):(as.integer(allbounds[indexIn,2])- 1),]
  
  if(script[titleRows[i],] == "**R"){
    # Write to file and run
    file.create("runner.R")
    writeLines(as.character(w), con = "runner.R", sep = "\n",  useBytes = FALSE) # auto indents lines
    result <- shell(paste(paste0(Sys.getenv("R_HOME"), "/bin/Rscript.exe", collapse =""), "runner.R"), intern = T)
    file.remove("runner.R")
    print(result)
    return(result)
  }
  if(script[titleRows[i],] == "**python"){
    # Write to file and run
    file.create("runner.py")
    writeLines(as.character(w), con = "runner.py", sep = "\n",  useBytes = FALSE) 
    result <- shell("python runner.py", intern = T)
    file.remove("runner.py")
    print(result)
    return(result)
    
  }
  if(script[titleRows[i],] == "**js"){
    file.create("runner.js")
    writeLines(as.character(w), con = "runner.js", sep = "\n", useBytes = FALSE)
    result <- shell(paste("node runner.js"), intern = T)
    file.remove("runner.js")
    print(result)
    return(result)
    
  }
}


#This processes Pipelines 
for(i in 1:length(script)){
  if(length(strsplit(script[i], " ")[[1]]) == 3){ #If this is true process the module
    if(strsplit(script[i], " ")[[1]][1] == "**<<"){
      pipeLine <- strsplit(script[i], " ")[[1]]
      #pipeLine[2] #js mod name
      #pipeLine[3] #R  mode name
      
      #First pipe
      firstPipe <- allbounds[allbounds[,3] %in% pipeLine[2],]
      firstLower <- as.integer(firstPipe[1])
      firstUpper <- as.integer(firstPipe[2])
      
      firstRange <- script[((firstLower+1):(firstUpper-1)),]
      print(firstRange)
      #Second Pipe
      secondPipe <- allbounds[allbounds[,3] %in% pipeLine[3],]
      secondLower <- as.integer(secondPipe[1])
      secondUpper <- as.integer(secondPipe[2])
      
      secondRange <- script[((secondLower+1):(secondUpper-1)),]
      print(secondRange)
      
      #js goes into r first into second 
      # So find the first value first
      #processedData <- 0 
      if(script[firstLower] == "**js"){
        file.create("pipeRun.js")
        writeLines(as.character(firstRange), con = "pipeRun.js", sep = "\n", useBytes = FALSE)
        processedData <<- shell("node pipeRun.js")
        file.remove("pipeRun.js")
      }
      if(script[firstLower] == "**R"){
        
      }
      if(script[firstLower] == "**python"){
        file.create("pipeRun.py")
        writeLines(as.character(firstRange), con = "pipeRun.py", sep = "\n", useBytes = FALSE)
        processedData <<- shell("python pipeRun.py", intern = T)
        file.remove("pipeRun.py")
        print("this is the python processed data")
        print(processedData)
      }
      
      # Find second lanaguge and then run it
      
      if(script[secondLower] == "**js"){
        
      }
      if(script[secondLower] == "**R"){
        file.create("pipeRun.R")
        writeLines(as.character(secondRange), con = "pipeRun.R", sep = "\n", useBytes = FALSE)
        outputData <<- shell(paste(paste0(Sys.getenv("R_HOME"), "/bin/Rscript.exe", collapse =""), "pipeRun.R" , processedData), intern = T)
        file.remove("pipeRun.R")
        outputData <<- strsplit(outputData, "")[[1]][5:length(strsplit(outputData,"")[[1]])] # removes a [1]__ from the front of the output
        print("THis is the R processed data")
        print(outputData)
      }
      if(script[secondLower] == "**python"){
        
      }
      
    }
  }
}

master <- function(){
  for(i in 1:length(script)){
    headTag <- strsplit(script[i], " ")[[1]]
    
    #Process function call
    if(headTag[1] = "**"){ #function decloration syntax
      
      #Run function
      funcName <- headTag[2]
      allBoundsIndex <- match(funcName, allbounds[,3])
    }
  }
}

