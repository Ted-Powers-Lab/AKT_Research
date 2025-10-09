from ctypes.macholib.dyld import dyld_framework_path

import pandas as pd
import sys
import os
import pathlib
import subprocess
import argparse
import glob
import csv

from numpy.ma.extras import column_stack


#we want to pull the reference protein kinase B from the folder and store it somewhere we can use
#merge the remaining csv files into one master csv
#compare the tar value from the reference and the master


def comparison_finder(comparison_dir, input_ref): #inputs should be the comparison folder and the reference csv file

    dataframe = []  # empty list where we will store csv files for merging
    master_csv = pd.DataFrame()  # constructs an empty data frame for the giant merged csv file for comparison


    ref_filepath = os.path.join(comparison_dir, input_ref)  # join path for hmm directory and csv
    with open(ref_filepath, 'r') as file: #open reference file
        ref_file = pd.read_csv(file) #read in file as a csv


    for csv_file in pathlib.Path(comparison_dir).rglob('*.csv'):  # for all files in the input directory look for any ending with .csv

        if csv_file is ref_file:  # if the csv_file is the reference file ignore it
            continue

        if not csv_file is ref_file:
            current_csv = pd.read_csv(csv_file)  # read the current csv
            dataframe.append(current_csv)  # add current to the csv storage list


    master_csv = pd.concat(dataframe, ignore_index=True)  # merge the csvs in the list into a master csv
    results = pd.concat([master_csv, ref_file])
    results = results['tar']
    results = results[results.duplicated(keep=False)]
    results = results.unique()


    #results = [ref_file['tar'].isin(master_csv['tar'])] # compare if tar in the reference and combined are the same


    return results


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-dir', help='folder of the clade in which you want to run the comparison')
    parser.add_argument('-i', help='reference csv')
    arg = parser.parse_args()


    comparison_dir = pathlib.Path(arg.dir) # set the comparison directory equal to what the user inputs
    input_ref = pathlib.Path(arg.i) # set the reference file to what the user inputs

    results = comparison_finder(comparison_dir, input_ref)
    #results_ls = [results] #list of results
    #results_df = pd.DataFrame(results_ls)
    results.to_csv(f'{comparison_dir}/compareTar.csv')  # make the csv file comparing the tar values

if __name__ == '__main__':
    main()































































