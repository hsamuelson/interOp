source("dataTypeProcessor.R")
processFunction <- function(indexIn, argument = ""){
  
  # This is the text from whatever the imported function is:
  w <- script[(as.integer(allbounds[indexIn,1])+1):(as.integer(allbounds[indexIn,2])- 1),]
  
  # This function creates unique file names to allow functions to 
  # run muiltiple functions in the same language in parallel
  uniqueFileName <- function(extension = 0){
    fileName <- strsplit(script[titleRows[indexIn],], " ")[[1]][2]
    #print(fileName)
    if(extension == 0) {return(fileName)}
    else {return(paste0(fileName, extension, collapse = ""))}
  }
  
  # Main Tag will be the langauge identiy of the given function to
  # determine what runner we will need to call
  mainTag <- strsplit(script[titleRows[indexIn],], " ")[[1]][1]
  
  #Check if file/function has alread been called / already exsists
  
  # This will be the actual var name that will be given to functions.
  exportVarName <- strsplit(script[titleRows[indexIn],], " ")[[1]][4]
  
  # If the file already exsists skip editing it
  # skipWrite <- 0
  # if(exportVarName %in% file_path_sans_ext(list.files())){
  #   skipWrite <- 1
  # }
  
  if(mainTag == "**R"){
    # Write to file and run
    fileName <- uniqueFileName(".R")
    
    #First check to see if the file has already been generated earlier
    # If not run the file generation process
    # If it exsists simplily run the script with the argument
    if(file.exists(fileName)){
      result <- shell(paste(paste0(Sys.getenv("R_HOME"), "/bin/Rscript.exe", collapse =""), fileName, argument), intern = T)
      return(result)
      # The program should'nt get past this point if the file does exsist so we don't need an else{} statement
    } 
    
    # First make sure a name actually exsists
    # If not just write the regular file
    if(is.na(exportVarName)) {
      wFinal <- w
    } else {
      tail <- dataType(language = "**R", varType =  allbounds[indexIn,4], fileName = fileName, varName = exportVarName)
      wFinal <- as.matrix(rbind(as.matrix(w), as.matrix(tail)))
    }
    
    writeLines(as.character(wFinal), con = fileName, sep = "\n",  useBytes = FALSE) # auto indents lines
    result <- shell(paste(paste0(Sys.getenv("R_HOME"), "/bin/Rscript.exe", collapse =""), fileName, argument), intern = T)
    # Call dataType Processorn to test data types
    
    #file.remove(fileName)
    return(result)
    # Not sure if this is still needed bc it might be solved by the matrix data type
    # return(substring(result, 5,1000000L)) # This removes the [1] R console prefix that will mess up other funct args
  }
  if(mainTag == "**python"){
    # Write to file and run
    fileName <- uniqueFileName(".py")
    
    if(file.exists(fileName)){
      result <- shell(paste("python", fileName, argument), intern = T)
      return(result)
    }
    if(is.na(exportVarName)) {
      wFinal <- w
    } else {
      tail <- dataType(language = "**python", varType =  allbounds[indexIn,4], fileName = fileName, varName = exportVarName)
      wFinal <- as.matrix(rbind(as.matrix(w), as.matrix(tail)))
    }
    writeLines(as.character(wFinal), con = fileName, sep = "\n",  useBytes = FALSE) 
    result <- shell(paste("python", fileName, argument), intern = T)
    #file.remove(fileName)
    return(result)
    
  }
  if(mainTag == "**js"){
    fileName <- uniqueFileName(".js")
    
    if(file.exists(fileName)){
      result <- shell(paste("node", fileName, argument), intern = T)
      return(result)
    }
    if(is.na(exportVarName)) {
      wFinal <- w
    } else {
      tail <- dataType(language = "**js", varType =  allbounds[indexIn,4], fileName = fileName, varName = exportVarName)
      wFinal <- as.matrix(rbind(as.matrix(w), as.matrix(tail)))
    }
    writeLines(as.character(wFinal), con = fileName, sep = "\n", useBytes = FALSE)
    result <- shell(paste("node", fileName, argument), intern = T)
    #file.remove(fileName)
    return(result)
  }
  if(mainTag == "**lua"){
    fileName <- uniqueFileName(".lua")
    
    if(file.exists(fileName)){
      result <- shell(paste("lua", fileName, argument), intern = T)
      return(result)
    }
    if(is.na(exportVarName)) {
      wFinal <- w
    } else {
      tail <- dataType(language = "**lua", varType =  allbounds[indexIn,4], fileName = fileName, varName = exportVarName)
      wFinal <- as.matrix(rbind(as.matrix(w), as.matrix(tail)))
    }
    writeLines(as.character(wFinal), con = fileName, sep = "\n", useBytes = FALSE)
    result <- shell(paste("lua", fileName, argument), intern = T)
    #file.remove(fileName)
    return(result)
  }
  if(mainTag == "**go"){
    fileName <- uniqueFileName(".go")
    
    if(file.exists(fileName)){
      result <- shell(paste("go run", fileName, argument), intern = T)
      return(result)
    }
    
    if(is.na(exportVarName)) {
      wFinal <- w
    } else {
      tail <- dataType(language = "**go", varType =  allbounds[indexIn,4], fileName = fileName, varName = exportVarName)
      wFinal <- as.matrix(rbind(as.matrix(w), as.matrix(tail)))
    }
    writeLines(as.character(wFinal), con = fileName, sep = "\n", useBytes = FALSE)
    result <- shell(paste("go run", fileName, argument), intern = T)
    #file.remove(fileName)
    return(result)
  }
  if(mainTag == "**Elixir"){
    fileName <- uniqueFileName(".exs")
    
    if(file.exists(fileName)){
      result <- shell(paste("elixir", fileName, argument), intern = T)
      return(result)
    }
    
    if(is.na(exportVarName)) {
      wFinal <- w
    } else {
      tail <- dataType(language = "**Elixir", varType =  allbounds[indexIn,4], fileName = fileName, varName = exportVarName)
      wFinal <- as.matrix(rbind(as.matrix(w), as.matrix(tail)))
    }
    writeLines(as.character(wFinal), con = fileName, sep = "\n", useBytes = FALSE)
    result <- shell(paste("elixir", fileName, argument), intern = T)
    #file.remove(fileName)
    return(result)
  }
  if(mainTag == "**bat"){
    fileName <- uniqueFileName(".bat")
    
    if(file.exists(fileName)){
      result <- shell(paste(fileName, argument), intern = T)
      try(
        for(i in 1:length(result)){  #This is to remove the spacing & console prompt output
          if(result[i] == ""){
            result = result[-(i:(i+1))]
          }
        },
        silent=TRUE)
      return(result)
    }
    
    if(is.na(exportVarName)) {
      wFinal <- w
    } else {
      tail <- dataType(language = "**bat", varType =  allbounds[indexIn,4], fileName = fileName, varName = exportVarName)
      wFinal <- as.matrix(rbind(as.matrix(w), as.matrix(tail)))
    }
    writeLines(as.character(wFinal), con = fileName, sep = "\n", useBytes = FALSE)
    result <- shell(paste(fileName, argument), intern = T)
    #file.remove(fileName)
    
    try(
      for(i in 1:length(result)){  #This is to remove the spacing & console prompt output
        if(result[i] == ""){
          result = result[-(i:(i+1))]
        }
      },
      silent=TRUE)
    return(result)
  }
  if(mainTag == "**rust"){
    fileName <- uniqueFileName(".rs")
    fileNameWithoutExtension <- uniqueFileName()
    #Before generating anything else check to see if it already exsists
    #If it does there is no point in recompiling the file
    #Simpily pass new args
    if(file.exists(fileName)){
      result <- shell(paste(paste0(fileNameWithoutExtension,".exe", collapse = ""), argument), intern = T)
      return(result)
    }
    
    if(is.na(exportVarName)) {
      wFinal <- w
    } else {
      tail <- dataType(language = "**rust", varType =  allbounds[indexIn,4], fileName = fileName, varName = exportVarName)
      wFinal <- as.matrix(rbind(as.matrix(w), as.matrix(tail)))
    }
    writeLines(as.character(wFinal), con = fileName, sep = "\n", useBytes = FALSE)
    shell(paste("rustc", fileName), intern = T)
    result <- shell(paste(paste0(fileNameWithoutExtension,".exe", collapse = ""), argument), intern = T)
    
    #file.remove(paste0(fileNameWithoutExtension,".exe", collapse = "")) # .rs files compile into .exe and .pdb which tha can be run
    file.remove(paste0(fileNameWithoutExtension,".pdb", collapse = "")) # leave this one bc this is the only executable
    #file.remove(fileName)
    return(result)
  }
  if(mainTag == "**ruby"){
    fileName <- uniqueFileName(".rb")
    
    if(file.exists(fileName)){
      result <- shell(paste("ruby", fileName, argument), intern = T)
      return(result)
    }
    
    if(is.na(exportVarName)) {
      wFinal <- w
    } else {
      tail <- dataType(language = "**ruby", varType =  allbounds[indexIn,4], fileName = fileName, varName = exportVarName)
      wFinal <- as.matrix(rbind(as.matrix(w), as.matrix(tail)))
    }
    writeLines(as.character(wFinal), con = fileName, sep = "\n", useBytes = FALSE)
    result <- shell(paste("ruby", fileName, argument), intern = T)
    #file.remove(fileName)
    return(result)
  }
  if(mainTag == "**perl"){
    fileName <- uniqueFileName(".pl")
    
    if(file.exists(fileName)){
      result <- shell(paste("perl", fileName, argument), intern = T)
      return(result)
    }
    
    if(is.na(exportVarName)) {
      wFinal <- w
    } else {
      tail <- dataType(language = "**perl", varType =  allbounds[indexIn,4], fileName = fileName, varName = exportVarName)
      wFinal <- as.matrix(rbind(as.matrix(w), as.matrix(tail)))
    }
    writeLines(as.character(wFinal), con = fileName, sep = "\n", useBytes = FALSE)
    result <- shell(paste("perl", fileName, argument), intern = T)
    #file.remove(fileName)
    return(result)
  }
  if(mainTag == "**dart"){
    fileName <- uniqueFileName(".dart")
    
    if(file.exists(fileName)){
      result <- shell(paste("dart", fileName, argument), intern = T)
      return(result)
    }
    
    if(is.na(exportVarName)) {
      wFinal <- w
    } else {
      tail <- dataType(language = "**dart", varType =  allbounds[indexIn,4], fileName = fileName, varName = exportVarName)
      wFinal <- as.matrix(rbind(as.matrix(w), as.matrix(tail)))
    }
    writeLines(as.character(wFinal), con = fileName, sep = "\n", useBytes = FALSE)
    result <- shell(paste("dart", fileName, argument), intern = T)
    #file.remove(fileName)
    return(result)
  }
  if(mainTag == "**java"){
    fileNameExtension <- uniqueFileName(".java")
    
    if(file.exists(fileNameExtension)){
      result <- shell(paste('"C:\\Program Files\\Java\\jdk1.8.0_171\\bin\\java.exe"', fileNameReg, argument), intern = T) #this runs the class file
      return(result)
    }
    
    fileNameReg <- uniqueFileName()

    if(is.na(exportVarName)) {
      wFinal <- w
    } else {
      wNew <- w[-length(w)]
      head <-suppressWarnings(readLines("dataTypes/matrix/javaImports.txt"))
      tail <- dataType(language = "**java", varType =  allbounds[indexIn,4], fileName = fileName, varName = exportVarName)
      withImports <- as.matrix(rbind(as.matrix(head), as.matrix(wNew)))
      wFinal <-as.matrix(rbind(as.matrix(withImports), as.matrix(tail)))
      
    }

    writeLines(as.character(wFinal), con = fileNameExtension, sep = "\n", useBytes = FALSE)
    shell(paste('"C:\\Program Files\\Java\\jdk1.8.0_171\\bin\\javac.exe"', fileNameExtension)) #needs to compile .class
    result <- shell(paste('"C:\\Program Files\\Java\\jdk1.8.0_171\\bin\\java.exe"', fileNameReg, argument), intern = T) #this runs the class file
   
    #file.remove(fileNameExtension)
    #file.remove(paste0(fileNameReg, ".class",collapse = ""))
    return(result)
  }
}

