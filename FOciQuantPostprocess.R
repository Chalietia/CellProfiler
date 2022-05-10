##postprocessing TSQuant results##
##Ruofan Yu 02102022##

library(tidyr)

#extract files with needed info, in*594CYcoloc.txt files
pwd <- "/Volumes/Classified/Image/04222022dnafishplasmid/result"

#pwd <- "/Users/ruofany/OneDrive/affair/2021nucspeckle/myData/ImageProcessed/04202022DNA_FISH"
setwd(pwd)
info <- list.files(path= pwd,recursive = TRUE,pattern = "CY3spot.txt")
info <- list.files(path= pwd,recursive = TRUE,pattern = "CY3spotYFP.txt")
#specify columns needed

neededcol <- c(  "Neighbors_FirstClosestDistance_SpeckleFinal_Expanded", "Children_preNucleiWithEdges_Count","Mean_preNucleiWithEdges_Intensity_MedianIntensity_CY3")
#neededcol <- c(  "Neighbors_FirstClosestDistance_SpeckleYFP_Expanded", "Children_YFPposNuc_Count","Mean_YFPposNuc_Location_Center_X")
#initialize output
mat = matrix(ncol = 0, nrow = 0)
finaldat <- data.frame(mat)


#go over each data to process
for (i in 1:length(info))
{
  print(info[i])
  #read and extract needed columns
  dat <- read.delim(file = info[i], header = TRUE,check.names = FALSE)
  dat <- dat[,neededcol]
  dat2 <- dat
  #remove items with child count as 0 (don't have associated nuclei) until reach 1
  #dat2 <- dat2[!cumsum(dat2$Children_preNucleiWithEdges_Count == 1) < 2,]
  dat2 <- dat2[!cumsum(dat$Children_YFPposNuc_Count == 1) < 2,]
  
  #loop through dataframe to append nuc intensity for nan item
  
  for (r in 1:nrow(dat2)) 
  {
    query <- dat2[r,"Mean_YFPposNuc_Location_Center_X"]
    #assign value of r-1 if query= nan
    if(query == "NaN")
      dat2[r,"Mean_YFPposNuc_Location_Center_X"] <- dat2[r-1,"Mean_YFPposNuc_Location_Center_X"]  
  }
  red <- rle(as.character(dat2$Mean_YFPposNuc_Location_Center_X))
  #add repetition column to data and remove any cells with more than 6 ts. 
  #I set it larger than 4 because some cancer will have more duplication.
  dat2$counter <- rep(red$lengths,red$lengths)
  
  dat3 <- dat2[!dat2$counter > 2,]
  #calculate distance by multiply pixel/nm, remove any points larger than N.
  
  #dat3<-dat2
  dat3$dist <- dat3$Neighbors_FirstClosestDistance_SpeckleYFP_Expanded*0.11
  dat3 <- dat3[!dat3$dist > 5,]
  #calculate normalized ts intensity
  #dat3$normTSintensity <- dat3$Intensity_MedianIntensity_A594corrected/dat3$Mean_Nuclei_Intensity_MedianIntensity_A594corrected
  dat4 <- dat3[,c("dist", "counter")]
  #add id to cells
  id=1
  idcount = character(0) 
  for (j in 1:nrow(dat3)) 
  {
    if (dat3$counter[j]==1) 
    {
      id=id+1
      idcount <- append(idcount,id)
    }
    else 
    {
      idcount <- append(idcount,id)
    }
  }
  dat3$CellID <- idcount
   
  #add row with filename for identification
  #dat4 <- dat3[,c("dist","normTSintensity","counter")]
  #extract sample name before _ and add immediate folder name
  name <- paste(basename(dirname(info[i])),strsplit(basename(info[i]), "[_]")[[1]][1],sep="_")
  dat4$file <- rep(name,each=nrow(dat4))
  #append to final output
  finaldat <-rbind(finaldat,dat4)
} 
#reorder
positions <- c("6hrdmso","6hraux","3hrdmso","3hraux","dmso0min","aux0min")
positions <-levels(factor(finaldat$file))
finaldat$file <- factor(finaldat$file, levels = positions)          

write.table (finaldat, file = "finaldat.txt", sep = "\t", row.names=FALSE, col.names = TRUE, quote = FALSE)
