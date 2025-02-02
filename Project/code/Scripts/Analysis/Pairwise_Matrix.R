#########################
### Packages and Data ###
#########################

library(parallel)
data <- read.csv("../data/Other/barcodes.csv")

#######################
### Score Functions ###
#######################

# basic similarity score function

score <- function(seq1, seq2) {
  # length <- min(length(seq1), length(seq2))
  matches <- seq1[1:length] == seq2[1:length]
  matches[seq1[1:length] == "-"] <- FALSE
  # return(sum(matches) / length)
  return(sum(matches))
}

# K2P score function

ktwop <- function(seq1, seq2, k = 2) {
  
  is_transition <- function(base1, base2) {
    transitions <- c("AG", "GA", "CT", "TC")
    paste0(base1, base2) %in% transitions
  }
  
  is_transversion <- function(base1, base2) {
    transversions <- c("AC", "CA", "AT", "TA", "GC", "CG", "GT", "TG")
    paste0(base1, base2) %in% transversions
  }
  
  length <- min(length(seq1), length(seq2))
  seq1 <- seq1[1:length]
  seq2 <- seq2[1:length]
  
  transitions <- 0
  transversions <- 0
  
  for (i in 1:length) {
    if (seq1[i] != seq2[i] && seq1[i] != "-" && seq2[i] != "-") {
      if (is_transition(seq1[i], seq2[i])) {
        transitions <- transitions + 1
      } else if (is_transversion(seq1[i], seq2[i])) {
        transversions <- transversions + 1
      }
    }
  }
  
  P <- transitions / length
  Q <- transversions / length
  
  K <- -0.5 * log((1 - 2 * P - Q) * sqrt(1 - 2 * Q))
  return(K)
}

###############################
### Initialize empty matrix ###
###############################

Initialise_Matrix <- function(data) {
  PairwiseMatrix <- matrix(0, nrow = nrow(data), ncol = nrow(data))
  dimnames(PairwiseMatrix) <- list(data$Name, data$Name)
  return(PairwiseMatrix)
}

Pairwise_Matrix <- Initialise_Matrix(data)

#######################################################
### Fill Pairwise Matrix with normal score function ###
#######################################################

fill_matrix <- function(data, Pairwise_Matrix) {
  n <- nrow(Pairwise_Matrix)
  
  compute_row <- function(i) {
    scores <- numeric(n)
    seq1 <- data$barcode_data[[i]]
    for (j in i:n) {
      seq2 <- data$barcode_data[[j]]
      scores[j] <- score(seq1, seq2)
    }
    return(scores)
  }
  
  results <- mclapply(1:n, compute_row, mc.cores = detectCores() - 2)
  
  ### Fill the Pairwise Matrix ###
  for (i in 1:n) {
    Pairwise_Matrix[i, i:n] <- results[[i]][i:n]
  }
  
  Pairwise_Matrix[lower.tri(Pairwise_Matrix)] <- t(Pairwise_Matrix)[lower.tri(Pairwise_Matrix)]
  return(Pairwise_Matrix)
}

############################################
### Fill Pairwise Matrix with k2p scores ### # ignoring codon position
############################################

fill_matrix_k2p <- function(data, Pairwise_Matrix) {
  n <- nrow(Pairwise_Matrix)
  
  for (i in 1:n) {
    seq1 <- data[[i]]
    for (j in i:n) {
      seq2 <- data[[j]]
      Pairwise_Matrix[i, j] <- ktwop(seq1, seq2)
      Pairwise_Matrix[j, i] <- Pairwise_Matrix[i, j]  # since it's symmetric
    }
  }
  
  return(Pairwise_Matrix)
}

#########################################
### Execute Function and Write to CSV ###
#########################################

matrix <- fill_matrix_k2p(data$barcode_data, Pairwise_Matrix)
write.csv(matrix, "../data/PairwiseMatrices/PairwiseMatrix_k2p.csv", row.names = TRUE)

Pairwise_Matrix <- Initialise_Matrix(data)
matrix_c1 <- fill_matrix_k2p(data$barcode_data_c1, Pairwise_Matrix)
write.csv(matrix_c1, "../data/PairwiseMatrices/PairwiseMatrix_k2p_c1.csv", row.names = TRUE)

Pairwise_Matrix <- Initialise_Matrix(data)
matrix_c2 <- fill_matrix_k2p(data$barcode_data_c2, Pairwise_Matrix)
write.csv(matrix_c1, "../data/PairwiseMatrices/PairwiseMatrix_k2p_c2.csv", row.names = TRUE)

Pairwise_Matrix <- Initialise_Matrix(data)
matrix_c3 <- fill_matrix_k2p(data$barcode_data_c3, Pairwise_Matrix)
write.csv(matrix_c1, "../data/PairwiseMatrices/PairwiseMatrix_k2p_c3.csv", row.names = TRUE)

