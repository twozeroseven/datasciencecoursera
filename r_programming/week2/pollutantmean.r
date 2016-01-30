pollutantmean <- function(directory = "/Users/twozeroAir/Documents/projects/datasciencecoursera/week2/specdata", pollutant, id = 1:332) {
  total = data.frame(Date=as.Date(character()), sulfate = numeric(0), nitrate = numeric(0))
  files <- vector()
  
  padNum <- function(num){
    formatC(num,width=3,format = "d", flag = "0")
  }
  
  for(i in id)
  {
    fullPath <- paste(paste(directory,padNum(i),sep = '/'),".csv",sep = '') 
    files <- c(files,fullPath)
  }
  total <- do.call("rbind", lapply(files, read.csv, header = TRUE))
  
  mean(na.omit(total[[pollutant]]))
}