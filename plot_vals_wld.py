


import numpy as np
import pandas as pd 
import matplotlib.pyplot as plt 
import matplotlib as mpl 


#mpl.use('pgf')


WIDTH = 8 
HEIGHT = 7 

plt.rcParams['font.size'] = 11
plt.rcParams['legend.fontsize'] = 20

plt.rcParams['pdf.fonttype'] = 42 
plt.rcParams['ps.fonttype'] = 42
plt.rcParams['font.family'] = 'Times New Roman'


#CONSTANTS for plotting

timesteps = 500000
num_clients = 1
regime_selection = 2 # 1 for under-loaded and 2 for over-loaded
selected_policy = 1 # 1 is WLD
RUNS = 1

delay_total_vals = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20] # these are the delay values we ran the simulations for.
#delay_total_vals = [10,20,30,40,50,60,70] # these are the delay values we ran the simulations for.

UNDERLOADED_C_CONSTANT = 0.15

folder_name = (f'results/clients_1_p_0.6_q_0.15_lambda_0.2/policy_{selected_policy}_regime_selection_{regime_selection}_tot_timesteps_{timesteps}_num_clients_{num_clients}_tot_delay_')


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
            theoretical_values.append(sum(UNDERLOADED_C_CONSTANT * data_values['theoretical_interrupt_rate']))
        else:
            empirical_avg_values.append(data_values['tot_interrupt_rate'][0])
            theoretical_values.append(data_values['theoretical_interrupt_rate'][0])            


    tot_avg_empirical_values.append( sum(empirical_avg_values) / RUNS )
    tot_theoretical_values.append( sum(theoretical_values) / RUNS )


print(tot_avg_empirical_values)
print(tot_theoretical_values)


plt.figure(1)


plt.plot(delay_total_vals, tot_avg_empirical_values, label='Empirical $Q_i$', zorder=1, marker='o', color='r', linestyle='solid')
plt.plot(delay_total_vals, tot_theoretical_values, label='Theoretical $Q_i$', zorder=2, marker='x', color='k', linestyle='dotted')


#plt.yscale('log')

plt.xticks(delay_total_vals)

plt.legend()
plt.xlabel('Total delay $\ell$')
plt.ylabel('Outage rate $\sum_i Q_i$')
plt.savefig('num_clients_'+str(num_clients)+'_regime_selection_'+str(regime_selection)+'_runs_'+str(RUNS)+'.pdf')
plt.show()


