



function create_clients(clients, delays, lambdas, p, q, num_clients, mu, clientVars)

global delays num_clients p q lambdas clients mu clientVars  tot_timesteps

for x = 1 : num_clients

    clients(x).idx = x;
    clients(x).delay = delays(x);
    clients(x).lambda = lambdas(x);
    clients(x).clientVars = clientVars(x);
    clients(x).mu = mu(x);
    clients(x).p = p(x);
    clients(x).q = q(x); 
    clients(x).packet_deadline_array = []; % holds info if there's a packet and its delay time. {'generation time'}.
    clients(x).delay_time_array = [];
    clients(x).mc = createmc(p(x), q(x));
    clients(x).channel_states = simulate(clients(x).mc, tot_timesteps);
    clients(x).channel_states(clients(x).channel_states == 2) = 0;
    clients(x).channel_states = clients(x).channel_states(1:tot_timesteps);
    clients(x).A_t = 0;
    clients(x).U_t = 0;
    clients(x).D_t = 0;
    clients(x).avg_tot_interrupt_rate = 0; % stores the average over time.
    clients(x).avg_tot_interrupt_rate_per_timestep = []; % stores the current avg. for every timestep.
    clients(x).avg_interrupt_over_runs = 0; % the same for all clients.
    clients(x).theoretical_interrupt_rate = 0; % same for all clients.
    clients(x).vwd_deficit = 0; % only for VWD. Deficit from previous timestep.
    clients(x).activations = 0; % for VWD policy only.
    
end


end