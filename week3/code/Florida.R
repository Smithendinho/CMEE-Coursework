rm(list=ls())
load("../data/KeyWestAnnualMeanTemperature.RData")
set.seed(1)
n <- length(ats$Year)
Perm <- 100000
variable <- ats$Temp
TrueCorrelation <- cor(ats$Year, ats$Temp)
TrueCorrelationRounded <- round(TrueCorrelation, 2)
# Generate permutations
PermSamples <- replicate(Perm, sample(variable, size = n, replace = FALSE))
PermSamples <- cbind(ats$Year, PermSamples)

# Calculate correlations
CorrelationCoefficients <- cor(PermSamples[, 1], PermSamples[, 2:(Perm + 1)])

# Plot the histogram
jpeg("../images/rplot.jpg", width = 350, height = 350)
hist(CorrelationCoefficients, xlim = c(-0.4, 0.6),xlab = "Correlation Coefficients", ylab = "Frequency", main = "")
abline(v = TrueCorrelation, col = "red", lwd = 3)
text(x=0.45, y=15000, labels = TrueCorrelationRounded)
dev.off()

range(CorrelationCoefficients)

Coef_more_than_realCor <- CorrelationCoefficients>TrueCorrelation
count_true <- sum(Coef_more_than_realCor == TRUE)
print(count_true/Perm)
