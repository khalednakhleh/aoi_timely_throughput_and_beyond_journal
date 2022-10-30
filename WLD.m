

function WLD(clients, num_clients, tot_timesteps)


global num_clients tot_timesteps clients


%packet_generator_all_clients(clients, num_clients, 0, tot_timesteps);

for time = 1 : tot_timesteps
    
    %fprintf('current timestep: %d\n', time)
    %fprintf('number of sent packets A_n(t): %d\n', clients(1).A_t)
    %fprintf('number of dummy packets U_n(t): %d\n', clients(1).U_t)
    %fprintf('number of dropped packets D_n(t): %d\n', clients(1).D_t)
    
    %disp('+++++channel states++++++')
    %for x = 1 : num_clients
    %     disp(clients(x).channel_states(time))
    %end
    %disp('------channel states------')
    
    %disp(clients(1).packet_deadline_array)
    %disp(clients(1).delay_time_array)

    index = check_clients_in_on_channel(clients, num_clients, time);
    
    client_to_schedule = [];
    
    if (~isempty(index))
    deficit_on = repelem(-999999999999999999999999, num_clients);
    
    for x = 1 : num_clients
        if (ismember(x, index))
        deficit_on(x) = (clients(x).lambda * time - (clients(x).A_t + clients(x).U_t)) / clients(x).beta;  % calculate deficit per ON client.
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















