import pandas as pd
import sys
import os
import pathlib
import subprocess
import argparse
import glob
import csv










def runInterproScan (fastaFile, outputDirectory):
    # Purpose of this function is to run the interproscan program using an inputted fasta file
    # Must have an alias that points to the interproscan program for this to work
    # Alias must be interpro. We want the input, model to use, output format to give

    fastaFilename = fastaFile.stem
    output_filename = f'{fastaFilename}.tsv'
    output_filepath = os.path.join(outputDirectory, output_filename)
    os.makedirs(outputDirectory, exist_ok=True)

    command = ["/quobyte/ikorfgrp/project/torture/Programs/InterProDB/interproscan-5.75-106.0/interproscan.sh",
               f" -i {fastaFile}",
               " -f TSV",
               " -appl Pfam",
               f" -d {outputDirectory}"]
    subprocess.run(command)
    print("Successfully ran the interproscan program")







def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", help="Input for the fasta file directory")
    parser.add_argument("-o", help="Desired Output directory for interpro analysis")
    arg = parser.parse_args()


    Fasta_directory = pathlib.Path(arg.i)
    output_Directory = pathlib.Path(arg.o)


    clades = ['Alveolata', 'Chlorophyta', 'Discoba',
              'Metamonada', 'Rhizaria', 'Rhodophyta',
              'Stramenophiles', 'Streptophyta']
    
    for fastaFile in pathlib.Path(Fasta_directory).rglob('*.faa'):
         print(f"Initalizing Interproscan Program on {fastaFile}")
         runInterproScan(fastaFile, output_Directory)


         







if __name__ == "__main__":
        main()