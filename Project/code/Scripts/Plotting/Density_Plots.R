#!/usr/bin/env/Rscript

# Script Name: Density_Plots.R
# Author: Sam Smith

# Packages 
library(ggplot2)
library(effsize)

####################
### Load in Data ###
####################

barcodes <- read.csv("../data/Other/barcodes.csv")
seqnames <- barcodes$X

pairwisematrix <- read.csv("../data/PairwiseMatrices/PairwiseMatrix_k2p.csv", row.names = 1)
pairwisematrix <- pairwisematrix[as.character(seqnames), as.character(seqnames)]

diag(pairwisematrix) <- NA
data_values <- na.omit(as.vector(as.matrix(pairwisematrix)))

submatrix_50_k2p_kmeans <- read.csv("../data/PairwiseMatrices/pm_k2p_50.csv", row.names = 1)
submatrix_100_k2p_kmeans <- read.csv("../data/PairwiseMatrices/pm_k2p_100.csv", row.names = 1)

sigclustK <- c(4, 5, 6, 7, 10, 15, 20, 25)
c_values <- c(500 ,200, 50)

for (c_val in c_values) {
  for (k_val in sigclustK) {
    file_path <- sprintf("../data/SigClusters/Center_PMs/K2P_%d_k%d.csv", c_val, k_val)
    var_name <- sprintf("sm_sg_c%d_k%d", c_val, k_val)
    assign(var_name, read.csv(file_path, row.names = 1))
  }
}

##############################
### Plot K2P Distributions ###
##############################

density_plots <- function(pairwisematrix, ...) {
  arg_names <- as.list(substitute(list(...)))[-1L] # -1L excludes first argument
  
  submatrices <- list(...)
  
  combined_df <- data.frame(value = data_values, group = "Total Data Set")
  
  colors <- c("Total Data Set" = rgb(0, 0, 1, 0.5))
  fills <- c("Total Data Set" = rgb(0, 0, 1, 0.5))
  
  for (i in seq_along(submatrices)) {
    submatrix <- submatrices[[i]]
    diag(submatrix) <- NA
    submatrix_values <- na.omit(as.vector(as.matrix(submatrix)))
    
    group_label <- deparse(arg_names[[i]])
    combined_df <- rbind(combined_df, data.frame(value = submatrix_values, group = group_label))
    
    colors[[group_label]] <- rgb(1 - (i - 1) * 0.2, 0, i * 0.2, 0.5)
    fills[[group_label]] <- rgb(1 - (i - 1) * 0.2, 0, i * 0.2, 0.5)
  }
  
  p <- ggplot(combined_df, aes(x = value, fill = group, color = group)) +
    geom_density(alpha = 0.6, adjust = 1.7) +
    xlim(0.1, 0.5) +
    labs(title = "Distribution of Pairwise K2P scores for Cluster Centers versus Total Data Set",
         x = "K2P Scores", y = "Density") +
    scale_fill_manual(values = fills) + scale_color_manual(values = colors) +
    theme_classic() + theme(legend.title = element_blank(),
                            legend.position = c(0.8, 0.8))
  p <- print(p)
  return(p)
}

for (c in c_values) {
  for (k in sigclustK) {
    variable_name <- sprintf("sm_sg_c%d_k%d", c, k)
    
    sam <- paste(c, " Cluster Centers (K-mer: ",k, ")", sep = "")
    
    sm <- get(variable_name)
    
    png(paste("../plots/", variable_name, ".png", sep = ""))
    density_plots(pairwisematrix, sm)
    graphics.off()
  }
}

########################
### Plots for Report ###
########################

# 50 SigClust clusters (K-mer values: 5, 10, 15)

combined_df <- data.frame(value = data_values, group = "Total Data Set")

diag(sm_sg_c50_k5) <- NA
diag(sm_sg_c50_k10) <- NA
diag(sm_sg_c50_k15) <- NA

k5_values <- na.omit(as.vector(as.matrix(sm_sg_c50_k5)))
k10_values <- na.omit(as.vector(as.matrix(sm_sg_c50_k10)))
k15_values <- na.omit(as.vector(as.matrix(sm_sg_c50_k15)))

