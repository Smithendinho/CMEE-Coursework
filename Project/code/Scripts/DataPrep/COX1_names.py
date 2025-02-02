import csv
from Bio import SeqIO

# Define the input and output file paths
input_fasta = '../data/tree_building/1_nt_raw/COX1.fasta'
output_csv = '../data/Other/sequence_names.csv'

# Initialize an empty list to hold sequence names
sequence_names = []

with open(input_fasta, 'r') as fasta_file:
    for record in SeqIO.parse(fasta_file, 'fasta'):
        sequence_names.append(record.id)

with open(output_csv, 'w', newline='') as csv_file:
    csv_writer = csv.writer(csv_file)
    csv_writer.writerow(['Sequence Name'])
    for name in sequence_names:
        csv_writer.writerow([name])

print(f"Sequence names have been saved to {output_csv}")
