



function create_clients(clients, delays, periods, p, q, num_clients, mu, clientVars, lambdas)

global tot_timesteps clients weights

for x = 1 : num_clients

    clients(x).idx = x;
    clients(x).delay = delays(x);
    clients(x).period = periods(x);
    clients(x).clientVars = clientVars(x);
    clients(x).mu = mu(x);
    clients(x).p = p(x);
    clients(x).q = q(x); 
    clients(x).theoretical_interrupt_rate = 0; % same for all runs.
    clients(x).weight = weights(x);
    clients(x).aoi_lambda = lambdas(x);

    
end


end