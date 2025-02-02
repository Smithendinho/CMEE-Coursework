#!/usr/bin/env python3
"""Practical called 'Align DNA Sequences'"""

__appname__ = '[application name here]'
__author__ = 'Sam Smith (scs23@ic.ac.uk)'

## imports ##
import sys
import csv

sequenceCSV = open('../data/DNA_sequences.csv', 'r')
csvread = csv.reader(sequenceCSV)
sequences = []
for row in csvread:
    sequences.append(tuple(row))
sequence1 = sequences[0]
sequence2 = sequences[1]

# convert tuple to string

def convertTuple1(tup):
    seq1 = ''
    for item in tup:
        seq1 = seq1 + item
    return seq1

def convertTuple2(tup):
    seq2 = ''
    for item in tup:
        seq2 = seq2 + item
    return seq2

seq1 = convertTuple1(sequence1)
seq2 = convertTuple2(sequence2)

# print(seq1)
# print(seq2)


# Two example sequences to match
 # seq1 = "CAATTCGGAT"
 # seq2 = "ATCGCCGGATTACGGG"

# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest

l1 = len(seq1)
l2 = len(seq2)
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2
    s2 = seq1
    l1, l2 = l2, l1 # swap the two lengths

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint):
    """A function that computes a score by returning the number of matches starting
from arbitrary startpoint (chosen by user)"""
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"
    
    # print("." * startpoint + matched)
    # print("." * startpoint + s2)           
    # print(s1)
    # print(score)
    # print(" ")

    
    return score

# Test the function with some example starting points:
calculate_score(s1, s2, l1, l2, 0)

# calculate_score(s1, s2, l1, l2, 1)
# calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score) for the two sequences
my_best_align = None
my_best_score = -1

for i in range(l1): # Note that you just take the last alignment with the highest score
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        my_best_align = "." * i + s2 # think about what this is doing! answer: adding full stops so they print ontop of each other in the best alignement position
        my_best_score = z 

# print(my_best_align)
# print(s1)

# print("Best score:", my_best_score)

def main(argv):
    print("The best alignment score possible between these two sequences is", my_best_score)
    print("The two sequences best match position is:")
    print(my_best_align)
    print(s1)
    return 0


with open('../results/DNA_results.txt', 'w') as DNA_results:
    message = "The best possible alignement score is " + str(my_best_score)
    alignment = my_best_align
    seqe1 = s1
    DNA_results.write(message)
    DNA_results.write("\n")
    DNA_results.write(alignment)
    DNA_results.write("\n")
    DNA_results.write(seqe1)

# sys.exit("I am exiting right now!")

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)
