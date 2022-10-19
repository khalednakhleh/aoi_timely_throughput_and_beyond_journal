% author: Khaled Nakhleh
% solves for the optimal mean and variance given the linear program. 


%format long 

clc, clear all

global mu MS varChannel clientVars delay_total delays num_clients p q 
global lambdas betas activations timeslots


%% Constants
RUNS = 1;
delay_total = 10;
num_clients = 2;
timeslots = 10;
[betas, delays, lambdas, p, q] = get_client_values(num_clients, delay_total);
activations = zeros(num_clients, timeslots);
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

    rng(SEED + RUNS*10); % reseeding for each run
 
    %{
for i = 1 : num_clients
    mc = createmc(p(i), q(i));
    walkIns = simulate(mc, timeslots);
    walkIns(walkIns == 2) = 0;
    activations(i, :) = walkIns(1:timeslots);
end
%}
    
  clients = repmat(struct('idx', {}, 'beta', {}, 'delay', {}, 'lambda', {}, 'p', {}, 'q', {}, 'packet_deadline_array', {}, 'mc', {}), num_clients);

  clients = create_clients(clients, betas, delays, lambdas, p, q, num_clients);
  
  %struct2table(clients) % to print the clients' structure
  
  %{
    if selected_policy == 1
        
        total_interrupt_rate = WLD();
    
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








