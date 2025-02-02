one_twenty <- read.table("../data/TreeBuilding/backbone_120_ids.txt")
Cluster_centers <- read.table("../data/SigClusters/Cluster_centers/200_k2p_k5_centers.txt")

# Extract the values as vectors
values1 <- one_twenty[, 1]
values2 <- Cluster_centers[, 1]

# Combine the values and remove duplicates
combined_values <- unique(c(values1, values2))

# Write the unique values to a new text file
write.table(combined_values, "../data/Other/combined_unique_values.txt", row.names = FALSE, col.names = FALSE, quote = FALSE)
