library(tools)
arguments = commandArgs(trailingOnly = TRUE)
# use the first argument!
TreeData <- read.csv(arguments[1])

# function working out height
TreeHeight <- function(degrees, distance) {
  radians <- degrees * pi / 180
  height <- distance * tan(radians)
  # print(paste("Tree height is:", height))
  return (height)
}

TreeData$Height <- TreeHeight(TreeData$Angle.degrees,TreeData$Distance.m)

# remove filepath and extension
output_name <- filename_without_path_and_ext <- file_path_sans_ext("../data/trees.csv")
output_name <- basename(output_name)

name <- paste("../results/",output_name,"_treeheights.csv", sep = "")
write.csv(TreeData,name)



