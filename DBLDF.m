


function  DBLDF(clients, num_clients, tot_timesteps)

global num_clients tot_timesteps clients


for time = 1 : tot_timesteps
    
    %fprintf('current timestep: %d\n', time)
    
    %disp('+++++channel states++++++')
    %for x = 1 : num_clients
    %    disp(clients(x).current_channel_state)
    %end
    %disp('------channel states------')
    
    
    index = check_clients_in_on_channel(clients, num_clients, time);
    
    client_to_schedule = [];
    
    if (~isempty(index))
    deficit_on = repelem(-999999999999999999999999, num_clients);
    
    for x = 1 : num_clients
        if (ismember(x, index))
        deficit_on(x) = (clients(x).lambda * time - (clients(x).A_t));  % calculate deficit per ON client.
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





