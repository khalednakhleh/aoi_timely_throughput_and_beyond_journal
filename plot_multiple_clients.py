import matplotlib.pyplot as plt
import pandas as pd
import numpy as np


regime_selection = 2
num_clients = [5]#, 10, 20]

timeslots = 100000000
policies = [6]#[1,3,4,6]
labels = ['VWD', 'EDF', 'DBLDF', 'VWD'] # labels must match the policies order
theoretical_labels = ['Theoretical VWD', 'Theoretical EDF', 'Theoretical DBLDF', 'Theoretical VWD']
num_runs = 1
plotting_interval = 2000000

graph_interval = 20000000
delays = [10,20,30,40,50]


empirical_colors = ['C1', 'C2', 'C3', 'C4']
theoretical_colors = ['C5', 'C6', 'C7']

empirical_styles = ['solid', 'dotted', 'dashdot', (0, (3,1,3,3,1,3))]
theoretical_styles = [(0, (1, 1)), 'dotted', 'dashdot']


def average_results(current_policy, current_num_clients, regime_selection):


    directory = (f"results/num_clients_{current_num_clients}_regime_{regime_selection}/")
    

    clients_value_per_policy = []
    for current_client in np.arange(1, current_num_clients+1):
        client_avg_over_runs = []
        for current_run in np.arange(1, num_runs + 1):

            df = pd.read_csv(directory+f"client_{current_client}_run_{current_run}_policy_{current_policy}_regime_{regime_selection}_results.txt", header=None)

            value_to_plot = df.iloc[:,0]
        
            if (regime_selection == 1 and current_client <= np.floor(current_num_clients/2)):
                timeslots_divide = np.arange(1, timeslots+1)
                value_to_plot = np.divide(np.cumsum(value_to_plot), timeslots_divide)
            client_avg_over_runs.append(value_to_plot)

        client_avg_over_runs = (delays[current_client-1]**2) * np.divide((np.sum(np.array(client_avg_over_runs), axis = 0)), num_runs)

        clients_value_per_policy.append(client_avg_over_runs)

    clients_value_per_policy = np.sum(np.array(clients_value_per_policy), axis=0)


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
fig, axs = plt.subplots(1, 3, figsize=(15,5))

x = np.arange(0,timeslots+plotting_interval, plotting_interval) # timeslots 


i = 0
# loop through the files and plot the data in each subplot
for current_client in num_clients:
    
    selected_label = 0
    for current_policy in policies:
        y = average_results(current_policy, current_client, regime_selection) # averaged value for a policy for n number of clients.
        theoretical_value = plot_theoretical_values(current_policy, current_client, regime_selection)
        y = y / np.arange(1,timeslots+plotting_interval, plotting_interval)
        #print(theoretical_value)
        #print(y)
        axs[i].plot(x, y, label=labels[selected_label], color = empirical_colors[selected_label], linestyle=empirical_styles[selected_label])
        axs[i].axhline(xmin=0, xmax=timeslots, y=theoretical_value, color=theoretical_colors[selected_label], linestyle=theoretical_styles[selected_label], label=theoretical_labels[selected_label])
        selected_label += 1


    # set the title and axis labels
    #axs[i].set_title('N = {}'.format(current_client))
    if i == 0:
        axs[i].set_ylabel(r'$\sum_i \alpha_i \cdot Q_i$', size=14)

    if i == 1:
        axs[i].set_xlabel('Timesteps', size=14)
    

    axs[i].set_xticks(np.arange(0,timeslots+graph_interval-1,graph_interval))
    axs[i].set_yticks(np.arange(0,3.5,0.5))
    axs[i].legend()
    #axs[i].title()
    i += 1



axs[0].legend(loc='lower right', bbox_to_anchor=(1.27, 1.02) , borderaxespad=0., ncol=7, frameon=False)


# adjust the spacing between the subplots
plt.subplots_adjust(wspace=0.3)

# show the plot
plt.show()


plt.savefig(f"regime_{regime_selection}.pdf")
