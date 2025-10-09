dataframe = []  # empty list where we will store csv files for merging
master_csv = pd.DataFrame()  # constructs an empty data frame for the giant merged csv file for comparison

    for csv_file in pathlib.Path(comparison_dir).rglob('*.csv'):  #for all files in the input directory look for any ending with .csv

        if input_ref: #ignore the reference file
            pass
        if not input_ref:
            current_csv = pd.read_csv(csv_file)  # read the current csv
            dataframe.append(current_csv)  # add current to the csv storage list
            master_csv = pd.concat(dataframe, ignore_index=True)  # merge csvs in that list