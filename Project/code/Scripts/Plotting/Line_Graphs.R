
# Packages
library(ggplot2)

####################
### Load in Data ###
####################

av_infra <- read.csv("../data/SigClusters/Cluster_centers/Av_no_infra.csv")
av_super <- read.csv("../data/SigClusters/Cluster_centers/Av_no_super.csv")

df_super <- read.csv( "../data/SigClusters/Cluster_centers/Av_super_clust.csv", row.names = 1)
df_infra <- read.csv( "../data/SigClusters/Cluster_centers/Av_infra_clust.csv", row.names = 1)

################################################################################
### Plot Average no of infraorders in each cluster for different kmer values ###
################################################################################

png("../plots/Av_Infra.png", width = 800, height = 500)
ggplot(data = av_infra, aes(x = kmers, y = average, color = cluster, group = cluster)) +
  geom_line(size = 2.5) +
  theme_classic() +
  theme(
    legend.position = c(0.8,0.76),
    text = element_text(family = "Times New Roman"),  # Adjust font family and size
    plot.title = element_text(face = "bold", size = 21),
    axis.title.x = element_text(size = 20),  # X-axis title font size
    axis.title.y = element_text(size = 20),  # Y-axis title font size
    axis.text = element_text(size = 17),  # Axis text font size
    legend.text = element_text(size = 16),
    legend.title = element_text(size = 18),
    legend.key = element_rect(fill = "white", colour = "white"),
    legend.background = element_rect(fill = "white", colour = "white"),
    aspect.ratio = 0.5
  ) +
  labs(title = "Average Number of Infraorders in Each Cluster against K-mer Values",
       x = "K-mer Value",
       y = "Mean Number of Infraorders",
       color = "Number of Clusters")
graphics.off()

##################################################################################
### Plot Average no of Superfamilies in each cluster for different kmer values ###
##################################################################################

png("../plots/Av_Super.png", width = 800, height = 500)
ggplot(data = av_infra, aes(x = kmers, y = average, color = cluster, group = cluster)) +
  geom_line(size = 2.5) +
  theme_classic() +
  theme(
    legend.position = c(0.8,0.76),
    text = element_text(family = "Times New Roman"),  # Adjust font family and size
    plot.title = element_text(face = "bold", size = 21),
    axis.title.x = element_text(size = 20),  # X-axis title font size
    axis.title.y = element_text(size = 20),  # Y-axis title font size
    axis.text = element_text(size = 17),  # Axis text font size
    legend.text = element_text(size = 16),
    legend.title = element_text(size = 18),
    legend.key = element_rect(fill = "white", colour = "white"),
    legend.background = element_rect(fill = "white", colour = "white"),
    aspect.ratio = 0.5
  ) +
  labs(title = "Average Number of Superfamilies in Each Cluster against K-mer Values",
       x = "K-mer Value",
       y = "Mean Number of Superfamilies",
       color = "Number of Clusters")
graphics.off()

#######################################################################################
### Plot Average no. of taxa in each cluster for different no. of clusters ###
#######################################################################################

# infraorder
png("../plots/Av_infra_clust.png", width = 800, height = 500)
ggplot(data = df_infra, aes(x = clusters, y = averages)) +
  geom_line(size = 2.5, colour = "red") +
  theme_classic() +
  theme(
    legend.position = c(0.8,0.76),
    text = element_text(family = "Times New Roman"),  # Adjust font family and size
    plot.title = element_text(face = "bold", size = 21),
    axis.title.x = element_text(size = 20),  # X-axis title font size
    axis.title.y = element_text(size = 20),  # Y-axis title font size
    axis.text = element_text(size = 17),  # Axis text font size
    legend.text = element_text(size = 16),
    legend.title = element_text(size = 18),
    legend.key = element_rect(fill = "white", colour = "white"),
    legend.background = element_rect(fill = "white", colour = "white"),
    aspect.ratio = 0.5
  ) +
  labs(title = "Mean Number of Infraorders in Each Cluster against K-mer Values",
       x = "Number of Clusters",
       y = "Mean Number of Infraorders",
       color = "Number of Clusters")
graphics.off()

# superfamily
png("../plots/Av_super_clust.png", width = 800, height = 500)
ggplot(data = df_super, aes(x = clusters, y = averages)) +
  geom_line(size = 2.5, colour = "red") +
  theme_classic() +
  theme(
    legend.position = c(0.8,0.76),
    text = element_text(family = "Times New Roman"),  # Adjust font family and size
    plot.title = element_text(face = "bold", size = 21),
    axis.title.x = element_text(size = 20),  # X-axis title font size
    axis.title.y = element_text(size = 20),  # Y-axis title font size
    axis.text = element_text(size = 17),  # Axis text font size
    legend.text = element_text(size = 16),
    legend.title = element_text(size = 18),
    legend.key = element_rect(fill = "white", colour = "white"),
    legend.background = element_rect(fill = "white", colour = "white"),
    aspect.ratio = 0.5
  ) +
  labs(title = "Mean Number of Superfamilies in Each Cluster against K-mer Values",
       x = "Number of Clusters",
       y = "Mean Number of Superfamilies",
       color = "Number of Clusters")
graphics.off()
