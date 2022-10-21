

function packet_generator_all_clients(clients, num_clients, time_since_last_generation, tot_timesteps)

global num_clients tot_timesteps clients

%fprintf('\n++++packet_generator_all_clients++++++++\n')
for x = 1 : num_clients
    
packet_generator(clients, num_clients, time_since_last_generation, tot_timesteps, x);
    
end

%fprintf('\n---------packet_generator_all_clients---------\n')
end