combined_values_df <- data.frame(
  value = c(k5_values, k10_values, k15_values),
  group = rep(c("Kmer: 5", "Kmer: 10", "Kmer: 15"), times = c(length(k5_values), length(k10_values), length(k15_values)))
)

combined_df <- rbind(combined_df, combined_values_df)

fills <- c("Total Data Set" = "darkgrey", "Kmer: 5" = "red", "Kmer: 10" = "green", "Kmer: 15" = "blue")
colors <- c("Total Data Set" = "darkgrey", "Kmer: 5" = "red", "Kmer: 10" = "green", "Kmer: 15" = "blue")

# Plot using ggplot2
png(filename = "../plots/sigClust_50.png", width = 800, height = 450)
ggplot(combined_df, aes(x = value, fill = group, color = group)) +
  geom_density(alpha = 0.6, adjust = 1.7) +
  xlim(0.1, 0.45) +
  labs(title = "Distribution of K2P Scores between 50 SigClust Centers",
       x = "K2P Scores", y = "Density") +
  scale_fill_manual(values = fills) +
  scale_color_manual(values = colors) +
  theme_classic() +
  theme(
    legend.position = c(0.85,0.8),
    text = element_text(family = "Times New Roman"),  # Adjust font family and size
    plot.title = element_text(face = "bold", size = 27),
    axis.title.x = element_text(size = 27),  # X-axis title font size
    axis.title.y = element_text(size = 27),  # Y-axis title font size
    axis.text = element_text(size = 23),  # Axis text font size
    aspect.ratio = 0.6,
    legend.title = element_blank(),  # Legend title font size
    legend.text = element_text(size = 23),
    legend.key = element_rect(fill = "white", colour = "white"),
    legend.background = element_rect(fill = "white", colour = "white")
  )
graphics.off()

# 200 SigClust clusters (K-mer values: 5, 10, 15)

combined_df <- data.frame(value = data_values, group = "Total Data Set")

diag(sm_sg_c200_k5) <- NA
diag(sm_sg_c200_k10) <- NA
diag(sm_sg_c200_k15) <- NA

k5_values <- na.omit(as.vector(as.matrix(sm_sg_c200_k5)))
k10_values <- na.omit(as.vector(as.matrix(sm_sg_c200_k10)))
k15_values <- na.omit(as.vector(as.matrix(sm_sg_c200_k15)))

combined_values_df <- data.frame(
  value = c(k5_values, k10_values, k15_values),
  group = rep(c("Kmer: 5", "Kmer: 10", "Kmer: 15"), times = c(length(k5_values), length(k10_values), length(k15_values)))
)

combined_df <- rbind(combined_df, combined_values_df)

fills <- c("Total Data Set" = "darkgrey", "Kmer: 5" = "red", "Kmer: 10" = "green", "Kmer: 15" = "blue")
colors <- c("Total Data Set" = "darkgrey", "Kmer: 5" = "red", "Kmer: 10" = "green", "Kmer: 15" = "blue")

# Plot using ggplot2
png(filename = "../plots/sigClust_200.png", width = 850, height = 450)
ggplot(combined_df, aes(x = value, fill = group, color = group)) +
  geom_density(alpha = 0.6, adjust = 1.7) +
  xlim(0.1, 0.5) +
  labs(title = "Distribution of K2P Scores between 200 SigClust Centers",
       x = "K2P Scores", y = "Density") +
  scale_fill_manual(values = fills) +
  scale_color_manual(values = colors) +
  theme_classic() +
  theme(
    legend.position = c(0.8,0.8),
    text = element_text(family = "Times New Roman"),  # Adjust font family and size
    plot.title = element_text(face = "bold", size = 27),
    plot.subtitle = element_text(size = 15),# Main title font size
    axis.title.x = element_text(size = 27),  # X-axis title font size
    axis.title.y = element_text(size = 27),  # Y-axis title font size
    axis.text = element_text(size = 23),  # Axis text font size
    aspect.ratio = 0.6,
    legend.title = element_blank(),  # Legend title font size
    legend.text = element_text(size = 23),
    legend.key = element_rect(fill = "white", colour = "white"),
    legend.background = element_rect(fill = "white", colour = "white")
  )
