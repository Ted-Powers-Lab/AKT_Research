from ctypes.macholib.dyld import dyld_framework_path

import pandas as pd
import sys
import os
import pathlib
import subprocess
import argparse
import glob
import csv


# for hmm in a list of hmm (make a list of hmms)
# if element matches a one of hmms in the list, grab the csv in that hmm and store it
# concat all the csvs into a big master
# find duplicates in this master table

def comparison_finder(comparison_dir): #inputs should be the comparison folder and the reference csv file

    csv_list = []  # empty list where we will store csv files for merging
    hmm_list = ['PF00168', 'PF00169', 'PF00433', 'proteinKinaseB']

    for csv_file in pathlib.Path(comparison_dir).rglob('*.csv'):  #look for files in the input directory ending in .csv

        #check if hmm is part of csv file name
        for hmm in hmm_list:
            if hmm in csv_file.stem:
                current_csv = pd.read_csv(csv_file) #read in the csv file and append it to csv_list
                csv_list.append(current_csv) #merge the csvs
            else:
                continue

    #merge csvs in the csv_list
    results = pd.concat(csv_list)

    #count the number of tar duplicates check if it is greater than the number of csv files put in
    #if it is greater than 3 all csv files have a matching tar value
    count = results.groupby(['tar']).size()
    duplicates = count[count>=3].index

    #if the result fulfils the condition in duplicates return those results as a csv
    results = results[results['tar'].isin(duplicates)]
    #keep only the first occuring row of tar duplicates
    results = results.drop_duplicates(subset=['tar'], keep ='first')
    return results


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-dir', help='folder of the clade in which you want to run the comparison')
    #parser.add_argument('-i', help='reference csv')
    arg = parser.parse_args()

    comparison_dir = pathlib.Path(arg.dir) # set the comparison directory equal to what the user inputs

    results = comparison_finder(comparison_dir)

    results.to_csv(f'{comparison_dir}/compareTar.csv', index = False)  # make the csv file comparing the tar values

if __name__ == '__main__':
    main()































































