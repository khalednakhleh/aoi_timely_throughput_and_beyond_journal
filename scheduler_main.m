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
tot_timesteps = 20;
[betas, delays, lambdas, p, q] = get_client_values(num_clients, delay_total);
selected_policy = 1; % 1 is WLD. 2 is WRand. 3 is EDF. 4 is DBLDF.
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


for current_run = 1 : RUNS
    fprintf('++++++++++++++++++++++++++++++++++++++++++++++\n')
    fprintf('RUN %d\n', current_run)

  rng(SEED + RUNS*10); % reseeding for each run
  
  clients = repmat(struct('idx', {}, 'beta', {}, 'delay', {}, 'lambda', {}, 'p', {}, 'q', {}, 'packet_time_array', {}, 'delay_time_array', {}, ...
  'mc', {}, 'channel_states', {}, 'A_t', {}, 'U_t', {}, 'D_t', {}, 'tot_interrupt_rate', {}, 'theoretical_interrupt_rate', {}), num_clients);

  create_clients(clients, betas, delays, lambdas, p, q, num_clients);
  
  %check_channel_state(clients, num_clients, tot_timesteps);
  
  %for x = 1 : num_clients
  %   disp(clients(x).channel_states) 
  %end

  

  struct2table(clients) % to print the clients' structure
  
  
    if selected_policy == 1
        
        WLD(clients, num_clients, tot_timesteps);
    
    elseif selected_policy == 2
     
       WRand();
    
    elseif selected_policy == 3
       EDF();
    
    elseif selected_policy == 4
        DBLDF();
  
    else
        disp("ERROR: selected policy not found.");
        
    end
   
   
    
end


struct2table(clients) % to print the clients' structure
  

%% save results

if not(isfolder('results'))
    mkdir('results')
end
filename = sprintf('results/num_clients_%d_timedate_%s', num_clients, datestr(now,'mm_dd_yyyy_HH_MM_SS'));

writetable(struct2table(clients), filename);






