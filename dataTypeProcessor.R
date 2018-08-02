#
# Henry Samuelson 7/30/18
#
# This is the core of the data type reader

# This will be used to process 
#This should be passed headTag[1] & headTag[2] from processRequest()

# Language is the language
# Var Type is the defined var type say matrix
# fileName will be the file to write the lines to
# varName is the universal var name

dataType <- function(language, varType, fileName, varName = 0 ){
  if(!varName == 0 ){ # If there is no varName just return it must mean the simple tag is being used.
    if(language == "**R"){
      if(varType == "simple"){
        # Do nothing this is already handled.
        return("")
      } else if(varType == "matrix"){
        #print("dataType Matrix achived")
        # Call standard R code to export to matrix
        
        # The file that will be run will be comprized of 3 chunks
        
        #1st chunk
          # This will be generated with processFunction(). This is all that will be run if
          # the "simple" data type is applied.
          # The first chunk will be spliced on within processFunction()
        
        #2nd chunk
          # This will be the default sticher between the 1st and 3rd chunk and will 
          # provide var transfer.
        
        #3rd chunk
          # This will be the generic code at the end that will export givin the language to a .csv
        
        ### These will be the two default vars passed to the default scripts ###
        midSlice <- paste("m_out <-", varName)
        midSlice <- as.matrix(rbind(as.matrix(midSlice), as.matrix(paste("m_out_name <- substitute(", varName, ")"))))
        #cat("midslice", midSlice)
        ### ----- ###
        
        endSplice <- suppressWarnings(readLines("dataTypes/matrix/r.txt")) #This triggerss a warning but not an concern
        endSplice <- as.matrix(endSplice)
        #cat("end slice", endSplice)
        return(as.matrix(rbind(midSlice, endSplice)))
        
      } else if(varType == "image"){
        
      } else {
        return("NOT A VALID DATA TYPE") ## THIS needs to actually be handled later with process function.
      }
    }
    if(language == "**js"){
      if(varType == "simple"){
        # Do nothing this is already handled.
      } else if(varType == "matrix"){
        
      } else if(varType == "image"){
        
      } else {
        return("NOT A VALID DATA TYPE")
      }
    }
  }
}


