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
      ### These will be the two default vars passed to the default scripts ###
      midSlice <- paste("m_out <-", varName)
      midSlice <- as.matrix(rbind(as.matrix(midSlice), as.matrix(paste("m_out_name <- substitute(", varName, ")"))))
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
        
        endSplice <- suppressWarnings(readLines("dataTypes/matrix/r.txt")) #This triggerss a warning but not an concern
        endSplice <- as.matrix(endSplice)
        #cat("end slice", endSplice)
        return(as.matrix(rbind(midSlice, endSplice)))
        
      } else if(varType == "image"){
        
        endSplice <- suppressWarnings(readLines("dataTypes/image/r.txt")) #This triggerss a warning but not an concern
        endSplice <- as.matrix(endSplice)
        
        return(as.matrix(rbind(midSlice, endSplice)))
      } else {
        return("NOT A VALID DATA TYPE") ## THIS needs to actually be handled later with process function.
      }
    }
    if(language == "**python"){
      
      # These are here because they are used for all data types
      midSlice <- as.matrix(paste("m_out =", varName))
      mid_two <- as.matrix(paste("def namestr(obj, namespace):"))
      mid_three <- as.matrix(paste("   return [name for name in namespace if namespace[name] is obj]"))
      mid_four <- as.matrix(paste("m_out_name = ", paste0("namestr(", varName, ", globals())" )))
      midSlice <- as.matrix(rbind(midSlice, mid_two, mid_three, mid_four))
      if(varType == "simple"){
        # Do nothing this is already handled.
        return("")
      } else if(varType == "matrix"){
        
        endSplice <- suppressWarnings(readLines("dataTypes/matrix/python.txt")) #This triggerss a warning but not an concern
        endSplice <- as.matrix(endSplice)
        return(as.matrix(rbind(midSlice, endSplice)))
        
      } else if(varType == "image"){
        endSplice <- suppressWarnings(readLines("dataTypes/image/python.txt")) #This triggerss a warning but not an concern
        endSplice <- as.matrix(endSplice)
        return(as.matrix(rbind(midSlice, endSplice)))
      } else {
        return("NOT A VALID DATA TYPE")
      }
    } else if(language == "**java"){
      if(varType =="matrix"){
        #NOTES
          # When writing a java module in an interOP file one must write "printCSV();" after the final change of the matrix being returned. See wrapper.interOp for example. 
          # There Is a 0th chunk for languages that require imports to print to CSV
          # Java modules cant just be stiched together because of the class thing. A "}" must be removed and then the function can be added. Then the "}" will be placed at the end again.

        #0th chunk
          #This is for imports it will be placed before the class is declared. it is also in the processRequest File


        midSlice <-"public static void printCSV(String[][] m){  String[][] m_out = m;"
        midSlice <- as.matrix(rbind(as.matrix(midSlice), as.matrix(paste('
            String m_out_name = "',varName,'";'))))


        endSplice <- suppressWarnings(readLines("dataTypes/matrix/java.txt")) #This triggerss a warning but not an concern
        endSplice <- as.matrix(endSplice)

      return(as.matrix(rbind(midSlice, endSplice)))
      }
    }
  }
}


