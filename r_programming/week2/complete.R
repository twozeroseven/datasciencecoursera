complete <- function(directory = "/Users/twozeroAir/Documents/projects/datasciencecoursera/week2/specdata", id = 1:332) {
  total <- data.frame(id=numeric(),nobs=numeric())
  
  files <- vector()
  
  padNum <- function(num){
    formatC(num,width=3,format = "d", flag = "0")
  }
  
  for(i in id)
  {
    fullPath <- paste(paste(directory,padNum(i),sep = '/'),".csv",sep = '') 
    total <- rbind(total, data.frame(id = i, nobs = NROW(na.omit(read.csv(fullPath)))))
  }
  total
}
