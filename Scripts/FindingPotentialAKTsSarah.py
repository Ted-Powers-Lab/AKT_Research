import pandas as pd
import sys
import os
import pathlib
import subprocess
import argparse
import glob
import csv

# merge csv files for each supergroup in the AKT folder for R analysis
# We want to filter bit scores greater than 100 in with R
def csv_combine(folder_path):

    csv_list = []
    merged_df = pd.DataFrame()

    for csv_file in pathlib.Path(folder_path).rglob("*.csv"):
        current_csv = pd.read_csv(csv_file)
        csv_list.append(current_csv)
        merged_df = pd.concat(csv_list, ignore_index=True)

    # return the dataframe
    return merged_df


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', help='Highest level of directory you wish to combine csvs in')
    arg = parser.parse_args()

    input_directory = pathlib.Path(arg.i)
    output_directory = pathlib.Path(arg.i)/"Potential_AKTs_Combined"

    # list of supergroups
    clades = ['Alveolata', 'Discoba', 'Metamonada', 'Stramenopiles', 'Rhizaria', 'Chlorophyta', 'Rhodophyta',
              'Streptophyta', 'Metazoa']






    # for each subdirectory in the input directory
    # check if the subdirectory matches a clade in clades
    # if there is a match combine the csvs in that folder

    for clade in clades:

        # make a path to each sub clade folder
        folder_path = input_directory / clade

        # check if the folder path exist
        if not folder_path.exists():
            print(f"Folder {folder_path} does not exist") # Check that we exclude Alveolata
            continue

        # merge the csvs
        results = csv_combine(folder_path)

        # make the output directory if it doesn't exist
        if not output_directory.exists():
            os.makedirs(output_directory, exist_ok=True)

        # generate the combined csv
        results.to_csv(f"{output_directory}/{clade}_Potential_AKTs_Combined.csv", index=False)








if __name__=="__main__":
    main()





