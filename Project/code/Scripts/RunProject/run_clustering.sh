#!/bin/bash

### Extract Mitogenome IDs from Site-100 database ###

echo "Extracting Mitogenome IDs from metadatabase"
Rscript Scripts/Extract_mt_ids.R
echo "Mitogenome IDs obtained and stored in ../data/mt_ids.txt"

### Place mt_ids.txt into my server directory ###

scp -o ProxyJump=sams@orca.nhm.ac.uk ../data/Other/mt_ids.txt sams@franklin.nhm.ac.uk:/mbl/share/workspaces/groups/voglerlab/samsmith/data/
scp -o ProxyJump=sams@orca.nhm.ac.uk ../data/TreeBuilding/backbone_120_ids.txt sams@franklin.nhm.ac.uk:/mbl/share/workspaces/groups/voglerlab/samsmith/data

### log into the server and execute the bash script ###

### Retreive GenBank files from the Server ###

echo "Accessing and Receiving GenBank files from NHM Franklin server. User credentials required!"
scp -o ProxyJump=sams@orca.nhm.ac.uk -r sams@franklin.nhm.ac.uk:/mbl/share/workspaces/groups/voglerlab/samsmith/data/All_MGs ../data/MitoGenomes/
scp -o ProxyJump=sams@orca.nhm.ac.uk -r sams@franklin.nhm.ac.uk:/mbl/share/workspaces/groups/voglerlab/samsmith/data/120_MGs ../data/MitoGenomes/

### Process GenBank Files ###

echo "Processing GenBank files and outputting table with all PCGs present"
ipython3 Scripts/Process_GBs.py

### Tidy the Data & find the IDs of Complete mitogenomes ###

echo "Tidying GenBank data and identifying complete mitogenomes"
Rscript Scripts/tidy_data.R
echo "output ../data/Other/complete_mt_ids.txt & Complete_MG_Sequences.csv"

### Move complete mitogenomes into new folder ###

echo "Moving complete mitogenomes into new folder"
source_dir="../data/All_MGs"
dest_dir="../data/Complete_MGs"

while IFS= read -r file; do
    cp "$source_dir/$file" "$dest_dir/"
done < "../data/Other/complete_mt_ids.txt"

### combine all of the gb files ###

