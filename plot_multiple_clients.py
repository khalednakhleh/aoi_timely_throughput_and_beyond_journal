import matplotlib.pyplot as plt
import pandas as pd
import numpy as np



regime_selection = 1
num_clients = [10]# 10, 20]

timeslots = 300000
policies = [6]
labels = ['WLD', 'EDF', 'DBLDF', 'VWD'] # labels must match the policies order

num_runs = 10
plotting_interval = 60000


def average_results(current_policy, current_num_clients, regime_selection):


    directory = (f"results/policy_{current_policy}_regime_selection_{regime_selection}_tot_timesteps_{timeslots}_num_clients_{current_num_clients}/")
    
    #print(current_num_clients)
    #print(np.arange(1, current_num_clients+1))
    
    clients_value_per_policy = []
    for current_client in np.arange(1, current_num_clients+1):
        client_avg_over_runs = []
        for current_run in np.arange(1, num_runs + 1):

            df = pd.read_csv(directory+f"client_{current_client}_run_{current_run}.csv")

            value_to_plot = df.iloc[:,0]
            print(np.shape(value_to_plot), f"current_client {current_client}. current run {current_run}. policy {current_policy}")

            if (regime_selection == 1 and current_client <= np.floor(current_num_clients/2)):
                timeslots_divide = np.arange(1, timeslots+1)
                value_to_plot = np.divide(np.cumsum(value_to_plot), timeslots_divide)
            client_avg_over_runs.append(value_to_plot)

        client_avg_over_runs = np.divide((np.sum(np.array(client_avg_over_runs), axis = 0)), num_runs)

        clients_value_per_policy.append(client_avg_over_runs)

    clients_value_per_policy = np.sum(np.array(clients_value_per_policy), axis=0)


    return clients_value_per_policy





def plot_theoretical_values(current_policy, current_num_clients, regime_selection):

    directory = (f"results/policy_{current_policy}_regime_selection_{regime_selection}_tot_timesteps_{timeslots}_num_clients_{current_num_clients}/")


    df = pd.read_csv(directory+f"run_{1}.csv") # same theoretical value across all runs
    
    if current_policy == 1:
        theoretical_value = df["theoretical_wld_rate"]

    elif current_policy == 4:
        theoretical_value = df["theoretical_dbldf_rate"]

    elif current_policy == 6:
        theoretical_value = df["theoretical_vwd_rate"]

    else:
        print("ERROR: theoretical value selected policy does not exist.")
        exit(1)

    theoretical_value = np.sum(theoretical_value)


    return theoretical_value





# create a figure with three subplots side by side
fig, axs = plt.subplots(1, 3, figsize=(15,5))

x = np.arange(1,timeslots+1) # timeslots 

i = 0
# loop through the files and plot the data in each subplot
for current_client in num_clients:
    
    selected_label = 0
    for current_policy in policies:
        y = average_results(current_policy, current_client, regime_selection) # averaged value for a policy for n number of clients.
        theoretical_value = plot_theoretical_values(current_policy, current_client, regime_selection)
        axs[i].plot(x, y, label=labels[selected_label])
        axs[i].axhline(xmin=0, xmax=timeslots, y=theoretical_value)
        selected_label += 1


    # set the title and axis labels
    axs[i].set_title('Plot {}'.format(i+1))
    if i == 0:
        axs[i].set_ylabel('Y label')

    if i == 1:
        axs[i].set_xlabel('X label')
    

    axs[i].set_xticks(np.arange(0,timeslots+plotting_interval-1,plotting_interval))
    axs[i].legend()
    #axs[i].title()
    i += 1





# adjust the spacing between the subplots
plt.subplots_adjust(wspace=0.3)

# show the plot
plt.show()
