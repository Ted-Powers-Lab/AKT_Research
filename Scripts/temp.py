# -*- coding: utf-8 -*-
"""
Kyle Johnson
1/26/2026

Purpose of the script is read in fasta files from a directory and create a "pool"
This pool of sequences will then be used in a genetic algorithm
Purpose of this algorithm is to help select the sequences within the pool most
fitted towards becoming an HMM for SGK or for S6K

In order to determine the "fitness" of the sequences, reference sequences will be provided
These references will then be used with other additional programs (BLAST?) to create scores
These scores will then be thrown into the fitness function to generate a score
and then attach this score to the same sequence

"""

from Bio import SeqIO
import os

# Simple function for reading in fasta files using biopython and outputting them into a list
def read_fasta(directory):
    sequences = []
    for filename in os.listdir(directory):
        if filename.lower().endswith((".fasta", ".fa", ".fnas")):
            filepath = os.path.join(directory, filename)
            for record in SeqIO.parse(filepath, "fasta"):
                sequences.append(str(record.seq))
    return sequences

def fitness(sequence, reference_seq):
    # This function is going to need to blast the sequence to the reference
    # Is this the best approach at this time?
    # We need something to be able to compare
    
    pass

# Function that will define an "organism" that is one of the sequences from within the population
def seq_organism(sequence):
    pass

def mutate():
    pass

def mate():
    # This is "mating" function
    # 
    pass


mutrate = .5



directory = "C:/Users/kajoh/OneDrive/Desktop/100FilterMerge"
sequence_pool = read_fasta(directory)











    


