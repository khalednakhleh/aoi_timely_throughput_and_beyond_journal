

function WLD(clients, num_clients, tot_timesteps)


global num_clients tot_timesteps clients


packet_generator_all_clients(clients, num_clients, 1, tot_timesteps);
check_channel_state(clients, num_clients);

for time = 1 : tot_timesteps
    
    %fprintf('current timestep: %d\n', time)
    
    %disp('+++++channel states++++++')
    %for x = 1 : num_clients
    %     disp(clients(x).current_channel_state)
    %end
    %disp('------channel states------')
    
    index = check_clients_in_on_channel(clients, num_clients);
    
    client_to_schedule = [];
    
    if (~isempty(index))
    deficit_on = repelem(-999999999999999999999999, num_clients);
    
    for x = 1 : num_clients
        if (ismember(x, index))
        deficit_on(x) = (clients(x).lambda * time - (clients(x).A_t + clients(x).U_t)) / clients(x).beta;  % calculate deficit per ON client.
        end
    end
     
    deficit_on;
    [max_deficit, choice] = max(deficit_on);

    
    client_to_schedule = choice;
    end
    
    schedule_and_update_parameters(client_to_schedule, clients, time, tot_timesteps, num_clients);
    
   %fprintf('\n----------------------------------------------------------------\n');
end

calculate_interrupt_rate(clients, num_clients, tot_timesteps);

end


