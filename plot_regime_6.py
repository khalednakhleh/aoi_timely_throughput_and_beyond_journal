import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import matplotlib as mpl 

mpl.use('pgf')
# for plotting regime 6.


WIDTH = 9
HEIGHT = 7
plt.rcParams['font.size'] = 22
plt.rcParams['legend.fontsize'] = 22

plt.rcParams['pdf.fonttype'] = 42
plt.rcParams['ps.fonttype'] = 42
plt.rcParams['font.family'] = 'Times New Roman'



num_clients = [20]#, 10, 20]

timeslots = 100000000
policies = [6, 7]
labels = ['VWD', 'Stationary-DBLDF'] # labels must match the policies order
theoretical_labels = ['Theoretical VWD']


regime_selection = 6

num_runs = 1
plotting_interval = 1000000

graph_interval = 10000000 # for the x ticks 

delays_six_clients = [5, 10, 14] 
delays_ten_clients = [11, 14, 18, 20, 23]
delays_twenty_clients = [9, 14, 20, 24, 29, 34, 39, 44, 50, 54]


weights_six_clients =  [3.74168634179267e-06, 3.79955570224954e-06, 4.24819730401659e-06]
weights_ten_clients =  [4.12695932266658e-07, 2.78694807991575e-07, 1.93997836467727e-07, 1.29736259671297e-07, 1.00534296029578e-07]
weights_twenty_clients = [1.3103464001012e-07, 3.94815193160431e-08, 1.64711960463104e-08, 8.58560252903221e-09, 4.97506075074181e-09, 3.11189875512256e-09, 2.09906133103661e-09, 1.45254025023862e-09, 1.06327714780477e-09, 8.0711335180729e-10]



empirical_colors = ['C1', 'C2', 'C3', 'C4'] # for empirical values plotting 
theoretical_colors = ['C5', 'C6', 'C7'] # for theoretical values plotting 

empirical_styles = ['solid', 'dotted', 'dashdot', (0, (3,1,3,3,1,3))]
theoretical_styles = [(0, (1, 1)), 'dotted', 'dashdot']


def average_results(current_policy, current_num_clients, regime_selection):

    if current_num_clients == 6: 
        delays = delays_six_clients
        weights = weights_six_clients
    elif current_num_clients == 10:
        delays = delays_ten_clients
        weights = weights_ten_clients
    elif current_num_clients == 20:
        delays = delays_twenty_clients
        weights = weights_twenty_clients
    

    directory = (f"results/num_clients_{current_num_clients}_regime_{regime_selection}/")
    
    realtime_counter = 0

    clients_value_per_policy = []
    for current_client in np.arange(1, current_num_clients+1):
        client_avg_over_runs = []
        
        for current_run in np.arange(1, num_runs+1):
            
            df = pd.read_csv(directory+f"client_{current_client}_run_{current_run}_policy_{current_policy}_regime_{regime_selection}_results.txt", header=None)
            
            value_to_plot = df.iloc[:,0]
           
            if (current_client <= np.floor(current_num_clients/2)):
                
                value_to_plot = np.cumsum(value_to_plot)
                
            else: 
                value_to_plot = df.iloc[:,0]

            client_avg_over_runs.append(value_to_plot)

        client_avg_over_runs = np.divide((np.sum(np.array(client_avg_over_runs), axis = 0)), num_runs) 
        
        if (current_client > np.floor(current_num_clients/2)):
            #print(f'realtime counter: {realtime_counter}')
            client_avg_over_runs = client_avg_over_runs + (weights[realtime_counter] * delays[realtime_counter]**2)
            realtime_counter = realtime_counter + 1
        
        clients_value_per_policy.append(client_avg_over_runs)

    clients_value_per_policy = np.sum(np.array(clients_value_per_policy), axis=0)


    return clients_value_per_policy

 

def plot_theoretical_values(current_policy, current_num_clients, regime_selection):

    directory = (f"results/num_clients_{current_num_clients}_regime_{regime_selection}/")

    df = pd.read_csv(directory+f"theoretical_values.csv") # same theoretical value across all runs
    
    if current_policy == 6:
        theoretical_value = df["theoretical_vwd_rate"]
    
    elif current_policy == 3:
        pass
    else:
        print("ERROR: theoretical value selected policy does not exist.")
        exit(1)

    theoretical_value = np.sum(theoretical_value)


    return theoretical_value



# create a figure with three subplots side by side
fig = plt.figure(figsize=(WIDTH, HEIGHT), dpi= 50)

x = np.arange(0,timeslots+plotting_interval, plotting_interval) # timeslots 


i = 0
# loop through the files and plot the data in each subplot
for current_client in num_clients:
    
    selected_label = 0
    theoretical_label_count = 0
    for current_policy in policies:
        y = average_results(current_policy, current_client, regime_selection) # averaged value for a policy for n number of clients.
        y = y / np.arange(1,timeslots+plotting_interval, plotting_interval)

        #print(y[-1])

        plt.plot(x, y, label=labels[selected_label], color = empirical_colors[selected_label], linestyle=empirical_styles[selected_label], linewidth=2)

        if current_policy != 7:
            theoretical_value = plot_theoretical_values(current_policy, current_client, regime_selection)
            plt.hlines(xmin=0, xmax=timeslots, y=theoretical_value, linewidth=2, color=theoretical_colors[theoretical_label_count], linestyle=theoretical_styles[theoretical_label_count], label=theoretical_labels[theoretical_label_count])
            theoretical_label_count = theoretical_label_count + 1

        selected_label += 1


    # set the title and axis labels
    #axs[i].set_title('N = {}'.format(current_client))
    
    plt.legend(frameon=False)

    plt.xlabel('Timeslots $t$', weight="bold")
    plt.ylabel(r'Sum of AoI and outage rates with added delay', weight="bold")


    plt.xticks(np.arange(0,timeslots+graph_interval-1,graph_interval))
    #handles, labels = axs[0].get_legend_handles_labels()
    #order = [0,2,1]
    #axs[i].legend([handles[idx] for idx in order],[labels[idx] for idx in order], frameon=False) 
    plt.xticks(np.arange(0,timeslots+graph_interval-1,graph_interval))
    plt.yticks(weight='bold', fontsize=20)
    plt.xticks(weight='bold', fontsize=20)
    
    #axs[i].title()

    i += 1



# adjust the spacing between the subplots
#plt.subplots_adjust(wspace=0.3)

plt.savefig(f"regime_{regime_selection}_num_clients_{num_clients[0]}.pdf")

# show the plot
plt.show()


