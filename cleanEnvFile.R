#
# Henry Samuelson 8/9/18
#
# This runner cleans out the leftver matrix and image fils that are left behind
# in the "session" 

# These use the library(tools) but is called in interpreter
cleanEnv <- function() {
  fileList <- list.files()
  for(i in 1:length(fileList)){
    if(fileList[i] != "logos.png"){
      extension <- file_ext(fileList[i])
      if(extension == "png" || extension == "csv" || extension == "jpg"){
        file.remove(fileList[i])
      }
    }
  }
}
#
#8/17/18 This removes all module files at the end becasue we do not want to have to rewrite them till the end.
# In this update files will not be deleted within the processesFunc() module, instead they will be here.

# *KEY NOTE* for languages like java, C languages, or rust that need to first be compiled, should still delete
# their inital files in processFunct() and only save their executable files.
cleanVars <- function(){
  filesNames <- list.files()
  for(i in 1:length(filesNames)){
    if(file_path_sans_ext(filesNames[i]) %in% allbounds){
      file.remove(filesNames[i])
    }
  }
}

