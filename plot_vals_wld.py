


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

delay_total_vals = [1,2,3,4,5,6,7,8,9,10] # these are the delay values we ran the simulations for.
selected_run = '' # exact file name to plot
filename = 'results/'+selected_run+'/' # starting point 

file_times = ['11_10_2022_18_38_03', '11_10_2022_18_38_41', '11_10_2022_18_39_56','11_10_2022_18_40_34', 
'11_10_2022_18_40_51', '11_10_2022_18_41_20','11_10_2022_18_41_39', '11_10_2022_18_41_57', '11_10_2022_18_42_27','11_10_2022_18_42_52']

######################
# plot the average value for different delay values (delay value on the x-axis and the interuption rate on the y-axis)

tot_avg_empirical_values = []
tot_theoretical_values = []
x = 0
for delay_value in delay_total_vals:
    empirical_avg_values = []
    theoretical_values = []

    filename = 'results/'+file_times[x]+'/'

    x = x + 1


    for current_run in range(RUNS):
        run_file = filename+'run_'+str(current_run+1)+'.csv'
        data_values = pd.read_csv(run_file)
        #print(sum(data_values['tot_interrupt_rate']))
        empirical_avg_values.append(sum(data_values['tot_interrupt_rate']))
        theoretical_values.append(sum(data_values['theoretical_interrupt_rate']))


    tot_avg_empirical_values.append( sum(empirical_avg_values) / RUNS )
    tot_theoretical_values.append( sum(theoretical_values) / RUNS )


print(tot_avg_empirical_values)
print(tot_theoretical_values)

plt.plot(delay_total_vals, tot_avg_empirical_values, label='Empirical value', zorder=1, marker='x', color='C0', linestyle='solid')
plt.plot(delay_total_vals, tot_theoretical_values, label='Theoretical value', zorder=2, marker='o', color='C1', linestyle='dotted')




plt.legend()
plt.xlabel('Total delay $\ell$')
plt.ylabel('Interrupt rate $\sum_n D_n(t)/T$')
plt.savefig('num_clients_'+str(num_clients)+'_regime_selection_'+str(regime_selection)+'_runs_'+str(RUNS)+'.pdf')
plt.show()