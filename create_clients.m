



function clients = create_clients(clients, betas, delays, lambdas, p, q, num_clients)

for x = 1 : num_clients

    clients(x).idx = x;
    clients(x).beta = betas(x);
    clients(x).delay = delays(x);
    clients(x).lambda = lambdas(x);
    clients(x).p = p(x);
    clients(x).q = q(x); 
    clients(x).packet_deadline_array = []; % holds info if there's a packet and its delay time. {'generation time', 'delay time'}.
    clients(x).delay_time_array = [];
    clients(x).mc = createmc(p(x), q(x));
    clients(x).current_channel_state = 0;
    clients(x).A_t = 0;
    clients(x).U_t = 0;
    clients(x).D_t = 0;
end


end