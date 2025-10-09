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
    #parser.add_argument('-c', type=int, help='Input for how many times a protein must appear to be considered viable. Default is 2')
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
        filename = "potential_result.csv"

    # List for hmms that the user will input
    searchList = arg.hmms
    Mastercsv = pd.DataFrame()
    MasterList = []

    # Change count to be indicative of the length of the search list. Future update.
    number_hmms = int(len(arg.hmms))
    print(number_hmms)


    clades = ['Discoba',
              'Metamonada',
              'Stramenopiles',
              'Alveolata',
              'Rhizaria',
              'Chlorophyta',
              'Rhodophyta',
              'Streptophyta',
              'Fungi',
              'Metazoa',
              'Opisthokonta']


    for csv in inputDirectory.rglob('*.csv'):
        csvName = csv.parts
        rootname = csv.stem
        rootList = str(rootname).split("_")
        if filename in str(csvName):
            print("File already found, skipping")
            continue
        else:
            pass

        # Check to see if the hmms are in the name of the file
        for hmm in rootList:
            if hmm in searchList:
                print(hmm)
            # Check to see if the
                currentdf = pd.read_csv(csv)
                MasterList.append(currentdf)
            else:
                continue


    # Now we are going to check for the duplicated elements within the master csv
    # Then we are going to write to the input directory with the attached filename
    Mastercsv = pd.concat(MasterList, ignore_index=True)
    # To check the Mastercsv, also going to find all the duplicates and add the counts
    Mastercsv_string = Mastercsv.to_csv(index=False)
    #print(Mastercsv_string)
    # Find all of the duplicated values in the tar column
    duplicated_base = Mastercsv[Mastercsv.duplicated(subset=['tar'], keep=False)]
    duplicated_base_string = duplicated_base.to_csv(index=False)
    num_duplicates = Mastercsv.duplicated(subset=['tar']).sum()
    print("Here are the duplicated strings and the num of duplicates")
    #print(duplicated_base_string)
    print(num_duplicates)

    tar_counts = Mastercsv['tar'].value_counts()
    tar_counts = tar_counts[tar_counts > number_hmms]
    print("Here is the target count")
    print(tar_counts)
    print("Here is the sum of the counts")
    sum_tar_counts = tar_counts.sum()
    print(sum_tar_counts)


    count = Mastercsv.groupby('tar').size()
    duplicate_values = count[count >= number_hmms].index
    print("Here are the number of duplicate elements based upon conditions")
    print(len(duplicate_values))
    Mastercsv = Mastercsv[Mastercsv['tar'].isin(duplicate_values)]
    #Make the mastercsv contain only one value for target as that is all we need
    finalcsv = Mastercsv.drop_duplicates(subset=['tar'])
    #Mastercsv = Mastercsv.groupby('tar').filter(lambda x: len(x) >= count )
    print(Mastercsv['tar'].value_counts())
    print("Here are the grand total of targets to search for")
    print(finalcsv['tar'])
    print(Mastercsv['tar'].value_counts())
    finalcsv.to_csv(f'{inputDirectory}/{filename}', index=False)





if __name__ == "__main__":
    main()





