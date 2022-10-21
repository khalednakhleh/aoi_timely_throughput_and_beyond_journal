



function check_channel_state(clients, num_clients)


global num_clients  clients


for x = 1 : num_clients
    
    walk_in = simulate(clients(x).mc, 1);
    walk_in(walk_in == 2) = 0;
    walk_in = walk_in(end);
    clients(x).current_channel_state = walk_in;
     
end




end
