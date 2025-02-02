Data <- read.csv("../data/EcolArchives-E089-51-D1.csv")
Data = mutate(Data, RealPreyMassgrams = ifelse(Prey.mass.unit == "mg", Prey.mass/1000, Prey.mass))
Data$Ratio <- Data$RealPreyMassgrams/Data$Predator.mass

library(ggplot2)
# Distribution of Predator Mass' for each feeding interaction
pdf("../results/Pred_Subplots.pdf")
ggplot(data = Data, aes(x=log(Predator.mass), fill = Type.of.feeding.interaction))+
                                    geom_density()+
                                    facet_wrap(~Type.of.feeding.interaction, ncol = 1)+
                                    theme(legend.position = "none")+
                                    xlab("Log Predator Mass (g)")+
                                    ylab("Density")
                                    
graphics.off()

# Distribution of Prey Mass' for each feeding interaction
pdf("../results/Prey_Subplots.pdf")
ggplot(data = Data, aes(x=log(Prey.mass), fill = Type.of.feeding.interaction))+
                                    geom_density()+
                                    facet_wrap(~Data$Type.of.feeding.interaction, ncol = 1)+
                                    theme(legend.position = "none")+
                                    xlab("Log Prey Mass (g)")+
                                    ylab("Density")
                                    
graphics.off()

# Distribution of Prey/predmass ratio for each feeding interaction

pdf("../results/SizeRatio_Subplots.pdf")
ggplot(data = Data, aes(x=log(Ratio), fill = Type.of.feeding.interaction))+
                                    geom_density()+
                                    facet_wrap(~Data$Type.of.feeding.interaction, ncol = 1)+
                                    theme(legend.position = "none")+
                                    xlab("Predator Prey Mass Ratio")+
                                    ylab("Density")
                                    
graphics.off()

list <- unique(Data$Type.of.feeding.interaction)

dataframe1 <- data.frame(
  meanlogpredmass = numeric(length(list)),
  meanlogpreymass = numeric(length(list)),
  meanlogratio = numeric(length(list))
)

for (i in 1:length(list)) {
  subgroup <- Data[Data$Type.of.feeding.interaction == list[i], ]
  dataframe1$meanlogpredmass[i] <- mean(log(subgroup$Predator.mass))
  dataframe1$meanlogpreymass[i] <- mean(log(subgroup$Prey.mass))
  dataframe1$meanlogratio[i] <- mean(subgroup$Ratio)
}

rownames(dataframe1) <- c(list)
write.csv(dataframe1, "../results/PP_Results.csv")
