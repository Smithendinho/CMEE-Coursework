################
### packages ###
################

library(flexclust)
library(cluster)

##################
## import data ###
##################

barcodes <- read.csv("../data/Other/barcodes.csv", row.names = 1)
seqnames <- rownames(barcodes)

pairwisematrix <- read.csv("../data/PairwiseMatrices/PairwiseMatrix_k2p.csv", row.names = 1)
pairwisematrix <- pairwisematrix[as.character(seqnames), as.character(seqnames)]

##########################
### k means clustering ###
##########################

data_scaled <- scale(pairwisematrix) # scaling data, necessary for k-means 

kmeans_50_k2p <- kmeans(data_scaled, centers = 50, nstart = 10)
save(kmeans_50_k2p, file = "../data/Other/kmeans_50_k2p.RData")

kmeans_100_k2p <- kmeans(data_scaled, centers = 100, nstart = 10)
save(kmeans_100_k2p, file = "../data/Other/kmeans_100_k2p.RData")

##################################################################  
### Find the observation closest to the center of the clusters ###
##################################################################

kmeans_50 <- load("../data/Other/kmeans_50_k2p.RData")
kmeans_100 <- load("../data/Other/kmeans_100_k2p.RData")

cluster_centers <- function(kmeans_result){
  
  centers <- kmeans_result$centers
  data_matrix <- as.matrix(data_scaled)
  
  distances <- as.matrix(dist(rbind(centers, data_matrix),method = "euclidean"))
  distances <- distances[-(1:nrow(centers)), 1:nrow(centers)]
  
  closest_observations <- integer(nrow(centers))
  
  used_indices <- integer(0)
  
  for (i in 1:nrow(centers)) {
    sorted_indices <- order(distances[, i])
    
    for (index in sorted_indices) {
      if (!(index %in% used_indices)) {
        closest_observations[i] <- index
        used_indices <- c(used_indices, index)
        break
      }
    }
  }
  
  submatrix_2 <- pairwisematrix[closest_observations, closest_observations]
  return(submatrix_2)
}

submatrix_50_k2p <- cluster_centers(kmeans_50_k2p)
write.csv(submatrix_50_k2p, "../data/PairwiseMatrices/pm_k2p_50.csv")

submatrix_100_k2p <- cluster_centers(kmeans_100_k2p)
write.csv(submatrix_100_k2p, "../data/PairwiseMatrices/pm_k2p_100.csv")

###################
### Cluster IDs ###
###################

cluster_center_ids <- colnames(submatrix_50_k2p_sigclusts)
write.table(cluster_center_ids, "../data/Cluster_center_IDs.txt", col.names = FALSE, row.names = FALSE, quote = FALSE)
