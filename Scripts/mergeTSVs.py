import pandas as pd
import sys
import os
import pathlib
import subprocess
import argparse
import glob
import csv

from pandas import merge

def tsv_merger(folder_path):
    #tsv_list = []
    #list to tsv rows
    merged_rows = []
    #ignore column headers
    header_written = False

    #look through each folder for files that end with .tsv
    for tsv in pathlib.Path(folder_path).rglob("*.tsv"):

        # open and read each file as a tsv
        # delete empty space in between each line of the tsv files
        # utf-8 ensures computer can read the file as text

        with open(tsv, "r", newline = "", encoding = "utf-8") as tsv_file:
            current_tsv = csv.reader(tsv_file, delimiter="\t")

            #make sure each column and row labels are not duplicated
            for i, row in enumerate(current_tsv):
                if i == 0 and header_written:
                    continue

                #merge the all tsv files by combining every row
                merged_rows.append(row)


    return merged_rows

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', help='Highest level of directory you want to combine tsv files in')
    arg = parser.parse_args()

    #set current directory to the input
    input_directory = pathlib.Path(arg.i)

    #place output files in a new directory
    output_directory = pathlib.Path(arg.i)/"Combined_tsv_outputs"

    # check if subfolders in the directory have a fild that matches a clade name
    # make the path to the clade folder if the clade name matches
    clades = ['Discoba', 'Metamonada', 'Opisthokonta', 'Stramenopiles']

    for clade_name in clades:
        folder_path = input_directory / clade_name
        if not folder_path.exists():
            print(f"Folder {folder_path} does not exist")
            continue

        # call tsv merger function
        merged_rows = tsv_merger(folder_path)

        #output it as a combine tsv file
        output_file = f"Combined_tsv_{clade_name}.tsv"

        if not output_directory.exists():
            os.makedirs(output_directory, exist_ok=True)

        output_file_path = os.path.join(output_directory, output_file)

        #open the output file
        with open(output_file_path, 'w', newline='', encoding = "utf-8") as outfile:

        # write out the text in the row
        # seperate text by tab
        # once the row is finished, start a new line
            for row in merged_rows:
                outfile.write("\t".join(row) + "\n")




if __name__ == "__main__":
    main()
















