###################
### import data ###
###################

data <- read.csv("../data/Other/sequences123.csv", row.names = 1)
seqnames <- read.csv("../data/Other/sequence_names.csv")
seqnames <- seqnames$Sequence.Name

#####################
### Find Barcodes ###
#####################

data$barcode_data <- lapply(substring(data$Sequence, 261, 957), function(x) {
  strsplit(gsub("-", "", x), "")[[1]]
})

is_valid_sequence <- function(seq) {
  sum(seq %in% c("A", "T", "C", "G")) == 658
}

valid_indices <- sapply(data$barcode_data, is_valid_sequence)
valid_row_names <- rownames(data)[valid_indices]

data <- data[valid_row_names, ]
data <- subset(data, select = -Sequence)
data$barcode_data <- sapply(data$barcode_data, paste, collapse = "")

seqnames <- as.character(seqnames)
data <- subset(data, rownames(data) %in% seqnames)

###########################
### Write to fasta file ###
###########################

fasta_lines <- c()
for (i in 1:nrow(data)) {
  fasta_lines <- c(fasta_lines, paste0(">", rownames(data)[i]), data$barcode_data[i])
}

writeLines(fasta_lines, "../data/SigClusters/Barcodes/barcodes.fasta")

####################
### Write to CSV ###
####################

write.csv(data, "../data/Other/barcodes.csv")
