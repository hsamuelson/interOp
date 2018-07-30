#
# Henry Samuelson 7/30/18
#
# This is the core of the data type reader

# This will be used to process 
#This should be passed headTag[1] & headTag[2] from processRequest()

# Language is the language
# Var Type is the defined 
dataType <- function(language, varType, fileName, writtenScript){
  if(language == "**R"){
    if(varType == "simple"){
      # Do nothing this is already handled.
    } else if(varType == "matrix"){
      
    } else {
      return("NOT A VALID DATA TYPE")
    }
  }
  if(language == "**R"){
    if(varType == "simple"){
      
    }
    if(varType == "matrix"){
      
    }
  }
  if(language == "**R"){
    if(varType == "simple"){
      
    }
    if(varType == "matrix"){
      
    }
  }
}