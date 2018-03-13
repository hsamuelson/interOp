#
# Henry Samuelson
# 
# This is the main parser. This is used to read through the file and call the respective libraries
# 

script <- read.delim("mainScript")
if(colnames(script) != "X.Parser."){ return("INVALID HEADING")}


script <- readLines("mainScript.txt")
# From loading from a file have to conver to table matrix
script <- as.matrix(script)

# takes the processed script as input
findBounds <- function(script, startingVal = 1){
  lowerBound <- 0
  upperBound <- 0
  
  for(i in startingVal:length(script[,1])){
    if(script[i,] == "**R" || script[i,] == "**python" || script[i,] == "**js"){
      lowerBound <- i
      for(j in i:length(script[,1])){
        if(script[j,] == "**/"){
          upperBound <- j
          return(c(lowerBound, upperBound))
        }
      }
    }
  }
}

# T
processBounds <- function(){
  counter <- 1
  bounds <- c("lower", "upper")
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

getScriptBit <- function(boundz){
  
}


#Send Processing calls 

allbounds <- processBounds()
titleRows <- as.integer(allbounds[,1])
for(i in 1:length(titleRows)){
  w <- script[(as.integer(allbounds[i,1])+1):(as.integer(allbounds[i,2])- 1),]
  
  if(script[titleRows[i],] == "**R"){
    # Write to file and run
    file.create("runner.R")
    writeLines(as.character(w), con = "runner.R", sep = "\n",  useBytes = FALSE) # auto indents lines
    result <- shell(paste(paste0(Sys.getenv("R_HOME"), "/bin/Rscript.exe", collapse =""), "runner.R"))
    file.remove("runner.R")
    print(result)
  }
  if(script[titleRows[i],] == "**python"){
    # Write to file and run
    file.create("runner.py")
    writeLines(as.character(w), con = "runner.py", sep = "\n",  useBytes = FALSE) 
    result <- shell("python runner.py")
    file.remove("runner.py")
    print(result)
  }
  if(script[titleRows[i],] == "**js"){
    file.create("runner.js")
    writeLines(as.character(w), con = "runner.js", sep = "\n", useBytes = FALSE)
    result <- shell(paste("node runner.js"))
    file.remove("runner.js")
  }
}