graphics.off()

# 50 kmeans clusters

combined_df <- data.frame(value = data_values, group = "Total Data Set")
diag(submatrix_50_k2p_kmeans) <- NA
submatrix_values <- na.omit(as.vector(as.matrix(submatrix_50_k2p_kmeans)))

submatrix_df <- data.frame(
  value = submatrix_values,
  group = rep("Cluster Centers", length(submatrix_values))
)

combined_df <- rbind(combined_df, submatrix_df)

fills <- c("Total Data Set" = "darkgrey", "Cluster Centers" = "red")
colors <- c("Total Data Set" = "darkgrey", "Cluster Centers" = "red")

png(filename = "../plots/kmeans_50.png", width = 800, height = 450)
one <- ggplot(combined_df, aes(x = value, fill = group, color = group)) +
  geom_density(alpha = 0.6, adjust = 1.7) +
  xlim(0.1, 0.5) +
  labs(x = "K2P Scores", y = "Density") +
  scale_fill_manual(values = fills) +
  scale_color_manual(values = colors) +
  theme_classic() +
  theme(
    legend.position = "none",
    text = element_text(family = "Times New Roman"),  # Adjust font family and size
    plot.title = element_text(face = "bold", size = 27),
    plot.subtitle = element_text(size = 22),# Main title font size
    axis.title.x = element_text(size = 27),  # X-axis title font size
    axis.title.y = element_text(size = 27),  # Y-axis title font size
    axis.text = element_text(size = 23),  # Axis text font size
  )
graphics.off()

# 100 kmeans clusters 

combined_df <- data.frame(value = data_values, group = "Total Data Set")
diag(submatrix_100_k2p_kmeans) <- NA
submatrix_values <- na.omit(as.vector(as.matrix(submatrix_100_k2p_kmeans)))

submatrix_df <- data.frame(
  value = submatrix_values,
  group = rep("Cluster Centers", length(submatrix_values))
)

combined_df <- rbind(combined_df, submatrix_df)

fills <- c("Total Data Set" = "darkgrey", "Cluster Centers" = "red")
colors <- c("Total Data Set" = "darkgrey", "Cluster Centers" = "red")

png(filename = "../plots/kmeans_100.png", width = 800, height = 450)
two <- ggplot(combined_df, aes(x = value, fill = group, color = group)) +
  geom_density(alpha = 0.6, adjust = 1.7) +
  xlim(0.1, 0.45) +
  labs(x = "K2P Scores", y = "Density") +
  scale_fill_manual(values = fills) +
  scale_color_manual(values = colors) +
  theme_classic() +
  theme(
    legend.position = c(0.8,0.8),
    text = element_text(family = "Times New Roman"),  # Adjust font family and size
    plot.title = element_text(face = "bold", size = 27),
    plot.subtitle = element_text(size = 22),# Main title font size
    axis.title.x = element_text(size = 27),  # X-axis title font size
    axis.title.y = element_blank(),  # Y-axis title font size
    axis.text = element_text(size = 23),  # Axis text font size
    legend.title = element_blank(),  # Legend title font size
    legend.text = element_text(size = 21),
    aspect.ratio = 0.6,
    legend.key = element_rect(fill = "white", colour = "white"),
    legend.background = element_rect(fill = "white", colour = "white")
  )
graphics.off()

############################
### Statistical Analysis ###
############################

### 100 keans clusters ### 

diag(submatrix_100_k2p_kmeans) <- NA
submatrix_values <- na.omit(as.vector(as.matrix(submatrix_100_k2p_kmeans)))

var.test(data_values, submatrix_values)
t.test(data_values, submatrix_values, var.equal = FALSE)
cohen.d(data_values, submatrix_values)

### 50 keans clusters ### 

diag(submatrix_50_k2p_kmeans) <- NA
submatrix_values <- na.omit(as.vector(as.matrix(submatrix_50_k2p_kmeans)))

var.test(data_values, submatrix_values)
t.test(data_values, submatrix_values, var.equal = FALSE)

cohen.d(data_values, k5_values)

