


function WRand(clients, num_clients, tot_timesteps)

global num_clients tot_timesteps clients

packet_generator_all_clients(clients, num_clients, 1, tot_timesteps);
check_channel_state(clients, num_clients);



for time = 1 : tot_timesteps 

    
    index = check_clients_in_on_channel(clients, num_clients);
    
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
    client_to_schedule = randsample(index, 1, true, prob_array);
    
    end
    schedule_and_update_parameters(client_to_schedule, clients, time, tot_timesteps, num_clients);
    
    
end 

calculate_interrupt_rate(clients, num_clients, tot_timesteps);


end




