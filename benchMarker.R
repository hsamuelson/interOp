#
# Henry Samuelson
#
# Benchmarker for development

benchMark <- function() {
  averg <- numeric()
  for(i in 1:10){
    sysTime <- Sys.time()
    master()
    sysTime_finish <- Sys.time()
    difference <- sysTime_finish - sysTime
    #averg = ((averg + (difference/i))/2)
    print(difference)
    averg[i] <- difference
  }
  return(mean(averg))
  
}
