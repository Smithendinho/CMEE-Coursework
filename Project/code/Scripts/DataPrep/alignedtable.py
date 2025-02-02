import csv

# Function to read and parse the FASTA file
def read_fasta(file_path):
    """This converts the aligned sequences into a csv for the barcodes to consequently be extracted"""
    sequences = {}
    with open(file_path, 'r') as f:
        sequence_name = None
        sequence = ''
        for line in f:
            line = line.strip()
            if line.startswith('>'):
                # If the line starts with '>', it's a sequence name
                if sequence_name is not None:
                    sequences[sequence_name] = sequence
                sequence_name = line[1:]
                sequence = ''
            else:
             # Otherwise, it's part of the sequence
                sequence += line
        # Add the last sequence to the dictionary
        sequences[sequence_name] = sequence
    return sequences

# Path to the FASTA file
fasta_file = '../data/tree_building/4_nt_aln/COX1.fasta'

# Read and parse the FASTA file
sequences = read_fasta(fasta_file)

csv_file = '../data/Other/sequences123.csv'
with open(csv_file, 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['Name', 'Sequence'])
    for name, sequence in sequences.items():
        writer.writerow([name, sequence])

