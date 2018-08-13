#
# Henry Samuelson 8/9/18
#
# This runner cleans out the leftver matrix and image fils that are left behind
# in the "session" 

if (!require("tools")) install.packages("tools", repos='http://cran.us.r-project.org')
library(tools)
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

