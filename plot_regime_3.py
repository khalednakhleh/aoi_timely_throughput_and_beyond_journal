import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import matplotlib as mpl 

#mpl.use('pgf')
# for plotting regime 3.

num_clients = [5, 10, 20]

timeslots = 1000000000
policies = [6,1,4]


labels = ['VWD', 'WLD', 'DBLDF']

theoretical_labels = ['Theoretical VWD', 'Theoretical WLD', 'Theoretical DBLDF']

num_runs = 5
plotting_interval = 2000000

graph_interval = 100000000 # for the x ticks 

delays_five_clients_VWD = [10, 19, 29, 39, 49] 
delays_ten_clients_VWD = [14, 24, 34, 44, 54, 64, 74, 85, 94, 104]
delays_twenty_clients_VWD = [10, 19, 29, 39, 49, 59, 69, 79, 89, 99, 109, 119, 129, 139, 149, 159, 169, 179, 189, 199]


delays_five_clients_WLD = [9, 19, 29, 38, 48] 
delays_ten_clients_WLD = [55, 57, 58, 59, 59, 59, 59, 59, 60, 61]
delays_twenty_clients_WLD = [102, 103, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104]



delays_five_clients_DBLDF = [29,29,29,29,29] 
delays_ten_clients_DBLDF = [59,59,59,59,59,59,59,59,59,59]
delays_twenty_clients_DBLDF = [104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104]



weights_five_clients =  [1.0e-06 *0.199252750702208,   1.0e-06 *0.099095218915311, 1.0e-06 *  0.065945182018015,  1.0e-06 * 0.049414448405438,   1.0e-06 *0.039510253731204]
weights_ten_clients =  [  1.0e-08 * 0.576253101427755,   1.0e-08 *  0.319547075006487,   1.0e-08 *  0.220023490622493,  1.0e-08 *   0.167522683322724,  1.0e-08 *   0.135169459159228,  1.0e-08 *   0.113263301703856,   1.0e-08 *  0.097449349785005,  1.0e-08 *   0.085505411805879,  1.0e-08 *   0.076162981494049,   1.0e-08 *  0.068660632215505]
weights_twenty_clients = [1.0e-07 * 0.311453156800177,  1.0e-07 *  0.040669005015323,  1.0e-07 *  0.012208295050929,  1.0e-07 *  0.005177082691539, 1.0e-07 *   0.002656116196590,  1.0e-07 *  0.001537908336630, 1.0e-07 *   0.000985724711660,  1.0e-07 *  0.000661837336185,  1.0e-07 *  0.000464858011146, 1.0e-07 *   0.000338833445834, 1.0e-07 *   0.000254534915920, 1.0e-07 *   0.000196035627508,  1.0e-07 *  0.000154175731241,  1.0e-07 *  0.000123435653474, 1.0e-07 * 0.000100354817032, 1.0e-07 *   0.000082688617181,  1.0e-07 *  0.000068937779696, 1.0e-07 *   0.000058074883349,  1.0e-07 *  0.000049379801791,  1.0e-07 *  0.000042337598140]



empirical_colors = ['C1', 'C2', 'C3', 'C4'] # for empirical values plotting 
theoretical_colors = ['C5', 'C6', 'C7'] # for theoretical values plotting 

empirical_styles = ['solid', 'dotted', 'dashdot', (0, (3,1,3,3,1,3))]
theoretical_styles = [(0, (1, 1)), 'dotted', 'dashdot']






