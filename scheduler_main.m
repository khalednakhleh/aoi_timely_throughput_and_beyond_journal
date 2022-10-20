% author: Khaled Nakhleh
% solves for the optimal mean and variance given the linear program. 


%format long 

clc, clear all

global mu MS varChannel clientVars delay_total delays num_clients p q 
global lambdas betas tot_timesteps clients


%% Constants
RUNS = 1;
delay_total = 10;
num_clients = 2;
tot_timesteps = 10;
[betas, delays, lambdas, p, q] = get_client_values(num_clients, delay_total);
selected_policy = 1; % 1 is WLD. 2 is WRand. 3 is EDF. 4 is DBLDF.


%% get theoretical mean and variance values

% 3467823
SEED = 8956935;

rng(SEED);


regime_selection = 1; % 1 for under-loaded. 2 for over-loaded.


if (regime_selection == 1)
  [MS, varChannel, means, clientVars] = optimizer_under_loaded(num_clients, p, q, lambdas, delays);
elseif(regime_selection == 2)
  [MS, varChannel, clientVars] = optimizer_over_loaded(num_clients, p, q, lambdas, delays);
end



%% Generate the channel sequences for the clients


for current_run = 1 : RUNS
    fprintf('++++++++++++++++++++++++++++++++++++++++++++++\n')
    fprintf('RUN %d\n', current_run)

  rng(SEED + RUNS*10); % reseeding for each run
  
  clients = repmat(struct('idx', {}, 'beta', {}, 'delay', {}, 'lambda', {}, 'p', {}, 'q', {}, 'packet_time_array', {}, 'delay_time_array', {}, 'mc', {}, 'current_channel_state', {}, 'A_t', {}, 'U_t', {}, 'D_t', {}), num_clients);

  clients = create_clients(clients, betas, delays, lambdas, p, q, num_clients);
  
  %struct2table(clients) % to print the clients' structure
  
  %{
    if selected_policy == 1
        
        total_interrupt_rate = WLD(clients, num_clients, tot_timesteps);
    
    elseif selected_policy == 2
     
        total_interrupt_rate = WRand();
    
    elseif selected_policy == 3
        total_interrupt_rate = EDF();
    
    elseif selected_policy == 4
        total_interrupt_rate = DBLDF();
  
    else
        disp("ERROR: selected policy not found.");
        
    end
    
    %}
    
end








