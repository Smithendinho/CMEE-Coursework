import os
import pandas as pd
from Bio import SeqIO

def create_dataframe(directory):
    files_list = os.listdir(directory)
    unique_genes = set()

    rows = []
    for file in files_list:
        file_path = os.path.join(directory, file)
        if not isinstance(file_path, str):
            print(f"Error: file_path is not a string: {file_path}")
            continue

        try:
            gb_record = SeqIO.read(file_path, "genbank")
        except Exception as e:
            print(f"Error reading file {file}: {e}")
            continue

        Sequence = str(gb_record.seq)
        gene_sequences = {}

        for feature in gb_record.features:
            if feature.type == "CDS" and 'gene' in feature.qualifiers:
                gene_name = feature.qualifiers['gene'][0]
                cds_sequence = str(feature.extract(gb_record.seq))
                gene_sequences[gene_name] = cds_sequence
                unique_genes.add(gene_name)

        row_data = {'FileName': file, 'Sequence': Sequence, **gene_sequences}
        rows.append(row_data)

    # Create DataFrame
    columns = ['FileName', 'Sequence'] + list(unique_genes)
    df = pd.DataFrame(rows, columns=columns)

    return df

directory = '../data/All_MGs'
df = create_dataframe(directory)
df.to_csv("../data/Other/sequences.csv", index=False)
