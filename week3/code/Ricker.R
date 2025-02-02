Ricker <- function(N0=1, r=1, K=10, generations=50)
{
  # NO is possible ("sam!! think outside the invertebrate box!")
  # r is intrinsic growth rate
  # k is carrying capacity
  # Runs a simulation of the Ricker model
  # Returns a vector of length generations
  
  N <- rep(NA, generations)    # Creates a vector of NA
  
  N[1] <- N0
  for (t in 2:generations)
  {
    N[t] <- N[t-1] * exp(r*(1.0-(N[t-1]/K)))
  }
  return (N)
}

plot(Ricker(generations=10), type="l")
