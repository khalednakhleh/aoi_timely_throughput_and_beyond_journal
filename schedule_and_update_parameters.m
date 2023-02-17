




function schedule_and_update_parameters(client_to_schedule, clients, current_timestep, tot_timesteps, num_clients, regime_selection)


global num_clients tot_timesteps clients

%fprintf('\n++++++ schedule_and_update_parameters++++++++++++\n')

for x = 1 : num_clients

    if(regime_selection == 1 && x <= floor(num_clients/2)) % update aoi values for the client
    
     if (x == client_to_schedule)

         if (randsrc(1, 1, [1 0; clients(x).aoi_lambda 1 - clients(x).aoi_lambda]) == 1) % if there is a packet to transmit 
             %fprintf("!!!!!!!!!!!!!!packet received for scheduled client: %d", x)
         clients(x).time_since_last_packet_was_generated = current_timestep;
         clients(x).current_aoi_array(end+1) = 1;

         else % if there is no packet to transmit
             %if (current_timestep == 1)
                 clients(x).current_aoi_array(end+1) = current_timestep - clients(x).time_since_last_packet_was_generated;
             %else
             %    clients(x).current_aoi_array(end+1) = current_timestep - clients(x).time_since_last_packet_was_generated;
             %end
         end
     
     else
         if (randsrc(1, 1, [1 0; clients(x).aoi_lambda 1 - clients(x).aoi_lambda]) == 1) % if there is a packet to transmit 
             %fprintf("!!!!!!!!!!!!!!packet received for non-scheduled client: %d", x)
         clients(x).time_since_last_packet_was_generated = current_timestep;
         clients(x).current_aoi_array(end+1) = clients(x).current_aoi_array(end) + 1; 
         else
         clients(x).current_aoi_array(end+1) = clients(x).current_aoi_array(end) + 1;
         end
     end

     if current_timestep == tot_timesteps
     clients(x).current_aoi_array(end) = [];
     end

     clients(x).avg_tot_aoi_value(end+1) = clients(x).current_aoi_array(end) / current_timestep;
    

    else   % update throughput client values

    if (x == client_to_schedule)
        if(~isempty(clients(x).packet_deadline_array))
        if(clients(x).packet_deadline_array(1) < current_timestep)
        clients(x).A_t = clients(x).A_t + 1;
        clients(x).delay_time_array(1) = [];
        clients(x).packet_deadline_array(1) = [];
        elseif(clients(x).packet_deadline_array(1) >= current_timestep)
          clients(x).U_t = clients(x).U_t + 1; % send a dummy packet instead.  

        else
        if (current_timestep >= clients(x).delay_time_array(1))
        clients(x).delay_time_array(1) = [];
        clients(x).packet_deadline_array(1) = [];
        clients(x).D_t = clients(x).D_t + 1;
        end
        end
        else
            clients(x).U_t = clients(x).U_t + 1;
        end 
    else
        if(isempty(clients(x).delay_time_array))
            continue
        else
        if (current_timestep >= clients(x).delay_time_array(1))
        clients(x).delay_time_array(1) = [];
        clients(x).packet_deadline_array(1) = [];
        clients(x).D_t = clients(x).D_t + 1;
        end
        end
    end
    

    clients(x).avg_tot_interrupt_rate_per_timestep(end+1) = clients(x).D_t / current_timestep;


    end 
    
%fprintf('\n-----------schedule_and_update_parameters------------\n')

end




