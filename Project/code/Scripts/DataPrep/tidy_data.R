##############################
### Load Packages and Data ###
##############################

library(dplyr)
data <- read.csv("../data/Other/sequences.csv")
data <- subset(data, select = -Sequence)

###############################################################
### Combine identical genes written in lower and upper case ###
###############################################################

column_pairs <- list(
  c("COX1", "cox1"), c("COX2", "cox2"), c("COX3", "cox3"),
  c("ND1", "nad1"), c("ND2", "nad2"), c("ND3", "nad3"),
  c("ND4", "nad4"), c("ND4L", "nad4l"), c("ND5", "nad5"),
  c("ND6", "nad6"), c("ATP6", "atp6"), c("ATP8", "atp8"))

for (pair in column_pairs) {
  data[[pair[1]]][data[[pair[1]]] == ""] <- data[[pair[2]]][data[[pair[1]]] == ""]
}

######################################
### Remove lowercase gene columns ###
######################################

colnames(data)[which(colnames(data) == 'FileName')] <- 'MITO_ID'
data <- data %>% 
  select(which(!grepl("[a-z]", names(data))))

############################################
### Output mitoIDs of Complete Sequences ###
############################################

data[data == ""] <- NA
new_data <- data[complete.cases(data), ]
filepath <- "../data/Other/complete_mt_ids.txt"
writeLines(new_data$MITO_ID, filepath)

