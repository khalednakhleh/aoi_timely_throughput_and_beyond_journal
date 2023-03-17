import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import matplotlib as mpl 

mpl.use('pgf')
# for plotting regime 2.

regime_selection = 2
num_clients = [5, 10, 20]

timeslots = 1000000000
policies = [6,1,4]


#labels = ['WLD', 'DBLDF', 'VWD'] # labels must match the policies order
labels = ['VWD', 'WLD', 'DBLDF']

theoretical_labels = ['Theoretical VWD']

num_runs = 3
plotting_interval = 20000000

graph_interval = 100000000 # for the x ticks 
delays_five_clients = [10,20,30,40,50] 
delays_ten_clients = [15, 25, 35, 45, 55, 65, 75, 85, 95, 105]
delays_twenty_clients = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200]

empirical_colors = ['C1', 'C2', 'C3', 'C4'] # for empirical values plotting 
theoretical_colors = ['C5', 'C6', 'C7'] # for theoretical values plotting 

empirical_styles = ['solid', 'dotted', 'dashdot', (0, (3,1,3,3,1,3))]
theoretical_styles = [(0, (1, 1)), 'dotted', 'dashdot']


def average_results(current_policy, current_num_clients, regime_selection):

    if current_num_clients == 5: 
        delays = delays_five_clients
    elif current_num_clients == 10:
        delays = delays_ten_clients
    elif current_num_clients == 20:
        delays = delays_twenty_clients

    directory = (f"results/num_clients_{current_num_clients}_regime_{regime_selection}/")
    

    clients_value_per_policy = []
    for current_client in np.arange(1, current_num_clients+1):
        client_avg_over_runs = []
        for current_run in np.arange(2, num_runs + 2):


            df = pd.read_csv(directory+f"client_{current_client}_run_{current_run}_policy_{current_policy}_regime_{regime_selection}_results.txt", header=None)

            value_to_plot = df.iloc[:,0]

            client_avg_over_runs.append(value_to_plot)

        #print(client_avg_over_runs)
        client_avg_over_runs = np.sum(np.array(client_avg_over_runs), axis = 0)
        
        #print(client_avg_over_runs)
        client_avg_over_runs = np.divide(client_avg_over_runs, num_runs)
        #print(client_avg_over_runs)
        client_avg_over_runs = (delays[current_client-1]**2) * client_avg_over_runs
        #print(client_avg_over_runs)
        clients_value_per_policy.append(client_avg_over_runs)
    #print(clients_value_per_policy)

    clients_value_per_policy = np.sum(np.array(clients_value_per_policy), axis=0)
    #print(clients_value_per_policy)

    return clients_value_per_policy




def plot_theoretical_values(current_policy, current_num_clients, regime_selection):

    directory = (f"results/num_clients_{current_num_clients}_regime_{regime_selection}/")


    df = pd.read_csv(directory+f"theoretical_values.csv") # same theoretical value across all runs
    
    if current_policy == 1:
        theoretical_value = df["theoretical_wld_rate"]

    elif current_policy == 4:
        theoretical_value = df["theoretical_dbldf_rate"]

    elif current_policy == 6:
        theoretical_value = df["theoretical_vwd_rate"]
    
    elif current_policy == 3:
        pass
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


        y = average_results(current_policy, current_client, regime_selection) # averaged value for a policy for n number of clients.
        y = y / np.arange(1, timeslots+plotting_interval, plotting_interval)

        axs[i].plot(x, y, label=labels[selected_label], color = empirical_colors[selected_label], linestyle=empirical_styles[selected_label])
        
        if (current_policy == 6):
            
            theoretical_value = plot_theoretical_values(current_policy, current_client, regime_selection)
            
            axs[i].axhline(xmin=0, xmax=timeslots, y=theoretical_value, color=theoretical_colors[theoretical_label_count], linestyle=theoretical_styles[theoretical_label_count], label=theoretical_labels[theoretical_label_count])
            theoretical_label_count = theoretical_label_count + 1
        
        selected_label += 1


    # set the title and axis labels
    #axs[i].set_title('N = {}'.format(current_client))
    if i == 0:
        axs[i].set_ylabel(r'$\sum_i \alpha_i \cdot \overline{outage}$', size=14)
        axs[i].legend()

    if i == 1:
        axs[i].set_xlabel('Timeslots', size=14)
    

    axs[i].set_xticks(np.arange(0,timeslots+graph_interval-1,graph_interval))
    
    handles, labels = axs[0].get_legend_handles_labels()
    order = [0,2,3,1]
    #axs[i].set_yscale('log')
    axs[i].legend([handles[idx] for idx in order],[labels[idx] for idx in order], frameon=False)    
    
    i += 1



#axs[0].legend(loc='lower right', bbox_to_anchor=(3.27, 1.02) , borderaxespad=0., ncol=7, frameon=False)


# adjust the spacing between the subplots
plt.subplots_adjust(wspace=0.3)




plt.savefig(f"regime_{regime_selection}.pdf")
# show the plot
plt.show()