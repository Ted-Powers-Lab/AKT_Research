import pathlib
import sys

import Bio
import os
import argparse
import pandas as pd
import shutil
from Bio import SeqIO
from Bio import SearchIO
import numpy as np


'''
Goal of this program is to do the following:
Take in a proteomic file and run the hmmer2 command on said file.
Save the output of the hmmer run to a temporary file
From the temporary file, parse the data using biopythons built in features and save to a dataframe
With the dataframe, save the resulting file as a csv within a specific output directory

Written By: Kyle Johnson, 2025
'''


def run(cmd):
    print(cmd, file=sys.stderr)
    os.system(cmd)

def directory_make(directoryString):

    if not os.path.exists(f'{directoryString}'):
        os.makedirs(f'{directoryString}')
    else:
        pass

def directory_remove(directoryString):
    shutil.rmtree(directoryString)





def main():
    # We are going to want the user to input the csv file of choice from the command line
    # We are going to want the user to also give an output file of choice

    # We are then going to handle everything else
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', help="Input directory containing csv files")
    parser.add_argument('-hmm', help="HMM file input")
    parser.add_argument('-o', help="Output directory for storing outputted new csv file, defaults to if no data provided")
    arg = parser.parse_args()

    clades = ['Discoba',
              'Metamonada',
              'Stramenopiles',
              'Alveolata',
              'Rhizaria',
              'Chlorophyta',
              'Rhodophyta',
              'Streptophyta',
              'Opisthokonta']


    input_directory = pathlib.Path(arg.i)
    output_directory = None
    hmmfile = pathlib.Path(arg.hmm)
    homeDirectory = pathlib.Path(os.getcwd())

    if arg.o is None:
        directory_make(f"{homeDirectory}/Output_Default")
        output_directory = f"{homeDirectory}/Output_Default"

    else:
        output_directory = pathlib.Path(arg.o)
        directory_make(output_directory)

    print("About to enter the loop")
    print(f"{input_directory}")

    # Now we iterate through the proteomes within the specified directory
    for proteome in input_directory.rglob('*.faa'):
        print("Looking for csvs")
        data = []
        # Grab the clade name found within the path
        # Grab the current accession number for the proteome
        names = proteome.parts
        acc = proteome.parts
        substring = 'GC'
        acc = list(s for s in acc if substring in s)
        acc = ", ".join(acc)
        cladeName = None
        for item in clades:
            if item in names:
                cladeName = item
            else:
                continue


        # Make the temporary directory
        directory_make(f"{homeDirectory}/Temp")
        #First we run the hmmer2 command and output to a temporary directory
        run(f"hmmsearch2 {hmmfile} {proteome} > {homeDirectory}/Temp/HMMER_Result.txt")

        #Now we parse the information from the hmmer results file
        hmmer2_results = SearchIO.parse(f"{homeDirectory}/Temp/HMMER_Result.txt",
                                        "hmmer2-text")
        for query_result in hmmer2_results:
            for hit in query_result:
                hit_data = {
                    "query_id": query_result.id,
                    "hit_id": hit.id,
                    "hit_eval": hit.evalue,
                    "hit_bitscore": hit.bitscore,
                    "hit_description": hit.description
                }
                data.append(hit_data)
                

        # We want to add the accession data here as well
        df = pd.DataFrame(data)
        df['accn'] = string(acc)
        directory_make(f"{output_directory}/{cladeName}/")
        df.to_csv(f"{output_directory}/{cladeName}/{acc}.csv")
        directory_remove(f"{homeDirectory}/Temp")


if __name__ == "__main__":
    main()












