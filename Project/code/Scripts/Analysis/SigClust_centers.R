#!/usr/bin/env Rscript

# Script Name: SigClust_centers.R
# Author: Sam Smith
# Description: This Script finds cluster centers using a pairwise matrix

###############################
### Load in data & packages ###
###############################

library(patchwork)
library(tidyr)
library(dplyr)
library(ggplot2)
library(cluster)

barcodes <- read.csv("../data/Other/barcodes.csv")
seqnames <- barcodes$X

pairwisematrix <- read.csv("../data/PairwiseMatrices/PairwiseMatrix_k2p.csv", row.names = 1)
pairwisematrix <- pairwisematrix[seqnames, seqnames]

Site100 <- read.csv("../data/Other/SITE-100 Database - mitogenomes.csv")
Site100 <- Site100[Site100$mt_id %in% rownames(pairwisematrix), ]

#############################
### Find SigClust Centers ###
#############################

no_clusters <- c(50,200,500)
sigclustK <- c(4,5,6,7,10,15,20,25)

for (y in no_clusters){
  for (i in sigclustK) {
    
    centers <- c()
    
    sigclusts <- read.csv(paste("../data/SigClusters/SigClust_output/COX1_", y, "_k", i, ".csv", sep = ""), header = FALSE)
    pairwisematrix$clusters <- sigclusts$V2
    
    unique_clusters <- unique(pairwisematrix$clusters)
    
    for (j in unique_clusters) {
      cluster_sequences <- rownames(pairwisematrix[pairwisematrix$clusters == j,])
      df <- pairwisematrix[cluster_sequences, cluster_sequences, drop = FALSE] # subset pairwise matrix
      
      df$clusters <- NULL
      row_averages <- rowMeans(df, na.rm = TRUE)
      
      most_similar_index <- which.max(row_averages)
      most_similar_observation <- rownames(df)[most_similar_index]
      
      centers <- c(centers, most_similar_observation)
      
      centers_name <- paste("Centers_", y, "_k", i, sep = "")
      assign(centers_name, centers)
  
      subset_name <- paste("Site100_", y, "_k", i, sep = "")
      assign(subset_name, Site100[Site100$mt_id %in% centers, ])
      pairwise_submatrix <- pairwisematrix[centers,centers, drop = FALSE]
      
      write.table(centers, file = paste("../data/SigClusters/Cluster_centers/", y, "_k2p_k", i , "_centers.txt", sep = ""), row.names = FALSE, col.names = FALSE, quote = FALSE)
      write.csv(pairwise_submatrix, file = paste("../data/SigClusters/Center_PMs/K2P_", y, "_k",i,".csv", sep = ""))
      
    }
  }
}

################################
### Cluster Content Analysis ###
################################

### Find Average no of taxa in each cluster for different kmer values ###
average_diff_no_taxa <- function(taxa){
  kmers <- 3:25
  results <- list()
  
  for (y in no_clusters) {
    averages <- c()
    for (i in kmers) {
      file_path <- paste("../data/SigClusters/SigClust_output/COX1_", y, "_k", i, ".csv", sep = "")
      sigclusts <- read.csv(file_path, header = FALSE)
      
      pairwisematrix$clusters <- sigclusts$V2
      unique_clusters <- unique(pairwisematrix$clusters)
      n_taxa <- c()
      
      for (j in unique_clusters) {
        cluster_sequences <- rownames(pairwisematrix[pairwisematrix$clusters == j, ])
        Site100_cluster <- Site100[Site100$mt_id %in% cluster_sequences, ]
        
        no_different_taxa <- length(unique(Site100_cluster[[taxa]]))
        n_taxa <- c(n_taxa, no_different_taxa)
      }
      
      averages <- c(averages, mean(n_taxa))
    }
    
    results[[y]] <- averages
  }
  
  df <- data.frame(kmers)
  for (y in no_clusters) {
    df[as.character(y)] <- results[[y]]
  }
  df <- df %>%
    pivot_longer(cols = c(2,3,4), 
                 names_to = "cluster", 
                 values_to = "average")
  df <- df_long %>%
    mutate(cluster = factor(cluster, levels = c("50", "200", "500")))
  
  return(df)
}

df_infra <- average_diff_no_taxa("infraorder")
df_super <- average_diff_no_taxa("superfamily")

write.csv(df_infra, "../data/SigClusters/Cluster_centers/Av_no_infra.csv")
write.csv(df_super, "../data/SigClusters/Cluster_centers/Av_no_super.csv")

### Average number of taxa in each cluster for different no. clusters ###

kmer <- 5
clusters <- seq(5, 500, 5)

av_taxa_clust <- function(taxa){
  averages <- c()
  for (i in clusters){
    
    sigclusts <- read.csv(paste("../data/SigClusters/SigClust_output/COX1_", i, "_k5.csv", sep = ""), header = FALSE)
    pairwisematrix$clusters <- sigclusts$V2
    unique_clusters <- unique(pairwisematrix$clusters)
    n_taxa <- c()
    
    for (j in unique_clusters) {
      cluster_sequences <- rownames(pairwisematrix[pairwisematrix$clusters == j, ])
      Site100_cluster <- Site100[Site100$mt_id %in% cluster_sequences, ]
      
      no_different_taxa <- length(unique(Site100_cluster[[taxa]]))
      n_taxa <- c(n_taxa, no_different_taxa)
    }
    averages <- c(averages, mean(n_taxa))
  }
  dataframe <- data.frame(clusters, averages)
}

df_super_clust <- av_taxa_clust("superfamily")
df_infra_clust <- av_taxa_clust("infraorder")

write.csv(dataframe, "../data/SigClusters/Cluster_centers/Av_super_clust.csv")
write.csv(df_infra_clust, "../data/SigClusters/Cluster_centers/Av_infra_clust.csv")




