
import pandas as pd
import sys
import os
import pathlib
import subprocess
import argparse
import glob
import csv
import shutil




'''

Goal of this program is to perform the following:

Take a csv file and grab the information from the target identifying number column
Probably going to store that information in a list that we will later iterate through
With that target ID, grab from the NCBI database the associated fasta and store it within a temporary directory

Once all of the files are collected, the program will then run BLASTP on each of the collected fasta files
BLASTP will be run on the human proteome as we are doing a version of a reciprocal search

Essentially, we want to find out what if the specific target sequence aligns more closely to AKT or to S6K
If the alignment shows that it aligns (Highest BitScore) with AKT, then we want to keep that particular query ID and Fasta
We need to be able to see the description of the protein and see if it says the words AKT or RAC-Alpha Ser/Thr Kinase
If the alignment aligns to S6K or neither of them, then we want to remove the particular Fasta and ID

Once we have gone through all of the fasta files within the temporary directory, we then want to remove it
This is for storage management purposes and tidyness

We should hopefully at this point have saved all of the fasta files that meet the criteria and have a list of the ID's
We then want to take the original csv file and filter out all the ID's that do not match the found criteria

From there, we are going to send this modified csv file with the gathered information to R for easier visualization


Version 1.0
Kyle Johnson, 2025

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
    parser.add_argument('-o', help="Output directory for storing outputted new csv file")
    arg = parser.parse_args()

    inputDirectory = pathlib.Path(arg.i)
    # Will modify later to enable a custom output directory instead of a pre-determined one
    outputDirectory = pathlib.Path(arg.o)

    tempFastaDirectory = pathlib.Path("/home/user/documents/report.txt")
    tempBLASTDirectory = pathlib.Path()
    homeDirectory = pathlib.Path(os.getcwd())


    IDList = None
    BlastCommand = ""
    # Debating if we should have the BLAST command also be run for creating a db for different searches


    # Lists for all of the potential names for proteins of interest

    AKTList = ['AKT', 'RAC', 'Protein Kinase B']
    S6KList = ['S6K', 'ribosomal protein S6 kinase', 'p70S6K']
    SGKList = ['SGK']


    # Read in the csv files and save the IDs as a list
    # We are also going to do some more work in this loop
    # We read in the file from the input directory
    # Read in the csv file as a csv object
    # convert the column tar to a list object and save it
    for file in inputDirectory.rglob('*.csv'):

        fileName = str(pathlib.Path(file).stem)
        currentCsv = pd.read_csv(file)
        currentCsv['description'] = 'Other'
        IDList = currentCsv['tar'].tolist()

        # This for loop runs the run function using the wget command line argument
        # wget retrieves information from a http source, in this case ncbi entrez eutils efetch
        # This enables us to download the fasta files
        # We are going to use the fasta files for the BLAST reciprocal searching

        # Ensuring the Temp directory exists
        directory_make(tempFastaDirectory)

        #These are the fasta file output directories to be used
        directory_make(f'{homeDirectory}/AKT/{fileName}')
        directory_make(f'{homeDirectory}/S6K/{fileName}')
        directory_make(f'{homeDirectory}/SGK/{fileName}')
        directory_make(f'{homeDirectory}/Other/{fileName}')

        for ID in IDList:
            run(f'wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id={ID}&rettype=fasta" -O {tempFastaDirectory}/{ID}.fa')

        for fasta in tempFastaDirectory.rglob("*.fa"):

            ID = str(pathlib.Path(fasta).stem)
            directory_make(tempBLASTDirectory)
            run(BlastCommand)
            currentBlastCsv = pd.read_csv(tempBLASTDirectory)
            # May need to assign a header to the currentBlastCsv depending on output
            # Get the row with a maximum bit score value
            max_ID = currentBlastCsv['dom_score'].idxmax()
            max_row = currentBlastCsv.loc[max_ID]

            AKTpattern = '|'.join(AKTList)
            S6Kpattern = '|'.join(S6KList)
            SGKpattern = '|'.join(SGKList)

            if max_row['description'].str.contains(AKTpattern, case=False,na=False):
                # Save the fasta file to a directory (maybe cp it?)
                # Find the value of the specific id and change the description to match the AKT
                # CP SOURCE DESTINATION
                run(f"cp {tempFastaDirectory} {homeDirectory}/AKT/{fileName}/")
                currentCsv.loc[currentCsv['tar'] == ID, 'description'] = 'AKT'

            if max_row['description'].str.contains(S6Kpattern, case=False,na=False):
                run(f"cp {tempFastaDirectory} {homeDirectory}/S6K/{fileName}/")
                currentCsv.loc[currentCsv['tar'] == ID, 'description'] = 'S6K'

            if max_row['description'].str.contains(SGKpattern, case=False,na=False):
                run(f"cp {tempFastaDirectory} {homeDirectory}/SGK/{fileName}/")
                currentCsv.loc[currentCsv['tar'] == ID, 'description'] = 'SGK'

            else:
                run(f"cp {tempFastaDirectory} {homeDirectory}/Other/{fileName}/")

        directory_remove(tempFastaDirectory)
        directory_make(f'{homeDirectory}/Script_Results/{fileName}')
        currentCsv.to_csv(f'{homeDirectory}/Script_Results/{fileName}/{fileName}.csv')
        print(f"Created csv at {homeDirectory}/Script_Results/{fileName}/{fileName}.csv")




































