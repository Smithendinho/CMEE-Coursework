
library(ggplot2)

##############################
### What's in each Cluster ###
##############################

sigclusts <- read.csv("../data/SigClusters/SigClust_output/COX1_200_k5.csv", header = FALSE)
Site100 <- read.csv("../data/Other/SITE-100 Database - mitogenomes.csv")

pairwisematrix <- read.csv("../data/PairwiseMatrices/PairwiseMatrix_k2p.csv", row.names = 1)

barcodes <- read.csv("../data/Other/barcodes.csv")
seqnames <- barcodes$X

pairwisematrix <- pairwisematrix[seqnames, seqnames]
pairwisematrix$clusters <- sigclusts$V2

Site100 <- Site100[Site100$mt_id %in% rownames(pairwisematrix), ]

unique_clusters <- unique(pairwisematrix$clusters)

pdf("../plots/cluster_plots.pdf", onefile = TRUE)
for (i in unique_clusters) {
  
  cluster_sequences <- rownames(pairwisematrix[pairwisematrix$clusters == i,])
  Site100_cluster <- Site100[Site100$mt_id %in% cluster_sequences, ]
  
  p <- ggplot(Site100_cluster, aes(x = superfamily)) +
    geom_bar(fill = "red", alpha = 0.6) +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  print(p)
}
dev.off()

cluster_sequences <- rownames(pairwisematrix[pairwisematrix$clusters == 175,])
Site100_cluster <- Site100[Site100$mt_id %in% cluster_sequences, ]

png(filename = "../plots/cluster_175.png", width = 600, height = 450)
ggplot(Site100_cluster, aes(x = superfamily)) +
  geom_bar(fill = "red", alpha = 0.6) +
  theme_classic() +
  labs(title = "Taxanomic Distribution of a Singular Cluster",
       subtitle = "SigClust cluster number 175",
       x = "Superfamily", y = "Count")+
  theme(
    legend.position = c(0.8,0.8),
    text = element_text(family = "Times New Roman"),  # Adjust font family and size
    plot.title = element_text(face = "bold", size = 25),
    plot.subtitle = element_text(size = 19),# Main title font size
    axis.title.x = element_text(size = 25),  # X-axis title font size
    axis.title.y = element_text(size = 25),  # Y-axis title font size
    axis.text = element_text(size = 21),  # Axis text font size
    legend.title = element_blank(),  # Legend title font size
    legend.text = element_text(size = 21),
    aspect.ratio = 0.55,
    legend.key = element_rect(fill = "white", colour = "white"),
    legend.background = element_rect(fill = "white", colour = "white"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )
graphics.off()

cluster_sequences <- rownames(pairwisematrix[pairwisematrix$clusters == 51,])
Site100_cluster <- Site100[Site100$mt_id %in% cluster_sequences, ]

png(filename = "../plots/cluster_51.png", width = 600, height = 450)
ggplot(Site100_cluster, aes(x = superfamily)) +
  geom_bar(fill = "red", alpha = 0.6) +
  theme_classic() +
  labs(title = "Taxanomic Distribution of a Singular Cluster",
       subtitle = "SigClust cluster number 51",
       x = "Superfamily", y = "Count")+
  theme(
    legend.position = c(0.8,0.8),
    text = element_text(family = "Times New Roman"),  # Adjust font family and size
    plot.title = element_text(face = "bold", size = 25),
    plot.subtitle = element_text(size = 19),# Main title font size
    axis.title.x = element_text(size = 25),  # X-axis title font size
    axis.title.y = element_text(size = 25),  # Y-axis title font size
    axis.text = element_text(size = 21),  # Axis text font size
    legend.title = element_blank(),  # Legend title font size
    legend.text = element_text(size = 21),
    aspect.ratio = 0.55,
    legend.key = element_rect(fill = "white", colour = "white"),
    legend.background = element_rect(fill = "white", colour = "white"),
    axis.text.x = element_text(angle = 45, hjust = 1)
)
graphics.off()

################################
### Cluster Centers Taxonomy ###
################################

center_names <- read.csv("../data/SigClusters/Center_PMs/K2P_200_k5.csv", row.names = 1)
center_names <- rownames(center_names)

### plot sample taxonomic distribution ###

png(filename = "../plots/Site100_total.png", width = 600, height = 450)
ggplot(data = Site100, aes(x = infraorder))+
  geom_bar(fill = "red", alpha = 0.6)+
  theme_classic()+
  labs(title = "Taxanomic Distribution Entire Sample",
       x = "Infraorder", y = "Count")+
  theme(
    text = element_text(family = "Times New Roman"),  # Adjust font family and size
    plot.title = element_text(face = "bold", size = 27),
    plot.subtitle = element_text(size = 19),# Main title font size
    axis.title.x = element_text(size = 27),  # X-axis title font size
    axis.title.y = element_text(size = 27),  # Y-axis title font size
    axis.text = element_text(size = 23),  # Axis text font size
    legend.title = element_blank(),  # Legend title font size
    legend.text = element_text(size = 23),
    aspect.ratio = 0.55,
    legend.key = element_rect(fill = "white", colour = "white"),
    legend.background = element_rect(fill = "white", colour = "white"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )
graphics.off()

### plot cluster centers taxonomic distribution ###

Site100_200_k5 <- Site100[Site100$mt_id %in% center_names, ]

png(filename = "../plots/Site100_centers.png", width = 700, height = 450)
ggplot(data = Site100_200_k5, aes(x = infraorder))+
  geom_bar(fill = "blue", alpha = 0.6)+
  theme_classic()+
  labs(title = "Taxanomic Distribution of Cluster Centers",
       subtitle = "Kmer: 5, n: 200",
       x = "Infraorder", y = "Count")+
  theme(
    text = element_text(family = "Times New Roman"),  # Adjust font family and size
    plot.title = element_text(face = "bold", size = 27),
    plot.subtitle = element_text(size = 21),# Main title font size
    axis.title.x = element_text(size = 27),  # X-axis title font size
    axis.title.y = element_text(size = 27),  # Y-axis title font size
    axis.text = element_text(size = 23),  # Axis text font size
    legend.title = element_blank(),  # Legend title font size
    legend.text = element_text(size = 23),
    aspect.ratio = 0.55,
    legend.key = element_rect(fill = "white", colour = "white"),
    legend.background = element_rect(fill = "white", colour = "white"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )
graphics.off()
#######################
### Plot Bar Charts ###
#######################

plot_bars <- function(taxa) {
  
  for (i in sigclustK) {
    plotname <- paste("p", i, sep = "")
    
    data_name <- paste("Site100_200_k", i, sep = "")
    data <- get(data_name)
    
    plot <- ggplot(data, aes(x = {{taxa}})) +
      geom_bar(fill = "blue") +
      labs(title = paste("200 Cluster Centers k", i, sep = ""),
           x = "Superfamily",
           y = "Frequency") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    assign(plotname, plot)
  }
  
  pdata <- ggplot(Site100, aes(x = {{taxa}})) +
    geom_bar(fill = "red") +
    labs(title = "Total Data Set",
         x = "Superfamily",
         y = "Frequency") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  pdata + p4 + p5 + p6 + p7 + p10 + p15 + p20 + p25
  
}

plot_bars(infraorder)

cluster_sequences <- rownames(pairwisematrix[pairwisematrix$clusters == 149,]) # 149
Site100_cluster <- Site100[Site100$mt_id %in% cluster_sequences, ]

mt_ids <- Site100_cluster$mt_id
write.table(mt_ids, "../data/Other/cluster_49_mt_ids.txt", quote = FALSE, row.names = FALSE, col.names = FALSE )

