% author: Khaled Nakhleh
% solves for the optimal mean and variance given the linear program. 


%format long 

clc, clear all
warning('off','all')
global mu MS varChannel clientVars delay_total delays num_clients p q 
global lambdas betas tot_timesteps clients qoe_penalty_constant date_file_name

%% Constants
RUNS = 10;
delay_total = 15; % \delta in paper
num_clients = 5; 
tot_timesteps = 150000;
selected_policy = 1;  % 1 is WLD. 2 is WRand. 3 is EDF. 4 is DBLDF. 5 is WRR (not implemented yet). 6 is VWD. 
regime_selection = 1; % 1 for under-loaded. 2 for over-loaded.


% make results' directory 
if not(isfolder('results'))
    mkdir('results')
end

%timenow = datestr(now,'mm_dd_yyyy_HH_MM_SS');
date_file_name = sprintf('results/');
if not(isfolder(date_file_name))
    
    %date_file_name = strcat(current_val,timenow);
    mkdir(date_file_name);
end

%timenow = datestr(now,'mm_dd_yyyy_HH_MM_SS');
%date_file_name = strcat(date_file_name, timenow);

foldername = sprintf('policy_%d_regime_selection_%d_tot_timesteps_%d_num_clients_%d_tot_delay_%d', selected_policy, regime_selection, tot_timesteps, num_clients, delay_total);

date_file_name = strcat(date_file_name, foldername);

%% get theoretical mean and variance values

% 96325
%for one-client table1 : 84764579
%for one-client table2: 18235
%for one-client table3: 943667
%for one-client table4: 23457 
%--------------------------------
%for one-client table1-1: 457234.
%for one-client table1-2: 7834567. 
%for one-client table1-3: 23782. 
%--------------------------------
% multi-client setup 1: 2967542.
% multi-client setup 2: 86348.
% multi-client setup 3: 24521.

SEED = 5748792;

rng(SEED);


[betas, delays, lambdas, p, q, qoe_penalty_constant] = get_client_values(num_clients, delay_total)

if (regime_selection == 1)
  [MS, varChannel, mu, clientVars] = optimizer_under_loaded(num_clients, p, q, lambdas, delays);
elseif(regime_selection == 2)
  [MS, varChannel, mu, clientVars] = optimizer_over_loaded(num_clients, p, q, lambdas, delays);
else
    fprintf("ERROR: selected regime is not implemeneted. Exiting.");
end



%% Generate the channel sequences for the clients

%empirical_interrupt_rate = 0;
%empirical_qoe_penalty = 0;

for current_run = 1 : RUNS
    fprintf('++++++++++++++++++++++++++++++++++++++++++++++\n')
    fprintf('RUN %d\n', current_run)

  rng(SEED + current_run*10); % reseeding for each run
  
  clients = repmat(struct('idx', {}, 'beta', {}, 'clientVars', {}, 'mu' , {}, 'delay', {}, 'lambda', {}, 'p', {}, 'q', {}, 'packet_deadline_array', {}, 'delay_time_array', {}, ...
  'mc', {}, 'channel_states', {}, 'A_t', {}, 'U_t', {}, 'D_t', {}, 'tot_interrupt_rate', {}, 'theoretical_interrupt_rate', {}, 'qoe_penalty', {}, 'vwd_deficit', {}), num_clients);

  create_clients(clients, betas, delays, lambdas, p, q, num_clients, qoe_penalty_constant, mu, clientVars);
  set_arrivals(tot_timesteps); % generates packets with their respective delays.
  calculate_theoretical_interrupt_rate(clients, num_clients, regime_selection);

if num_clients == 1 % to print the table if there's one client (for debugging).
    structArray(1) = clients;
    structArray(2) = clients;
    one_client_table = struct2table(structArray);
end

 %struct2table(clients) % to print the clients' structure (for two or more
 %clients)
  
  
    if selected_policy == 1
       WLD(clients, num_clients, tot_timesteps);
    
    elseif selected_policy == 2
       WRand(clients, num_clients, tot_timesteps);
    
    elseif selected_policy == 3
       EDF(clients, num_clients, tot_timesteps);
    
    elseif selected_policy == 4
       DBLDF(clients, num_clients, tot_timesteps);
       
    elseif selected_policy == 5
       WRR(clients, num_clients, tot_timesteps);
        
    elseif selected_policy == 6
       VWD(clients, num_clients, tot_timesteps);
  
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


save_run_results(clients, num_clients, RUNS, selected_policy, regime_selection); % to save theoretical values as well.


% print the last run values
if num_clients == 1 % to print the table if there's one client.
structArray(1) = clients;
structArray(2) = clients;
one_client_table = struct2table(structArray)
first_client_asymptotics = asymptotics(clients(1).mc)
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

for x = 1 : num_clients
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

