% author: Khaled Nakhleh
% solves for the optimal mean and variance given the linear program. 


%format long 

clc, clear all
warning('off','all')
global mu MS varChannel clientVars delay_total delays num_clients p q 
global lambdas betas tot_timesteps clients


%% Constants
RUNS = 1;
delay_total = 10; % \delta in paper
num_clients = 2; 
tot_timesteps = 100000;
[betas, delays, lambdas, p, q] = get_client_values(num_clients, delay_total);
selected_policy = 1; % 1 is WLD. 2 is WRand. 3 is EDF. 4 is DBLDF. 5 is WRR. 6 is VWD.
regime_selection = 1; % 1 for under-loaded. 2 for over-loaded.



%% get theoretical mean and variance values

% 3467823
SEED = 34535;

rng(SEED);


if (regime_selection == 1)
  [MS, varChannel, mu, clientVars] = optimizer_under_loaded(num_clients, p, q, lambdas, delays);
elseif(regime_selection == 2)
  [MS, varChannel, mu, clientVars] = optimizer_over_loaded(num_clients, p, q, lambdas, delays);
end



%% Generate the channel sequences for the clients

empirical_interrupt_rate = 0;

for current_run = 1 : RUNS
    fprintf('++++++++++++++++++++++++++++++++++++++++++++++\n')
    fprintf('RUN %d\n', current_run)

  rng(SEED + RUNS*10); % reseeding for each run
  
  clients = repmat(struct('idx', {}, 'beta', {}, 'delay', {}, 'lambda', {}, 'p', {}, 'q', {}, 'packet_time_array', {}, 'delay_time_array', {}, ...
  'mc', {}, 'channel_states', {}, 'A_t', {}, 'U_t', {}, 'D_t', {}, 'tot_interrupt_rate', {}, 'theoretical_interrupt_rate', {}), num_clients);

  create_clients(clients, betas, delays, lambdas, p, q, num_clients);
  

  %struct2table(clients) % to print the clients' structure
  
  
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
        disp("ERROR: selected policy not found.");
        
    end
   save_run_results(clients, num_clients, current_run, selected_policy)
   empirical_interrupt_rate = empirical_interrupt_rate + clients(1).avg_tot_interrupt_rate;
    
end

empirical_interrupt_rate = empirical_interrupt_rate / RUNS;


for x = 1 : num_clients

    clients(x).avg_interrupt_over_runs = empirical_interrupt_rate;
    
end

calculate_theoretical_interrupt_rate(clients, num_clients, regime_selection);

save_run_results(clients, num_clients, current_run, selected_policy)

%struct2table(clients) % to print the clients' structure
  
disp('DONE')

%% utility functions

function save_run_results(clients, num_clients, current_run, selected_policy)

global clients num_clients

if not(isfolder('results'))
    mkdir('results')
end

foldername = sprintf('results/policy_%d_regime_selection_%d_num_clients_%d_timedate_%s', selected_policy, regime_selection, num_clients, datestr(now,'mm_dd_yyyy_HH_MM_SS'));

if not(isfolder(foldername))
mkdir(foldername)
end

current_run = sprintf('/run_%d', current_run);
filename = strcat(foldername,  current_run);
writetable(struct2table(clients), filename);


end

