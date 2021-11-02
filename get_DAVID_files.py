import pandas as pd

'''script extracts gene list of up regulated and downregulated genes \
and writes them into separate files for pathway analysis using DAVID'''


# BPHvCaP
def get_david_file(csv_file, out_file_name_down, out_file_name_up):
    # read in CSV file
    csv_file = pd.read_csv(csv_file)
    
    # check which genes are upregulated and downregulated
    csv_file['log2FoldChange'] = csv_file['log2FoldChange'] > 0
    
    # filter for upregulation
    csv_file_up = csv_file[csv_file['log2FoldChange'] == True]
    
    # filter for downregulation
    csv_file_down = csv_file[csv_file['log2FoldChange'] == False]
    
    # select gene lists
    gene_list_up = csv_file_up.iloc[:, 0]
    gene_list_down = csv_file_down.iloc[:, 0]
    
    # drop indexes
    gene_list_up = gene_list_up.reset_index(drop = True)
    gene_list_down = gene_list_down.reset_index(drop = True)
    
    # convert series to strings
    gene_list_up_str = gene_list_up.to_string(index = False, header = 'None')
    gene_list_down_str = gene_list_down.to_string(index = False, header = 'None')
    
    # write gene lists to files
    
    with open(out_file_name_up, 'w') as f:
        f.write(gene_list_up_str)
        
    with open(out_file_name_down, 'w') as f:
        f.write(gene_list_down_str)
    
    # remove spaces from files
    
    with open(out_file_name_up, 'r') as f:
        lines = f.readlines()
    
    # remove spaces
    lines = [line.replace(' ', '') for line in lines]
    
    with open(out_file_name_up, 'w') as f:
        f.writelines(lines)
        
    with open(out_file_name_down, 'r') as f:
        lines = f.readlines()
    
    # remove spaces
    lines = [line.replace(' ', '') for line in lines]
    
    with open(out_file_name_down, 'w') as f:
        f.writelines(lines) 

get_david_file('P10_11v17_18.csv','P10_11v17_18_down.txt','P10_11v17_18_up.txt' )
