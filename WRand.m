


function WRand(clients, num_clients, tot_timesteps)

global num_clients tot_timesteps clients


for time = 1 : tot_timesteps 

    %fprintf('current timestep: %d\n', time)
    
    %disp('+++++channel states++++++')
    %for x = 1 : num_clients
    %    disp(clients(x).channel_states(time))
    %end
    %disp('------channel states------')
    
    index = check_clients_in_on_channel(clients, num_clients, time);
    
    client_to_schedule = [];
    
    if (~isempty(index))
    tot_prob = 0;
    prob_array = [];
    for x = 1 : num_clients
        if (ismember(x, index))
            tot_prob = tot_prob + clients(x).lambda;
            prob_array(end+1) = clients(x).lambda;
        end
    end
    prob_array = prob_array ./ tot_prob;
 
    if length(index) == 1 
        client_to_schedule = index;
    else
    client_to_schedule = randsample(index, 1, true, prob_array);
    end
    
    end
    schedule_and_update_parameters(client_to_schedule, clients, time, tot_timesteps, num_clients);
    
    %fprintf('\n----------------------------------------------------------------\n')
end 

calculate_interrupt_rate(clients, num_clients, tot_timesteps);


end




