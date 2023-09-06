##postprocessing TSQuant results##
##Ruofan Yu 04172023##

library(tidyr)

#extract files with needed info, in*594CYcoloc.txt files
pwd <- "/Volumes/Restricted/04202023MUT/result/60/rad21"

#pwd <- "/Users/ruofany/OneDrive/affair/2021nucspeckle/myData/ImageProcessed/04202022DNA_FISH"

setwd(pwd)
info <- list.files(path= pwd,recursive = TRUE,pattern = "CY3spot.txt")

#specify columns needed

#define column name here

Dist <- "Intensity_MeanIntensity_howfarfromSPEC"
neededcol <- c(Dist)

#initialize output
mat = matrix(ncol = 0, nrow = 0)
finaldat <- data.frame(mat)

for (i in 1:length(info))
{
  print(info[i])
  #read and extract needed columns
  dat <- read.delim(file = info[i], header = TRUE,check.names = FALSE)
  dat <- dat[,neededcol]
  name <- paste(basename(dirname(info[i])),strsplit(basename(info[i]), "[_]")[[1]][1],sep="_")
  dat2 <- as.data.frame(dat)
  dat2$file <- rep(name,each=nrow(dat))
  #count distance from pixel, for 60x it is *0.11
  dat2$dat <- dat2$dat*0.11
  #max distance allowed
  dat2 <- dat2[!dat2$dat > 2.5,]
  #append to final output
  finaldat <-rbind(finaldat,dat2)
}


write.table (finaldat, file = "finaldat.txt", sep = "\t", row.names=FALSE, col.names = TRUE, quote = FALSE)
