

import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt 
import matplotlib as mpl





mpl.use('pgf')
WIDTH = 9
HEIGHT = 7
plt.rcParams['font.size'] = 22
plt.rcParams['legend.fontsize'] = 26

plt.rcParams['pdf.fonttype'] = 42
plt.rcParams['ps.fonttype'] = 42
plt.rcParams['font.family'] = 'Times New Roman'




time_slot = 50000
num_clients = 5
RUNS = 5



vwd_df = pd.read_csv(f"")
wld_df = pd.read_csv(f"")
edf_df = pd.read_csv(f"")
dbldf_df = pd.read_csv(f"")





vwd_throughput_interrupt_values = vwd_df['avg_tot_interrupt_rate_per_timestep']
wld_throughput_interrupt_values = wld_df['avg_tot_interrupt_rate_per_timestep']
edf_throughput_interrupt_values = edf_df['avg_tot_interrupt_rate_per_timestep']
dbldf_df_throughput_interrupt_values = dbldf_df['avg_tot_interrupt_rate_per_timestep']





# sum the values over clients 