echo "Initiating Translation Process"
cat ../data/MitoGenomes/Complete_MGs/* > ../data/Other/combined.gb

### extract genes and convert to fasta ###

tjcreedyPL/biotools/extract_genes.py -g ../data/Other/combined.gb -o ../data/TreeBuilding/1_nt_raw/ -k --genetypes CDS

### translate.py ###

echo "Translating..."
nt_raw_dir="../data/TreeBuilding/1_nt_raw/"
aa_raw_dir="../data/TreeBuilding/2_aa_raw/"

for file in "$nt_raw_dir"*
do
    filename=$(basename "$file")
    tjcreedyPL/biotools/translate.py 5 < "$file" > "${aa_raw_dir}${filename}"
done

### Which Genes were translated ###

ipython3 Scripts/COX1_names.py
# this output the sequence names that were translated 

### Signal Clustering ###
echo "Executing Signal Clustering Algorithm"
input_file="../data/tree_building/1_nt_raw/COX1.fasta"
output_dir="../data/Sig_Clusters"

c_values=(50 200 500)

k_values=(4 5 6 7 10 15 20 25)

for c in "${c_values[@]}"; do
  for k in "${k_values[@]}"; do
    output_file="${output_dir}/COX1_${c}_k${k}.csv"
    ./SigClust/SigClust -i 100 -c "$c" -k "$k" "$input_file" > "$output_file"
  done
done

### Make Data frame with all aligned sequences and IDs ###

ipython3 Scripts/alignedtable.py
# outputs sequence123

Rscript Scripts/fasta_barcodes.R 
# outputs fasta for SigClust and barcodes for pairwise matrix

### Generate Score function and Pairwise Matrix ###

Rscript Scripts/Pairwise_Matrix.R

### Kmeans Clustering ###

Rscript Scripts/Kmeans.R

### SigClust Centers ###

Rscript Scripts/SigClust_centers.R

### Plot Distributions ###

Rscript Scripts/Density_Plots.R

### Move cluster centers mitogenomes to bb_200 ###

echo "Moving complete mitogenomes into new folder"
sed -i 's/$/.gb/' ../data/Other/combined_unique_values.txt

  # Move cluster center mitogenomes
source_dir="../data/MitoGenomes/All_MGs"
dest_dir="../data/MitoGenomes/320_MGs"

while IFS= read -r file; do
    cp "$source_dir/$file" "$dest_dir/"
done < "../data/Other/combined_unique_values.txt"

cat ../data/MitoGenomes/320_MGs/* > ../data/Other/combined_320.gb

### Move example cluster contents to example folder

echo "Moving complete mitogenomes into new folder"
sed -i 's/$/.gb/' ../data/Other/cluster_49_mt_ids.txt

source_dir="../data/MitoGenomes/All_MGs"
dest_dir="../data/MitoGenomes/example"

while IFS= read -r file; do
    cp "$source_dir/$file" "$dest_dir/"
done < "../data/Other/cluster_49_mt_ids.txt"

cat ../data/MitoGenomes/example/* > ../data/Other/example.gb

### Translate 320 ###
tjcreedyPL/biotools/extract_genes.py -g ../data/Other/combined_320.gb -o ../data/TreeBuilding/1_nt_320/ -k --genetypes CDS

nt_raw_dir="../data/TreeBuilding/1_nt_320/"
aa_raw_dir="../data/TreeBuilding/2_aa_320/"

for file in "$nt_raw_dir"*
do
    filename=$(basename "$file")
    tjcreedyPL/biotools/translate.py 5 < "$file" > "${aa_raw_dir}${filename}"
done

### Translate example ###
tjcreedyPL/biotools/extract_genes.py -g ../data/Other/example.gb -o ../data/TreeBuilding/one/ -k --genetypes CDS

nt_raw_dir="../data/TreeBuilding/one/"
aa_raw_dir="../data/TreeBuilding/two/"

for file in "$nt_raw_dir"*
do
    filename=$(basename "$file")
    tjcreedyPL/biotools/translate.py 5 < "$file" > "${aa_raw_dir}${filename}"
done

### Align ###

mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/2_aa_320/COX1.fasta" > "../data/TreeBuilding/3_aa_aln_320/COX1.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/2_aa_320/ND1.fasta" > "../data/TreeBuilding/3_aa_aln_320/ND1.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/2_aa_320/ATP6.fasta" > "../data/TreeBuilding/3_aa_aln_320/ATP6.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/2_aa_320/ATP8.fasta" > "../data/TreeBuilding/3_aa_aln_320/ATP8.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/2_aa_320/COX2.fasta" > "../data/TreeBuilding/3_aa_aln_320/COX2.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/2_aa_320/COX3.fasta" > "../data/TreeBuilding/3_aa_aln_320/COX3.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/2_aa_320/CYTB.fasta" > "../data/TreeBuilding/3_aa_aln_320/CYTB.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/2_aa_320/ND2.fasta" > "../data/TreeBuilding/3_aa_aln_320/ND2.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/2_aa_320/ND3.fasta" > "../data/TreeBuilding/3_aa_aln_320/ND3.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/2_aa_320/ND4.fasta" > "../data/TreeBuilding/3_aa_aln_320/ND4.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/2_aa_320/ND4L.fasta" > "../data/TreeBuilding/3_aa_aln_320/ND4L.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/2_aa_320/ND5.fasta" > "../data/TreeBuilding/3_aa_aln_320/ND5.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/2_aa_320/ND6.fasta" > "../data/TreeBuilding/3_aa_aln_320/ND6.fasta"

mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/two/COX1.fasta" > "../data/TreeBuilding/three/COX1.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/two/ND1.fasta" > "../data/TreeBuilding/three/ND1.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/two/ATP6.fasta" > "../data/TreeBuilding/three/ATP6.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/two/ATP8.fasta" > "../data/TreeBuilding/three/ATP8.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/two/COX2.fasta" > "../data/TreeBuilding/three/COX2.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/two/COX3.fasta" > "../data/TreeBuilding/three/COX3.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/two/CYTB.fasta" > "../data/TreeBuilding/three/CYTB.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/two/ND2.fasta" > "../data/TreeBuilding/three/ND2.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/two/ND3.fasta" > "../data/TreeBuilding/three/ND3.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/two/ND4.fasta" > "../data/TreeBuilding/three/ND4.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/two/ND4L.fasta" > "../data/TreeBuilding/three/ND4L.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/two/ND5.fasta" > "../data/TreeBuilding/three/ND5.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/TreeBuilding/two/ND6.fasta" > "../data/TreeBuilding/three/ND6.fasta"


### Back Translate ###

tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/3_aa_aln_320/COX1.fasta ../data/TreeBuilding/1_nt_320/COX1.fasta 5 > ../data/TreeBuilding/4_nt_aln_320/COX1.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/3_aa_aln_320/ND1.fasta ../data/TreeBuilding/1_nt_320/ND1.fasta 5 > ../data/TreeBuilding/4_nt_aln_320/ND1.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/3_aa_aln_320/ATP6.fasta ../data/TreeBuilding/1_nt_320/ATP6.fasta 5 > ../data/TreeBuilding/4_nt_aln_320/ATP6.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/3_aa_aln_320/ATP8.fasta ../data/TreeBuilding/1_nt_320/ATP8.fasta 5 > ../data/TreeBuilding/4_nt_aln_320/ATP8.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/3_aa_aln_320/COX2.fasta ../data/TreeBuilding/1_nt_320/COX2.fasta 5 > ../data/TreeBuilding/4_nt_aln_320/COX2.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/3_aa_aln_320/COX3.fasta ../data/TreeBuilding/1_nt_320/COX3.fasta 5 > ../data/TreeBuilding/4_nt_aln_320/COX3.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/3_aa_aln_320/CYTB.fasta ../data/TreeBuilding/1_nt_320/CYTB.fasta 5 > ../data/TreeBuilding/4_nt_aln_320/CYTB.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/3_aa_aln_320/ND2.fasta ../data/TreeBuilding/1_nt_320/ND2.fasta 5 > ../data/TreeBuilding/4_nt_aln_320/ND2.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/3_aa_aln_320/ND3.fasta ../data/TreeBuilding/1_nt_320/ND3.fasta 5 > ../data/TreeBuilding/4_nt_aln_320/ND3.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/3_aa_aln_320/ND4.fasta ../data/TreeBuilding/1_nt_320/ND4.fasta 5 > ../data/TreeBuilding/4_nt_aln_320/ND4.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/3_aa_aln_320/ND4L.fasta ../data/TreeBuilding/1_nt_320/ND4L.fasta 5 > ../data/TreeBuilding/4_nt_aln_320/ND4L.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/3_aa_aln_320/ND5.fasta ../data/TreeBuilding/1_nt_320/ND5.fasta 5 > ../data/TreeBuilding/4_nt_aln_320/ND5.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/3_aa_aln_320/ND6.fasta ../data/TreeBuilding/1_nt_320/ND6.fasta 5 > ../data/TreeBuilding/4_nt_aln_320/ND6.fasta

tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/three/COX1.fasta ../data/TreeBuilding/one/COX1.fasta 5 > ../data/TreeBuilding/four/COX1.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/three/ND1.fasta ../data/TreeBuilding/one/ND1.fasta 5 > ../data/TreeBuilding/four/ND1.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/three/ATP6.fasta ../data/TreeBuilding/one/ATP6.fasta 5 > ../data/TreeBuilding/four/ATP6.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/three/ATP8.fasta ../data/TreeBuilding/one/ATP8.fasta 5 > ../data/TreeBuilding/four/ATP8.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/three/COX2.fasta ../data/TreeBuilding/one/COX2.fasta 5 > ../data/TreeBuilding/four/COX2.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/three/COX3.fasta ../data/TreeBuilding/one/COX3.fasta 5 > ../data/TreeBuilding/four/COX3.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/three/CYTB.fasta ../data/TreeBuilding/one/CYTB.fasta 5 > ../data/TreeBuilding/four/CYTB.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/three/ND2.fasta ../data/TreeBuilding/one/ND2.fasta 5 > ../data/TreeBuilding/four/ND2.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/three/ND3.fasta ../data/TreeBuilding/one/ND3.fasta 5 > ../data/TreeBuilding/four/ND3.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/three/ND4.fasta ../data/TreeBuilding/one/ND4.fasta 5 > ../data/TreeBuilding/four/ND4.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/three/ND4L.fasta ../data/TreeBuilding/one/ND4L.fasta 5 > ../data/TreeBuilding/four/ND4L.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/three/ND5.fasta ../data/TreeBuilding/one/ND5.fasta 5 > ../data/TreeBuilding/four/ND5.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/TreeBuilding/three/ND6.fasta ../data/TreeBuilding/one/ND6.fasta 5 > ../data/TreeBuilding/four/ND6.fasta


### Make Nucleotide Supermatrix ###

catfasta2phyml/catfasta2phyml.pl -c -fasta ../data/TreeBuilding/4_nt_aln_320/* > ../data/TreeBuilding/5_nt_supermatrix.fasta 2> ../data/TreeBuilding/5_nt_partitions.txt

catfasta2phyml/catfasta2phyml.pl -c -fasta ../data/TreeBuilding/four/* > ../data/TreeBuilding/5_nt_supermatrix_example.fasta 2> ../data/TreeBuilding/5_nt_partitions_example.txt


### Generate maximal partition tables for NT data ###

# Partition by genes
tjcreedyPL/biotools/partitioner.py -a DNA < ../data/TreeBuilding/5_nt_partitions.txt > ../data/TreeBuilding/5_nt_gene_partitions.txt
tjcreedyPL/biotools/partitioner.py -a DNA < ../data/TreeBuilding/5_nt_partitions_example.txt > ../data/TreeBuilding/5_nt_gene_partitions_example.txt

# Partition by genes and all three codon positions
tjcreedyPL/biotools/partitioner.py -a DNA -c < ../data/TreeBuilding/5_nt_partitions.txt > ../data/TreeBuilding/5_nt_gene+codon123_partitions.txt
# Partition by genes and first two codon positions
tjcreedyPL/biotools/partitioner.py -a DNA -c -u 1 2 < ../data/TreeBuilding/5_nt_partitions.txt > ../data/TreeBuilding/5_nt_gene+codon12_partitions.txt

# This is the partion finder, and finds optimal model for each partition #
iqtree2 -s ../data/TreeBuilding/5_nt_supermatrix.fasta -m MF+MERGE -T AUTO --threads-max 10 --prefix ../data/TreeBuilding/6_nt_gene+codon123 -Q ../data/TreeBuilding/5_nt_gene+codon123_partitions.txt

iqtree2 -s ../data/TreeBuilding/5_nt_supermatrix_example.fasta -m MF+MERGE -T AUTO --threads-max 10 --prefix ../data/TreeBuilding/6_nt_gene_example+codon123 -Q ../data/TreeBuilding/5_nt_gene+codon123_partitions_example.txt


iqtree2 -g ../data/TreeBuilding/back.tre -B 1000 -alrt 1000 -abayes -redo -lbp 1000 -bnni -s ../data/TreeBuilding/5_nt_supermatrix.fasta -T AUTO --threads-max 10 --prefix ../data/TreeBuilding/7_nt_gene+codon123 -Q ../data/TreeBuilding/6_nt_gene+codon123.best_scheme.nex


### label tree tips ###

tjcreedyPL/phylabel.R -p ../data/TreeBuilding/7_nt_gene+codon123.treefile -o tree_RN.tre -r --taxonomy ../data/Other/ColeopteranSite100.csv --taxlevels infraorder


tjcreedyPL/biotools/partitioner.py -a DNA -c < ../data/TreeBuilding/5_nt_partitions_example.txt > ../data/TreeBuilding/5_nt_gene_example+codon123_partitions.txt
iqtree2 -redo -s ../data/TreeBuilding/5_nt_supermatrix_example.fasta -m MF+MERGE -T AUTO --threads-max 10 --prefix  ../data/TreeBuilding/6_nt_gene_example+codon123 -Q ../data/TreeBuilding/5_nt_gene_example+codon123_partitions.txt
iqtree2 -B 1000 -alrt 1000 -abayes -redo -lbp 1000 -bnni -s ../data/TreeBuilding/5_nt_supermatrix_example.fasta -T AUTO --threads-max 10 --prefix ../data/TreeBuilding/7_nt_gene_example+codon123 -Q ../data/TreeBuilding/6_nt_gene_example+codon123.best_scheme.nex

tjcreedyPL/phylabel.R -p ../data/TreeBuilding/7_nt_gene_example+codon123.treefile -o tree_example_RN.tre -r --taxonomy ../data/Other/ColeopteranSite100.csv --taxlevels family,genus

tjcreedyPL/phylabel.R -p ../data/TreeBuilding/7_nt_gene+codon123.treefile -o rooted.tree -r --taxonomy ../data/Other/ColeopteranSite100_root.csv --taxlevels infraorder,family

