

function total_interrupt_rate = WLD(clients, num_clients, tot_timesteps)

packet_generator(clients, num_clients, 1, tot_timesteps);
check_channel_state(clients, num_clients);

for time = 1 : tot_timesteps
    
    
    index = check_clients_in_on_channel(clients, num_clients);
    
    deficit_on = zeros(1,length(index));
    
    for x = index
        deficit_on(x) = (clients(x).lambda * time - (clients(x).A_t + clients(x).U_t)) / clients(x).beta;  % calculate deficit per ON client.
    end
        
    choice = max(deficit_on);
    
    client_to_schedule = index(choice);
    
    schedule_and_update_parameters(client_to_schedule, clients, time, tot_timesteps);
    
   
end

total_interrupt_rate = calculate_interrupt_rate(clients);

end


