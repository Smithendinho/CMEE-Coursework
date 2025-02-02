library(maps)
library(ggplot2)
load("../data/GPDDFiltered.RData")

world_map <- map_data("world")

ggplot() + geom_map(data = world_map, map = world_map, aes(map_id = region), fill = "lightblue", color = "darkblue")+
  geom_point(data = gpdd, aes(long, lat), color = 'black')+
  theme_light()+
  xlab("Longitude")+
  ylab("Latitude")+
  ggtitle("World Map with GPDD Points")+
  expand_limits(x=world_map$long, y = world_map$lat)

# It is clear on the plot that the majority of the data points were recorded on the west coast of the US and in the UK. Therefore this data set is biased towards these regions and is not representative on a global scale. In addition, a data set of only 147 observations with often only a few recordings for a particular species is likely not a sufficient sample size for any robust analysis.
