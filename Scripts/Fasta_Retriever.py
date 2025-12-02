
import pathlib
import sys
import os
import argparse
import pandas as pd
import shutil




'''

Goal of this program is to take in a csv file(s), read in the targets and store them to list
Once a list has been generated, use the list and run it through a wget command to retrieve the fasta files from ncbi
Store the ncbi files within a default directory or user inputted directory

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

    parser = argparse.ArgumentParser()
    parser.add_argument("-i", help= "Input directory location or specific csv file")
    parser.add_argument("-o", help= "Output directory location. Optional")
    arg = parser.parse_args()

    path_to_check = arg.i
    homeDirectory = pathlib.Path(os.getcwd())

    #Establishes a default directory or user generated directory
    if arg.o is None:
        directory_make(f"{homeDirectory}/OutputFasta")
        output_directory = f"{homeDirectory}/OutputFasta"

    else:
        output_directory = pathlib.Path(arg.o)
        directory_make(output_directory)

    # Check to see if the path_to_check is a directory link or a file link
    if os.path.exists(path_to_check):
        if os.path.isfile(path_to_check):
            root, extension = os.path.splitext(path_to_check)
            if extension == ".csv":
                dataframe = pd.read_csv(f'{homeDirectory}/{path_to_check}')
                tarList = dataframe['hit_id'].tolist()
                for target in tarList:
                    run(f"wget 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id={target}&rettype=fastaff' -O {output_directory}/{target}.fa")
                else:
                    print("This file is not a csv file", file=sys.stderr)
                    sys.exit(1)

            # Read in the csv file here and run it on the appropriate things

        if os.path.isdir(path_to_check):
            dirpath = pathlib.Path(path_to_check)
            for csv in dirpath.rglob("*.csv"):
                dataframe = pd.read_csv(csv)
                tarList = dataframe['hit_id'].tolist()
            for target in tarList:
                run(f"wget 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id={target}&rettype=fastaff' -O {output_directory}/{target}.fa")
        else:
            print("No file or directory has been inputted", file=sys.stderr)
            sys.exit(1)


if __name__ == "__main__":
    main()













