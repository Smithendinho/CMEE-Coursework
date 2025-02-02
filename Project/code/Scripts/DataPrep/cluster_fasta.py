from Bio import SeqIO

# File paths
mitochondrial_ids_file = "Cluster_center_IDs.txt"
fasta_file = "sequences.fasta"
output_file = "filtered_sequences.fasta"

# Read mitochondrial IDs from the txt file
with open(mitochondrial_ids_file, "r") as f:
    mitochondrial_ids = set(line.strip() for line in f)

# Filter sequences from the FASTA file
filtered_sequences = []
for record in SeqIO.parse(fasta_file, "fasta"):
    if record.id in mitochondrial_ids:
        filtered_sequences.append(record)

# Write the filtered sequences to a new FASTA file
SeqIO.write(filtered_sequences, output_file, "fasta")

print(f"Filtered {len(filtered_sequences)} sequences and saved to {output_file}")