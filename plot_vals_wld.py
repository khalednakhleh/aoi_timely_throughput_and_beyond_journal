


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
num_clients = 5
regime_selection = 1 # 1 for under-loaded and 2 for over-loaded
selected_policy = 1 # 1 is WLD
RUNS = 5

delay_total_vals = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15] # these are the delay values we ran the simulations for.


folder_name = (f'results/policy_{selected_policy}_regime_selection_{regime_selection}_tot_timesteps_{timesteps}_num_clients_{num_clients}_tot_delay_')


######################
# plot the average value for different delay values (delay value on the x-axis and the interuption rate on the y-axis)

tot_avg_empirical_values = []
tot_theoretical_values = []


for delay_value in delay_total_vals:
    empirical_avg_values = []
    theoretical_values = []

    filename = folder_name+(f'{delay_value}/') 


    for current_run in range(RUNS):
        run_file = filename+'run_'+str(current_run+1)+'.csv'
        data_values = pd.read_csv(run_file)
        #print(sum(data_values['tot_interrupt_rate']))

        if num_clients > 1:
            empirical_avg_values.append(sum(data_values['tot_interrupt_rate']))
            theoretical_values.append(sum(data_values['theoretical_interrupt_rate']))
        else:
            empirical_avg_values.append(data_values['tot_interrupt_rate'][0])
            theoretical_values.append(data_values['theoretical_interrupt_rate'][0])            


    tot_avg_empirical_values.append( sum(empirical_avg_values) / RUNS )
    tot_theoretical_values.append( sum(theoretical_values) / RUNS )


#print(tot_avg_empirical_values)
#print(tot_theoretical_values)


plt.figure(1)


plt.plot(delay_total_vals, tot_avg_empirical_values, label='Empirical value', zorder=1, marker='x', color='C0', linestyle='solid')
plt.plot(delay_total_vals, tot_theoretical_values, label='Theoretical value', zorder=2, marker='o', color='C1', linestyle='dotted')


plt.yscale('log')


plt.legend()
plt.xlabel('Total delay $\ell$')
plt.ylabel('Interrupt rate $\sum_n D_n(t)/T$')
plt.savefig('num_clients_'+str(num_clients)+'_regime_selection_'+str(regime_selection)+'_runs_'+str(RUNS)+'.pdf')
plt.show()


plt.figure(2)



tot_avg_empirical_values = []
tot_theoretical_values = []


for delay_value_ratio in delay_total_vals:
    empirical_avg_values = []
    theoretical_values = []

    filename = folder_name+(f'{delay_value_ratio}/') 

    for current_run in range(RUNS):
        run_file = filename+'run_'+str(current_run+1)+'.csv'
        data_values = pd.read_csv(run_file)
        
        if num_clients > 1:
            empirical_avg_values.append(sum(data_values['tot_interrupt_rate'] / num_clients * data_values['theoretical_interrupt_rate']))
        else:
            empirical_avg_values.append(data_values['tot_interrupt_rate'][0] / num_clients * data_values['theoretical_interrupt_rate'][0])            


    tot_avg_empirical_values.append( sum(empirical_avg_values) / RUNS )


plt.yscale('log')

plt.plot(delay_total_vals, tot_avg_empirical_values, label='Ratio', zorder=1, marker='x', color='C0', linestyle='solid')




plt.legend()
plt.xlabel('Total delay $\ell$')
plt.ylabel('Total video interrupt rate ratio')
plt.savefig('ratio_num_clients_'+str(num_clients)+'_regime_selection_'+str(regime_selection)+'_runs_'+str(RUNS)+'.pdf')
plt.show()

