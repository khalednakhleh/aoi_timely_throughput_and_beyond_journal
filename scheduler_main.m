% author: Khaled Nakhleh
% solves for the optimal mean and variance given the linear program. 


format long 

clc, clear all
warning('off','all')
global mu MS varChannel clientVars delays num_clients p q 
global periods tot_timesteps clients date_file_name

%% Constants

RUNS = 1;
num_clients = 20; 
tot_timesteps = 50000;
selected_policy = 1;  % 1 is WLD. 3 is EDF. 4 is DBLDF. 6 is VWD. 
regime_selection = 1; % 1 for heavy-traffic with clients optimizing AoI. 2 for heavy-traffic regime. 3 is heavy-traffic with added delay. 


% make results' directory 
if not(isfolder('results'))
    mkdir('results')
end

date_file_name = sprintf('results/');
if not(isfolder(date_file_name))
    
    mkdir(date_file_name);
end


foldername = sprintf('policy_%d_regime_selection_%d_tot_timesteps_%d_num_clients_%d', selected_policy, regime_selection, tot_timesteps, num_clients);

date_file_name = strcat(date_file_name, foldername);

%% get theoretical mean and variance values

SEED = 5346;

rng(SEED);


[delays, periods, p, q] = get_client_values(num_clients);



if (regime_selection == 1)
  [MS, varChannel, mu, clientVars] = optimize_heavy_traffic_with_aoi_clients(num_clients, p, q, periods, delays);
elseif(regime_selection == 2)
  [MS, varChannel, mu, clientVars] = optimize_heavy_traffic(num_clients, p, q, periods, delays);
eliseif(regime_selection == 3)
  [MS, varChannel, mu, clientVars] = optimize_heavy_traffic_with_added_delay(num_clients, p, q, periods, delays);
else
    error("ERROR: selected regime is not implemeneted. Exiting.");
end


%% Generate the channel sequences for the clients

for current_run = 1 : RUNS
    fprintf('++++++++++++++++++++++++++++++++++++++++++++++\n')
    fprintf('RUN %d\n', current_run)

  rng(SEED + current_run*10); % reseeding for each run
  
  clients = repmat(struct('idx', {}, 'beta', {}, 'clientVars', {}, 'mu' , {}, 'delay', {}, 'period', {}, 'p', {}, 'q', {}, 'packet_deadline_array', {}, 'delay_time_array', {}, ...
  'mc', {}, 'channel_states', {}, 'A_t', {}, 'U_t', {}, 'D_t', {}, 'tot_interrupt_rate', {},...
  'theoretical_vwd_rate', {}, 'theoretical_wld_rate', {}, 'theoretical_dbldf_rate', {}, 'vwd_deficit', {}), num_clients);

  create_clients(clients, delays, periods, p, q, num_clients, mu, clientVars);
  set_arrivals(tot_timesteps); % generates packets with their respective delays.
  calculate_theoretical_interrupt_rate(clients, num_clients, sqrt(varChannel), delays, regime_selection);
  

if num_clients == 1 % to print the table if there's one client (for debugging).
    structArray(1) = clients;
    structArray(2) = clients;
    one_client_table = struct2table(structArray);
end

    % actual scheduling loop.
    if selected_policy == 1
       WLD(clients, num_clients, tot_timesteps, regime_selection);
    
    elseif selected_policy == 3
       EDF(clients, num_clients, tot_timesteps, regime_selection);
    
    elseif selected_policy == 4
       DBLDF(clients, num_clients, tot_timesteps, regime_selection);

    elseif selected_policy == 6
       VWD(clients, num_clients, tot_timesteps, regime_selection);
  
    else
       error("ERROR: selected policy not found.");
        
    end

    for x = 1 : num_clients % empty-out the packets arrays after finishing the run for better value saving.
        clients(x).packet_deadline_array = [];
        clients(x).delay_time_array = [];
        clients(x).channel_states = [];
    end
    
    save_run_results(clients, num_clients, current_run, selected_policy, regime_selection); % to save theoretical values as well.

end

% to save theoretical values as well.
save_run_results(clients, num_clients, RUNS, selected_policy, regime_selection); 


% print the last run values
if num_clients == 1 % to print the table if there's one client.
structArray(1) = clients;
structArray(2) = clients;
one_client_table = struct2table(structArray)
%first_client_asymptotics = asymptotics(clients(1).mc)
else
all_clients_table = struct2table(clients)
end

disp('DONE')



%% utility functions

function save_run_results(clients, num_clients, current_run, selected_policy, regime_selection)

global clients num_clients date_file_name


if not(isfolder(date_file_name))
mkdir(date_file_name)
end

for x = 1 : num_clients % clearing out the arrays before saving the final results.
    clients(x).packet_deadline_array = [];
    clients(x).delay_time_array = [];
    clients(x).channel_states = [];
end


current_run = sprintf('/run_%d.csv', current_run);
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



