


function  DBLDF(clients, num_clients, tot_timesteps, regime_selection)

global num_clients tot_timesteps clients


for time = 1 : tot_timesteps
    
    %fprintf('current timestep: %d\n', time)

    %disp('+++++channel states++++++')
    %for x = 1 : num_clients
    %     fprintf('number of sent packets A_n(t) for client %d: %d\n',x, clients(x).A_t)
    %     fprintf('number of dummy packets U_n(t) for client %d: %d\n',x, clients(x).U_t)
    %     fprintf('number of dropped packets D_n(t) for client %d: %d\n',x, clients(x).D_t) 
    %     fprintf('channel state for client %d: %d\n', x, clients(x).channel_states(time))
    %     disp(clients(x).packet_deadline_array)
    %     disp(clients(x).delay_time_array)
    %end
    %disp('------channel states------')
    

    
    index = check_clients_in_on_channel(clients, num_clients, time);
    
    client_to_schedule = [];
    
    if (~isempty(index))
    deficit_on = repelem(-999999999999999999999999, num_clients);
    
    for x = 1 : num_clients
        if (ismember(x, index))
        deficit_on(x) = ((time/clients(x).period) - (clients(x).A_t));  % calculate deficit per ON client.
        end
    end
     
    deficit_on;
    [max_deficit, client_to_schedule] = max(deficit_on);

    end
    
    schedule_and_update_parameters(client_to_schedule, clients, time, tot_timesteps, num_clients);
    
    
    
   %fprintf('\n----------------------------------------------------------------\n');
end


calculate_interrupt_rate(clients, num_clients, tot_timesteps);

end





