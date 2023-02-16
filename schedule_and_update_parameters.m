




function schedule_and_update_parameters(client_to_schedule, clients, current_timestep, tot_timesteps, num_clients)


global num_clients tot_timesteps clients

%fprintf('\n++++++ schedule_and_update_parameters++++++++++++\n')

for x = 1 : num_clients

    if (x == client_to_schedule)
        if(~isempty(clients(x).packet_deadline_array))
        if(clients(x).packet_deadline_array(1) < current_timestep)
        clients(x).A_t = clients(x).A_t + 1;
        clients(x).current_aoi_array(end+1) = max(1, current_timestep - clients(x).packet_deadline_array(1));
        clients(x).time_since_last_packet_was_generated = clients(x).packet_deadline_array(1);
        clients(x).delay_time_array(1) = [];
        clients(x).packet_deadline_array(1) = [];
        elseif(clients(x).packet_deadline_array(1) >= current_timestep)
          clients(x).U_t = clients(x).U_t + 1; % send a dummy packet instead.  
          clients(x).current_aoi_array(end+1) = max(1, current_timestep - clients(x).time_since_last_packet_was_generated);
        
        else
        if (current_timestep >= clients(x).delay_time_array(1))
        clients(x).delay_time_array(1) = [];
        clients(x).packet_deadline_array(1) = [];
        clients(x).D_t = clients(x).D_t + 1;
        clients(x).current_aoi_array(end+1) = clients(x).current_aoi_array(end) + 1;
        end
        end
        else
            clients(x).U_t = clients(x).U_t + 1;
            clients(x).current_aoi_array(end+1) = max(1, current_timestep - clients(x).time_since_last_packet_was_generated);
        end 
    else
        if(isempty(clients(x).delay_time_array))
            clients(x).current_aoi_array(end+1) = max(1, current_timestep - clients(x).time_since_last_packet_was_generated);
            %continue
        else
        if (current_timestep >= clients(x).delay_time_array(1))
        clients(x).delay_time_array(1) = [];
        clients(x).packet_deadline_array(1) = [];
        clients(x).D_t = clients(x).D_t + 1;
        clients(x).current_aoi_array(end+1) = clients(x).current_aoi_array(end) + 1;
        end
        end
    end
    

    clients(x).avg_tot_interrupt_rate_per_timestep(end+1) = clients(x).D_t / current_timestep;


end 
    
%fprintf('\n-----------schedule_and_update_parameters------------\n')

end




