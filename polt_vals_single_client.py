


import numpy as np
import pandas as pd 
import matplotlib.pyplot as plt 
import matplotlib as mpl 


#mpl.use('pgf')


WIDTH = 14 
HEIGHT = 3.5 

plt.rcParams['font.size'] = 14 
plt.rcParams['legend.fontsize'] = 14 

plt.rcParams['pdf.fonttype'] = 42 
plt.rcParams['ps.fonttype'] = 42
plt.rcParams['font.family'] = 'Times New Roman'




#CONSTANTS for plotting

timesteps = 150000
num_clients = 1
regime_selection = 1
runs = 10
time = ''



######################


delay_total_vals = []
empirical_avg_values = []
theoretical_values = []


for delay in delay_total_vals:

    filename = "results/.txt"
    data_values = pd.read_csv(filename)
    empirical_avg_values.append(data_values.iloc[])
    theoretical_values.append(data_values.iloc[])


plt.plot(delay_vals, empirical_avg_values, label='Empirical value', zorder=1, color='C0', linestyle='solid')
plt.plot(delay_vals, theoretical_values, label='Theoretical value', zorder=2, color='C1', linestyle='dotted')






plt.savefig('num_clients_'+num_clients+'_regime_selection_'+regime_selection+'_runs_'+runs+'.pdf')
plt.show()