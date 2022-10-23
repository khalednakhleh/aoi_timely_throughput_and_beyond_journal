


function EDF(clients, num_clients, tot_timesteps)


global num_clients tot_timesteps clients


packet_generator_all_clients(clients, num_clients, 1, tot_timesteps);
check_channel_state(clients, num_clients);


for time = 1 : tot_timesteps
    
    %fprintf('current timestep: %d\n', time)
    
    %disp('+++++channel states++++++')
    %for x = 1 : num_clients
    %    disp(clients(x).current_channel_state)
    %end
    %disp('------channel states------')
    
    
    index = check_clients_in_on_channel(clients, num_clients);
    
    
    if(~isempty(index))
    deadline_list = [];
    for x = 1 : num_clients
       if (ismember(x, index))
           if(isempty(clients(x).delay_time_array))
            deadline_list(end + 1) = tot_timesteps*5; % other value that we don't consider.
           else
           deadline_list(end + 1) = clients(x).delay_time_array(1);
           end
       end
    end
    
    deadline_list;
    [max_deficit, choice] = min(deadline_list);

    
    client_to_schedule = choice;
    end
    
    schedule_and_update_parameters(client_to_schedule, clients, time, tot_timesteps, num_clients);

    
    %fprintf('\n----------------------------------------------------------------\n');
    
end

calculate_interrupt_rate(clients, num_clients, tot_timesteps);

end