import pandas as pd
import sys
import os
import pathlib
import subprocess
import argparse
import glob
import csv



def csv_combine(input_dir):
    csvList = []
    merged_df = pd.DataFrame()
    for csv in pathlib.Path(input_dir).rglob("*.csv"):
        currentcsv = pd.read_csv(csv)
        csvList.append(currentcsv)
        merged_df = pd.concat(csvList, ignore_index=True)

    return merged_df


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', help='Highest level of directory you wish to combine csvs in')
    arg = parser.parse_args()

    input_directory = pathlib.Path(arg.i)
    current = os.path.dirname(os.path.realpath(__file__))

    clades = ['Discoba', 'Metamonada', 'Stramenopiles', 'Alveolata', 'Rhizaria', 'Chlorophyta', 'Rhodophyta', 'Streptophyta',
              'Fungi', 'Metazoa']

    hmms = ['PF00168', 'PF00169', 'PF00433', 'proteinKinaseB']


    all_subdirectories = [item for item in input_directory.rglob('*') if item.is_dir()]

    for dir in all_subdirectories:
        for hmm in hmms:
            if hmm in str(dir):
                for cladeName in clades:
                    if cladeName in str(dir):
                        results = csv_combine(dir)
                        # Check if the output directory exists, create if not
                        if not os.path.exists(f'{current}/Results/{cladeName}_Combined/'):
                            os.makedirs(f'{current}/Results/{cladeName}_Combined/')
                        else:
                            pass
                        results.to_csv(f'{current}/Results/{cladeName}_Combined/{cladeName}_{hmm}_Combined.csv')
                        print("Successfully Created combined csv file")
                    else:
                        continue
            else:
                continue

if __name__=="__main__":
    main()



