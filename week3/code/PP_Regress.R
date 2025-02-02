Data <- read.csv("../data/EcolArchives-E089-51-D1.csv")
Data = mutate(Data, RealPreyMassgrams = ifelse(Prey.mass.unit == "mg", Prey.mass/1000, Prey.mass))
Data$Ratio <- Data$RealPreyMassgrams/Data$Predator.mass

library(ggplot2)
pdf("../results/PP_regress.pdf")
ggplot(data = Data, aes(log(RealPreyMassgrams), log(Predator.mass), colour = Predator.lifestage))+
  geom_point(shape=3,size=1)+
  facet_wrap(~Data$Type.of.feeding.interaction, ncol = 1, strip.position = 'right')+
  geom_smooth(method = 'lm', se = TRUE, fullrange = TRUE)+
  theme_bw()+
  theme(legend.position = 'bottom')+
  guides(colour = guide_legend(nrow = 1))+
  scale_x_continuous(labels = scales::scientific_format()) +
  scale_y_continuous(labels = scales::scientific_format())+
  xlab("Prey Mass in grams")+
  ylab("Predator mass in grams")
graphics.off()

getRegressionRes = function(x) {
  
  mod = lm(log(Predator.mass) ~ log(RealPreyMassgrams) , data = x)
  int = mod$coef[[1]]
  coef = mod$coef[[2]]
  rsq = summary(mod)$r.squared[[1]]
  #Fstat = summary(mod)$fstatistic[[1]]
  Fstat = ifelse(nrow(summary(mod)$coef)>1, summary(mod)$coef[[1]], NA)
  pvalue = ifelse(nrow(summary(mod)$coef) > 1, summary(mod)$coef[2,4], NA)
  
  type = Type.of.feeding.interaction = x$Type.of.feeding.interaction[[1]]
  life = Predator.lifestage = x$Predator.lifestage[[1]]
  
  out = data.frame(feedingType = type, lifestage = life, intercept = int, slope = coef, 
                   rsq = rsq, F_stat = Fstat,
                   p_value = pvalue)
  return(out)
                                            
}

Data2 <- group_split(Data, Type.of.feeding.interaction, Predator.lifestage)
MyResults = bind_rows(lapply(Data2, getRegressionRes))

write.csv(MyResults, "../results/PP_Regress_Results.csv")
