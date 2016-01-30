corr <- function(directory = "/Users/twozeroAir/Documents/projects/datasciencecoursera/week2/specdata", threshold = 0)
{
  f_corr <- function(fname) {
    data <- read.csv(file.path(directory, fname))
    nob <- sum(complete.cases(data))
    
    if (nob > threshold) {
      return (cor(data$nitrate, data$sulfate, use="complete.obs"))
    }
  
    }
  f_corr <- sapply(list.files(directory), f_corr) 
  f_corr <- unlist(f_corr[!sapply(f_corr, is.null)]) 
  return (f_corr)
  
}