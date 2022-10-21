




function schedule_and_update_parameters(client_to_schedule, clients, current_timestep, tot_timesteps, num_clients)


global num_clients tot_timesteps clients

%fprintf('\n++++++ schedule_and_update_parameters++++++++++++\n')

for x = 1 : num_clients
    
    if (~isempty(clients(x).delay_time_array))
    while (current_timestep > clients(x).delay_time_array(1))
        clients(x).delay_time_array(1) = [];
        clients(x).packet_deadline_array(1) = [];
        clients(x).D_t = clients(x).D_t + 1;
    end
    end
    
    if (x == client_to_schedule)
        
        if (isempty(clients(x).packet_deadline_array))
        clients(x).U_t = clients(x).U_t + 1; % send a dummy packet instead.
        else
            if(clients(x).packet_deadline_array(1) < current_timestep)
            clients(x).A_t = clients(x).A_t + 1;
            clients(x).delay_time_array(1) = [];
            clients(x).packet_deadline_array(1) = [];
            else
            clients(x).U_t = clients(x).U_t + 1; % send a dummy packet instead.    
            end
        end
        
        
    end
    
    if(~isempty(clients(x).packet_deadline_array))
        %fprintf('\n final packet generation time: %d\n',clients(x).packet_deadline_array(end))
        
    packet_generator(clients, num_clients, clients(x).packet_deadline_array(end), tot_timesteps, x);
    
    else
        %fprintf('\n it is empty and the timestep is: %d', current_timestep)
    packet_generator(clients, num_clients, current_timestep, tot_timesteps, x);
       
    end
       check_channel_state(clients, num_clients);
    
end 

%fprintf('\n-----------schedule_and_update_parameters------------\n')
end