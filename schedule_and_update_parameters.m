




function schedule_and_update_parameters(client_to_schedule, clients, current_timestep, tot_timesteps)


for x = 1 : num_clients
    
    while (current_timestep > clients(x).delay_time_array(1))
        clients(x).delay_time_array(1) = [];
        clients(x).packet_deadline_array(1) = [];
        clients(x).D_t = clients(x).D_t + 1;
    end
    
    
    if (x == client_to_schedule)
        
        if (clients(x).packet_deadline_array(1) == [])
        clients(x).U_t = clients(x).U_t + 1;
        else
            clients(x).A_t = clients(x).A_t + 1;
            clients(x).delay_time_array(1) = [];
            clients(x).packet_deadline_array(1) = [];
        end
        
        
    end
    
    packet_generator(clients, num_clients, clients(x).packet_deadline_array(end), tot_timesteps);
    check_channel_state(clients, num_clients);

    
end 


end