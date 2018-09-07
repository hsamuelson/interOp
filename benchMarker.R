#
# Henry Samuelson
#
# Benchmarker for development

benchMark <- function() {
  #source("cleanEnvFile.R")
  averg <- numeric()
  for(i in 1:10){
    sysTime <- Sys.time()
    master()
    sysTime_finish <- Sys.time()
    difference <- sysTime_finish - sysTime
    #averg = ((averg + (difference/i))/2)
    #cleanEnv() # cleans advanced data types 
    #cleanVars() 
    #print(difference)
    averg[i] <- difference
  }
  cat("Average time over ", i, " steps is:")
  return(mean(averg))
  
}
