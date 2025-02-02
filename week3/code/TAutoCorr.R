rm(list=ls())
load("../data/KeyWestAnnualMeanTemperature.RData")

ats <- transform(ats, dy=c(NA, diff(ats$Temp)))
plot(ats$Year, ats$dy)
Temp1 <- ats$Temp[1:99]
Temp2 <- ats$Temp[2:100]

set.seed(1)
n <- length(ats$Year)
Perm <- 100000
variable <- ats$Temp

# Generate permutations
PermSamples <- replicate(Perm, sample(variable, size = n, replace = FALSE))
PermSamples <- cbind(ats$Year, PermSamples)

# Calculate correlations
CorrelationCoefficients <- cor(PermSamples[, 1], PermSamples[, 2:(Perm + 1)])
print(range(CorrelationCoefficients))

# Calculate p-value
cor <- (cor(Temp1, Temp2))
cormorethancor <- CorrelationCoefficients>cor
count_true <- sum(cormorethancor == TRUE)
print(count_true/Perm)
