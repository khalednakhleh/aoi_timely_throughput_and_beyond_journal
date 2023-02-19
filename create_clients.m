



function create_clients(clients, delays, periods, p, q, num_clients, mu, clientVars, lambdas)

global tot_timesteps clients

for x = 1 : num_clients

    clients(x).idx = x;
    clients(x).delay = delays(x);
    clients(x).period = periods(x);
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
    clients(x).avg_interrupt_over_runs = 0;    
    clients(x).theoretical_interrupt_rate = 0; % same for all runs.

    % for vwd only
    clients(x).vwd_deficit = 0; % only for VWD. Deficit from previous timestep d(t-1).
    clients(x).activations = 0; % for VWD policy only.

    % for AoI only
    clients(x).current_aoi_array = [1]; % for clients with AoI objective function.
    clients(x).time_since_last_packet_was_generated = -1;
    clients(x).aoi_lambda = lambdas(x);
    clients(x).avg_tot_aoi_value = [];

    
end


end