def average_results(current_policy, current_num_clients):
    
    if current_policy == 6: # current policy is VWD
        regime_selection = 3

        if current_num_clients == 5: 
            delays = delays_five_clients_VWD
        elif current_num_clients == 10:
            delays = delays_ten_clients_VWD
        elif current_num_clients == 20:
            delays = delays_twenty_clients_VWD
    
    elif current_policy == 1: # current policy is WLD
        
        regime_selection = 4
    
        if current_num_clients == 5: 
            delays = delays_five_clients_WLD
        elif current_num_clients == 10:
            delays = delays_ten_clients_WLD
        elif current_num_clients == 20:
            delays = delays_twenty_clients_WLD

    elif current_policy == 4: # current policy is DBLDF

        regime_selection = 5
    
        if current_num_clients == 5: 
            delays = delays_five_clients_DBLDF
        elif current_num_clients == 10:
            delays = delays_ten_clients_DBLDF
        elif current_num_clients == 20:
            delays = delays_twenty_clients_DBLDF


    if current_num_clients == 5: 
        weights = weights_five_clients
    elif current_num_clients == 10:
        weights =  weights_ten_clients
    elif current_num_clients == 20:
        weights = weights_twenty_clients

    directory = (f"results/num_clients_{current_num_clients}_regime_{regime_selection}/")
    #print(directory)
    
    clients_value_per_policy = []
    for current_client in np.arange(1, current_num_clients+1):
        client_avg_over_runs = []
        for current_run in np.arange(1, num_runs + 1):

            df = pd.read_csv(directory+f"client_{current_client}_run_{current_run}_policy_{current_policy}_regime_{regime_selection}_results.txt", header=None)
           
            value_to_plot = df.iloc[:,0]

            client_avg_over_runs.append(value_to_plot)

        client_avg_over_runs = np.sum(np.array(client_avg_over_runs), axis = 0)


        client_avg_over_runs = np.divide(client_avg_over_runs, num_runs)

        client_avg_over_runs = client_avg_over_runs / np.arange(1, timeslots+plotting_interval, plotting_interval)


        client_avg_over_runs = client_avg_over_runs + (weights[current_client-1] * delays[current_client-1]**2)

        clients_value_per_policy.append(client_avg_over_runs)
        
    clients_value_per_policy = np.sum(np.array(clients_value_per_policy), axis=0)


    return clients_value_per_policy


def plot_theoretical_values(current_policy, current_num_clients):

    if current_policy == 1: # WLD

        directory = (f"results/num_clients_{current_num_clients}_regime_{4}/")
        df = pd.read_csv(directory+f"theoretical_values.csv") # same theoretical value across all runs
    
        theoretical_value = df["theoretical_wld_rate"]

    elif current_policy == 4:
        directory = (f"results/num_clients_{current_num_clients}_regime_{5}/")
        df = pd.read_csv(directory+f"theoretical_values.csv") # same theoretical value across all runs
    
        theoretical_value = df["theoretical_dbldf_rate"]

    elif current_policy == 6:
        directory = (f"results/num_clients_{current_num_clients}_regime_{3}/")
        df = pd.read_csv(directory+f"theoretical_values.csv") # same theoretical value across all runs
    
        theoretical_value = df["theoretical_vwd_rate"]
    
    else:
        print("ERROR: theoretical value selected policy does not exist.")
        exit(1)

    theoretical_value = np.sum(theoretical_value)


    return theoretical_value







# create a figure with three subplots side by side
fig, axs = plt.subplots(1, 3, figsize=(15,3.5))

x = np.arange(0,timeslots+plotting_interval, plotting_interval) # timeslots 


i = 0
# loop through the files and plot the data in each subplot
for current_client in num_clients:
    
    selected_label = 0
    theoretical_label_count = 0
    for current_policy in policies:

        y = average_results(current_policy, current_client) # averaged value for a policy for n number of clients.
        #print(y)
        #y = y / np.arange(1, timeslots+plotting_interval, plotting_interval)
        y[0] = 0

        axs[i].plot(x, y, label=labels[selected_label], color = empirical_colors[selected_label], linestyle=empirical_styles[selected_label])

        
        theoretical_value = plot_theoretical_values(current_policy, current_client)
        print(theoretical_value)
        
        axs[i].axhline(xmin=0, xmax=timeslots, y=theoretical_value, color=theoretical_colors[theoretical_label_count], linestyle=theoretical_styles[theoretical_label_count], label=theoretical_labels[theoretical_label_count])
        theoretical_label_count = theoretical_label_count + 1
    
        selected_label += 1


    # set the title and axis labels
    #axs[i].set_title('N = {}'.format(current_client))

        
    axs[i].legend()

    axs[i].set_xlabel('Timeslots $t$', size=9)
    axs[i].set_ylabel(r'$\sum_i \overline{outage}_i + \alpha_i \cdot l_i^2$', size=9)

    axs[i].set_xticks(np.arange(0,timeslots+graph_interval-1,graph_interval))
    axs[0].set_ylim([0, 0.002])
    axs[1].set_ylim([0, 0.0002])
    axs[2].set_ylim([0, 0.0005])
    
    #handles, labels = axs[0].get_legend_handles_labels()
    #print(handles)
    #order = [0,1]
    #axs[i].legend([handles[idx] for idx in order],[labels[idx] for idx in order], frameon=False)    
    
    i += 1



#axs[0].legend(loc='lower right', bbox_to_anchor=(3.27, 1.02) , borderaxespad=0., ncol=7, frameon=False)


# adjust the spacing between the subplots
plt.subplots_adjust(wspace=0.3)




plt.savefig(f"regime_{3}.pdf")
# show the plot
plt.show()