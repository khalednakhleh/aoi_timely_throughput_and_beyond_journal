




function schedule_and_update_parameters(client_to_schedule, clients, current_timestep, tot_timesteps, num_clients)


global num_clients tot_timesteps clients

%fprintf('\n++++++ schedule_and_update_parameters++++++++++++\n')

for x = 1 : num_clients
    

    if (x == client_to_schedule)
        if(clients(x).packet_deadline_array(1) < current_timestep)
        clients(x).A_t = clients(x).A_t + 1;
        clients(x).delay_time_array(1) = [];
        clients(x).packet_deadline_array(1) = [];
        elseif(clients(x).packet_deadline_array(1) >= current_timestep)
          clients(x).U_t = clients(x).U_t + 1; % send a dummy packet instead.    
        
        else
        while (current_timestep >= clients(x).delay_time_array(1))
        clients(x).delay_time_array(1) = [];
        clients(x).packet_deadline_array(1) = [];
        clients(x).D_t = clients(x).D_t + 1;
        end
        end
    else
    while (current_timestep >= clients(x).delay_time_array(1))
        clients(x).delay_time_array(1) = [];
        clients(x).packet_deadline_array(1) = [];
        clients(x).D_t = clients(x).D_t + 1;
    end
    end

end 
    
%fprintf('\n-----------schedule_and_update_parameters------------\n')

end




