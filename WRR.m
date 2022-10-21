





function WRR(clients, num_clients, tot_timesteps)

global num_clients tot_timesteps clients


packet_generator_all_clients(clients, num_clients, 1, tot_timesteps);
check_channel_state(clients, num_clients);



for time = 1 : tot_timesteps
    
    
    
    
end

calculate_interrupt_rate(clients, num_clients, tot_timesteps);


end