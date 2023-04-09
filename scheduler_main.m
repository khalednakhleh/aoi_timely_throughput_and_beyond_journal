% Author: Khaled Nakhleh.
% solves for the optimal mean and variance given the linear program. 


format long 

clc, clear all
warning('off','all')
global mu MS varChannel clientVars delays num_clients p q weights
global periods date_file_name lambdas clients

%% Constants
num_clients =  6; 
selected_policy = 6 % 1 is WLD. 3 is EDF. 4 is DBLDF. 6 is VWD.
regime_selection = 6 % 1 for heavy-traffic with clients optimizing AoI (only for VWD). 2 for heavy-traffic regime. 
% 3 is heavy-traffic with added delay for vwd. 4 is heavy-traffic with added delay for wld. 5 is heavy-traffic with added delay for dbldf. 
% 6 is for heavy traffic with clients optimizaing AoI and with reconfigurable delay values for timely throughput clients (only for VWD).

delay_tot = 2081
%% Making directories

if (regime_selection == 1 || regime_selection == 6)
assert(selected_policy == 6)
end

% make results' directory 
if not(isfolder('results'))
    mkdir('results')
end

date_file_name = sprintf('results/num_clients_%d_regime_%d/', num_clients, regime_selection);


if not(isfolder(date_file_name))
    mkdir(date_file_name);
end

%% get theoretical mean and variance values

SEED = 489578; 

rng(SEED);

[delays, periods, p, q, lambdas] = get_client_values(num_clients);



if (regime_selection == 1)
  [MS, varChannel, mu, clientVars, weights] = optimize_heavy_traffic_with_aoi_clients(num_clients, p, q, periods, delays, lambdas);
elseif(regime_selection == 2)
  [MS, varChannel, mu, clientVars, weights] = optimize_heavy_traffic(num_clients, p, q, periods, delays);
elseif(regime_selection == 3)
  [MS, varChannel, mu, clientVars, weights, delays, delay_tot] = optimize_heavy_traffic_with_added_delay_vwd(num_clients, p, q, periods, delays);
elseif(regime_selection == 4)
  [MS, varChannel, mu, clientVars, weights, delays] = optimize_heavy_traffic_with_added_delay_wld(num_clients, p, q, periods, delay_tot);
elseif(regime_selection == 5)
  [MS, varChannel, mu, clientVars, weights, delays] = optimize_heavy_traffic_with_added_delay_dbldf(num_clients, p, q, periods, delay_tot);
elseif(regime_selection == 6)
  [MS, varChannel, mu, clientVars, weights, delays, delay_tot] = optimize_heavy_traffic_with_aoi_clients_with_reconfiguration(num_clients, p, q, periods, delays, lambdas);
else
    error("ERROR: selected regime is not implemeneted. Exiting.");
end


% Delays here and the ones displayed for regime 3 are the VWD delay
% values. WLD and DBLDF are calculated in the
% calculate_theoretical_interruprt_rate.m file for regime 3.


sigma_tot = sqrt(varChannel)


for x = 1 : num_clients
   
 client_array = [delays(x), periods(x), p(x), q(x), mu(x), clientVars(x), weights(x), lambdas(x)]';

   current_client_file = sprintf('/client_%d_values.txt', x);
   client_filename = strcat(date_file_name, current_client_file);
   save(client_filename, 'client_array', '-ascii');

end

%% Generate the channel sequences for the clients


  clients = repmat(struct('idx', {}, 'clientVars', {}, 'period', {}, 'p', {}, 'q', {}, 'delay', {},...
  'theoretical_vwd_rate', {}, 'theoretical_wld_rate', {}, 'theoretical_dbldf_rate', {}, 'vwd_deficit', {},'packet_deadline_array', {}, 'delay_time_array', {}, ...
  'mc', {}, 'channel_states', {}, 'mu' , {}, 'activations', {}, 'A_t', {}, 'U_t', {}, 'D_t', {}, 'tot_interrupt_rate', {}), num_clients);

  create_clients(clients, delays, periods, p, q, num_clients, mu, clientVars, lambdas);
  calculate_theoretical_interrupt_rate(clients, num_clients, sigma_tot, delays, regime_selection, delay_tot);


vwd_sum_theoretical_value = 0;
wld_sum_theoretical_value = 0;
dbldf_sum_theoretical_value = 0;

  for x = 1 : num_clients
      
vwd_sum_theoretical_value = vwd_sum_theoretical_value + clients(x).theoretical_vwd_rate;
wld_sum_theoretical_value = wld_sum_theoretical_value + clients(x).theoretical_wld_rate;
dbldf_sum_theoretical_value = dbldf_sum_theoretical_value + clients(x).theoretical_dbldf_rate;

  end

vwd_sum_theoretical_value
wld_sum_theoretical_value
dbldf_sum_theoretical_value


% print the run values
if num_clients == 1 % to print the table if there's one client.
structArray(1) = clients;
structArray(2) = clients;
one_client_table = struct2table(structArray)
first_client_asymptotics = asymptotics(clients(1).mc)
else
all_clients_table = struct2table(clients)
end


save_run_results(clients, num_clients); % to save theoretical values as well.



%% utility functions

function save_run_results(clients, num_clients)

global clients num_clients date_file_name

for x = 1 : num_clients % clearing out the arrays before saving the final results.
    clients(x).packet_deadline_array = [];
    clients(x).delay_time_array = [];
    clients(x).channel_states = [];
end



current_run = '/theoretical_values.csv';
filename = strcat(date_file_name,  current_run);


if num_clients == 1
   structArray(1) = clients;
   structArray(2) = clients;
   myTBL = struct2table(structArray);
   writetable(myTBL, filename);
else 
writetable(struct2table(clients), filename);
end

end



