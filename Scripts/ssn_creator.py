# -*- coding: utf-8 -*-
"""
Created on Mon Jan 26 13:45:51 2026

@author: kajoh
"""
import pandas as pd
import networkx as nx


# Global Variables
SCORE_COLUMN = "bitscore"
# Modify this to generate different ssns
THRESHOLD = 350

# Load the BLAST report
def load_blast_tsv(path):
    cols = [
        "qseqid", "sseqid", "pident", "length", "mismatch",
        "gapopen", "qstart", "qend", "sstart", "send", "evalue", "bitscore"]
    df = pd.read_csv(path, sep="\t", names=cols)
    return df

# Function that removes reciprocals from an all-vs-all blast and returns df
def remove_reciprocal(df):
    seen = set()
    rows = []
    for _, row in df.iterrows():
        q = row['qseqid']
        s = row['sseqid']
        
        pair = tuple(sorted([q,s]))
        
        if pair not in seen:
            seen.add(pair)
            rows.append(row)
            
    # Build the new dataframe with the cleaned data
    cleaned_df = pd.DataFrame(rows)
    return cleaned_df


    

# Build the SSN
def build_ssn(df, score_col, threshold):
    G = nx.Graph()
    
    for _, row in df.iterrows():
        q = row["qseqid"]
        s = row["sseqid"]
        score = row[score_col]
        
        # Adding Nodes
        G.add_node(q)
        G.add_node(s)
        
        # Add edge if similarity passes threshold
        if score >= threshold:
            G.add_edge(q, s, weight = score)
    return G

def save_network(G, out_file):
    nx.write_graphml(G, out_file)
    print(f"Network file saved to {out_file}")

# Main
if __name__ == "__main__":
    df = load_blast_tsv("C:/Users/kajoh/OneDrive/Desktop/200filter_blast_results.tsv")
    print("Finished loading in the dataframe object")
    print("About to build the ssn")
    G = build_ssn(remove_reciprocal(df), SCORE_COLUMN, THRESHOLD)
    
    print(f"Nodes: {G.number_of_edges()}")
    print(f"Edges: {G.number_of_edges()}")
    
    save_network(G, "C:/Users/kajoh/OneDrive/Desktop/200filterssn.graphml")
        
    


