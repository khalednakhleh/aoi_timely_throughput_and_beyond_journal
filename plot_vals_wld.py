


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
regime_selection = 1 # 1 for under-loaded and 2 for over-loaded
RUNS = 10

delay_total_vals = [] # these are the delay values we ran the simulations for.
selected_run = '' # exact file name to plot
filename = 'results/'+selected_run+'/' # starting point 



######################
# plot the average value for different delay values (delay value on the x-axis and the interuption rate on the y-axis)

tot_avg_empirical_values = []
tot_theoretical_values = []

for delay_value in delay_total_vals:
    empirical_avg_values = []
    theoretical_values = []


    for current_run in range(RUNS):
        run_file = filename+'run_'+run+'.csv'
        data_values = pd.read_csv(run_file)
        empirical_avg_values.append(data_values.iloc[])
        theoretical_values = data_values.iloc[]


    empirical_avg_values = sum(empirical_avg_values) / RUNS 
    tot_avg_empirical_values.append(empirical_avg_values)
    tot_theoretical_values.append(theoretical_values)




plt.plot(delay_vals, tot_avg_empirical_values, label='Empirical value', zorder=1, color='C0', linestyle='solid')
plt.plot(delay_vals, tot_theoretical_values, label='Theoretical value', zorder=2, color='C1', linestyle='dotted')






plt.savefig('num_clients_'+num_clients+'_regime_selection_'+regime_selection+'_runs_'+runs+'.pdf')
plt.show()