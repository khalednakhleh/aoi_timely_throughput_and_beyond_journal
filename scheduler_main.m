% author: Khaled Nakhleh
% solves for the optimal mean and variance given the linear program. 


%format long 

clc, clear all

global mu MS varChannel clientVars delay_total delays num_clients p q 
global lambdas betas


%% Constants
delay_total = 10;

num_clients = 2;

[betas, delays, lambdas, p, q] = get_client_values(num_clients, delay_total);



%% get theoretical value

% 3467823
SEED = 8956935;

rng(SEED);


regime_selection = 1; % 1 for under-loaded. 2 for over-loaded.



if (regime_selection == 1)
  [MS, varChannel, means, clientVars] = optimizer_under_loaded(num_clients, p, q, lambdas, delays);
elseif(regime_selection == 2)
  [MS, varChannel, clientVars] = optimizer_over_loaded(num_clients, p, q, lambdas, delays);
end

