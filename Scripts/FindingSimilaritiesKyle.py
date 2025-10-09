
import pandas as pd
import sys
import os
import pathlib
import subprocess
import argparse
import glob
import csv


#we want to pull the reference protein kinase B from the folder and store it somewhere we can use
#merge the remaining csv files into one master csv
#compare the tar value from the reference and the master


def comparison_finder(comparison_dir, reference_csv): #inputs should be the comparison folder and the reference csv file

    csv_list = []  # empty list where we will store csv files for merging
    master_csv = pd.DataFrame()  # constructs an empty data frame for the giant merged csv file for comparison

    # Iterate through the specified directory from input and find all files that have a .csv extension
    for csv_file in pathlib.Path(comparison_dir).rglob('*.csv'):
        # Read in the current csv file
        current_csv = pd.read_csv(csv_file)
        # Check to see if the current csv is the same as the reference csv
        if current_csv.equals(reference_csv):
            continue
        else:
            csv_list.append(current_csv)  # add current to the csv storage list

    # merge the csvs in the list into a master csv
    master_csv = pd.concat(csv_list, ignore_index=True)
    results = pd.concat([master_csv, reference_csv])

    # Find all rows that have the same target row and save them to a new dataframe (Find duplicates)
    results = results[results.duplicated(subset=['tar'], keep='first')]
    # Count out the number of targets by number of elements within the group (How many duplicates)
    count = results.groupby('tar').size()
    # Create a new dataframe that checks and sees if the number of elements within the count object is greater than 3
    # This is to assess whether the number of targets is greater than what was put in, indicating presence in all csvs
    duplicates = count[count >= 3].index
    # Finally save the results by only selecting the targets that are also in the conditional duplicates (Selecting)
    results = results[results['tar'].isin(duplicates)]

    return results


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-dir', help='folder of the clade in which you want to run the comparison')
    parser.add_argument('-i', help='reference csv input call')
    arg = parser.parse_args()

    # Grab the directory information from the user
    comparison_dir = pathlib.Path(arg.dir)
    # Grab the reference csv file from the user
    input_ref = pd.read_csv(str(arg.i))


    results = comparison_finder(comparison_dir, input_ref)
    results.to_csv(f'{comparison_dir}/compareTar.csv')  # make the csv file comparing the tar values

if __name__ == '__main__':
    main()































































