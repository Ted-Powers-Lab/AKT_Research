import pandas as pd
import sys
import os
import pathlib
import subprocess
import argparse
import glob
import csv
'''
PostProcessing.py

Overall aim of this program: To take in a reference set of proteins (in this case we are interest in the protein Kinase B),
take in two comparison sets of proteins (can be anything but in our case the PH Domain and the Protein Kinase C-Term)
and then output the shared targets of all three of the sets

The program is divided into two sections: one section is the functions for the comparisons and the other section handles
the reading in and out of the different csv files from their associated directories.

This program tries to use only python native libraries but due to the issue of reading large volumes of CSV files,
the pandas library is also required to be installed in the local environment

This program was written by Kyle A. Johnson with help and assistance from Dr. Ian Korf at the University of California, Davis, 2025




'''
# Make sure to have pandas installed in the local environment when running this program

def AKTComparison (proteinKinase, PHDomain, PKCTerm):

    commonValues = proteinKinase[proteinKinase['tar'].isin(PHDomain['tar'])]
    commonValues = commonValues[commonValues['tar'].isin(PKCTerm['tar'])]
    commonValues = commonValues.sort_values(by='full_score', ascending=False)
    return(commonValues)


def main():

    parser = argparse.ArgumentParser()
    parser.add_argument('-ref', help='reference input directory')
    parser.add_argument('-comp1', help='comparison input directory 1')
    parser.add_argument('-comp2', help='comparison input directory 2')
    parser.add_argument('-out', help='output file for the comparison csv')
    arg = parser.parse_args()

    referenceDir  = pathlib.Path(arg.ref)
    comparisonDir1 = pathlib.Path(arg.comp1)
    comparisonDir2 = pathlib.Path(arg.comp2)
    outputDir = pathlib.Path(arg.out)

    # Future update to the clades will be needed to include opisthonkonta and other related organisms
    clades = ['Discoba', 'Metamonada', 'Stramenopiles', 'Alveolata', 'Rhizaria', 'Chlorophyta', 'Rhodophyta',
              'Streptophyta']

    for refCsv in referenceDir.rglob('*.csv'):
        names = refCsv.parts
        for item in names:
            for element in clades:
                if element == item:
                    cladeName = element
                else:
                    continue
        protKinase = pd.read_csv(refCsv)
        if len(protKinase) != 0 :
            proteinKinaseAcc = protKinase.iloc[0, 10]
        else:
            continue
        for comp1Csv in comparisonDir1.rglob('*.csv'):
            PHDomain = pd.read_csv(comp1Csv)
            if len(PHDomain) != 0:
                PHDomainAcc = PHDomain.iloc[0, 10]
            else:
                continue
            if proteinKinaseAcc != PHDomainAcc:
                continue
            else:
                pass
            for comp2Csv in comparisonDir2.rglob('*.csv'):
                PKCTerm = pd.read_csv(comp2Csv)

                if len(PKCTerm) != 0:
                    PKCTermAcc = PKCTerm.iloc[0, 10]
                else:
                    continue
                if proteinKinaseAcc == PHDomainAcc and proteinKinaseAcc == PKCTermAcc:
                    results = AKTComparison(protKinase, PHDomain, PKCTerm)

                    if not os.path.exists(f'{outputDir}/{cladeName}'):
                        os.makedirs(f'{outputDir}/{cladeName}')
                        print(f"Directory doesn't exist, making directory at: ", {outputDir})
                    else:
                        print(f"Directory Exists, continuing without making a new directory")
                    results.to_csv(f'{outputDir}/{cladeName}/{proteinKinaseAcc}.csv', index=False)
                else:
                    continue


if __name__=="__main__":
    main()