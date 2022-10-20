

function WLD(clients, num_clients, tot_timesteps)


global num_clients tot_timesteps clients


packet_generator(clients, num_clients, 1, tot_timesteps);
check_channel_state(clients, num_clients);

for time = 1 : tot_timesteps
    
    disp(time)
    
    for x = 1 : num_clients
        disp(clients(x).current_channel_state)
    end
    
    index = check_clients_in_on_channel(clients, num_clients)
    
    client_to_schedule = [];
    
    if (~isempty(index))
    deficit_on = zeros(1,length(index));
    
    for x = index
        deficit_on(x) = (clients(x).lambda * time - (clients(x).A_t + clients(x).U_t)) / clients(x).beta;  % calculate deficit per ON client.
    end
     
    
    [max_deficit, choice] = max(deficit_on);
    choice
    
    client_to_schedule = index(choice);
    end
    
    schedule_and_update_parameters(client_to_schedule, clients, time, tot_timesteps, num_clients);
    
   
end

total_interrupt_rate = calculate_interrupt_rate(clients, num_clients, tot_timesteps);

end


