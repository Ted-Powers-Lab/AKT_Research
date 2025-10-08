import pathlib
import sys
import os
import argparse
import glob
import csv
import subprocess
import pandas as pd


def main():

    parser = argparse.ArgumentParser()
    parser.add_argument('-i', help='Input for the directory containing Fasta files that are to be merged')
    parser.add_argument('-hmms', nargs='+', type=str,  help='Input for list of hmms to search for and find the duplicates for')
    parser.add_argument('-c', type=int, help='Input for how many times a protein must appear to be considered viable. Default is 2')
    parser.add_argument('-filename', help='Desired file name, defaults to "combined.csv" ')
    arg = parser.parse_args()

    # Check for any trailing slashes in the input
    inputDirectory = pathlib.Path(arg.i)
    stripped_path_str = str(inputDirectory).rstrip('/')
    inputDirectory = pathlib.Path(stripped_path_str)

    # Create default name for file is one is not provided
    if arg.filename is not None:
        filename = arg.filename
    else:
        filename = "combined.csv"

    # List for hmms that the user will input
    searchList = arg.hmms
    Mastercsv = pd.DataFrame()
    MasterList = []
    count = arg.c
    clades = ['Discoba',
              'Metamonada',
              'Stramenopiles',
              'Alveolata',
              'Rhizaria',
              'Chlorophyta',
              'Rhodophyta',
              'Streptophyta',
              'Fungi', 'Metazoa']


    for csv in inputDirectory.rglob('*.csv'):
        csvName = csv.parts
        rootname = csv.stem
        print(rootname)
        rootList = str(rootname).split("_")
        print(rootList)
        if filename in str(csvName):
            print("File already found, skipping")
            continue
        else:
            pass

        # Check to see if the hmms are in the name of the file
        for hmm in rootList:
            if hmm in searchList:
            # Check to see if the
                currentdf = pd.read_csv(csv)
                print(currentdf)
                MasterList.append(currentdf)
            else:
                continue


    # Now we are going to check for the duplicated elements within the master csv
    # Then we are going to write to the input directory with the attached filename
    Mastercsv = pd.concat(MasterList, ignore_index=True)
    Mastercsv = Mastercsv.groupby('tar').filter(lambda x: len(x) > count)
    Mastercsv.to_csv(f'{inputDirectory}/{filename}', index=False)

if __name__ == "__main__":
    main()





