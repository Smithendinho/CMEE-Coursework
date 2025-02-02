# Load Data Set
MyData <- as.matrix(read.csv("../data/PoundHillData.csv", header = FALSE))
MyMetaData <- read.csv("../data/PoundHillMetaData.csv", header = TRUE, sep = ";")

# Inspect Data Set
head(MyData)
dim(MyData)
str(MyData)
fix(MyData) 
fix(MyMetaData)

# Transpose Data Set
MyData <- t(MyData) 
head(MyData)
dim(MyData)

# Replace Absent Species with 0
MyData[MyData == ""] = 0

# Convert Matrix to Data Frame
TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F) 
colnames(TempData) <- MyData[1,] 

# Tidyverse replacement code:

library(dplyr)
library(plyr)
library(ggplot2)
library(tidyr)

MyWrangledData <- TempData %>%
  pivot_longer( # pivot longer is a newer function than gather(), they both do the same thing!
    
    cols = -c(Cultivation, Block, Plot, Quadrat),
    names_to = "Species",
    values_to = "Count"
  ) %>%
  mutate(
    Cultivation = as.factor(Cultivation),
    Block = as.factor(Block),
    Plot = as.factor(Plot),
    Quadrat = as.factor(Quadrat),
    Count = as.integer(Count)
  )

View(MyWrangledData)
str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

