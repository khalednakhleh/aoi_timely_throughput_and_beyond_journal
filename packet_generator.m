% author: Khaled Nakhleh
%{
generates packets based on the arrival rate \lambda_n 
for client n. 
If a packet is generated, it is stored in the client's data structure.
The packet delay is also stored for each generated packet.

The function also generates the channel condition information (1 if ON, 0
if OFF) to be used later by the scheduler. 
The scheduler picks the clients that are in the ON channel state for
scheduling. 
%}


function packet_generator(clients, num_clients, time_since_last_generation, tot_timesteps, selected_client)

global num_clients tot_timesteps clients

%fprintf('\n++++packet_generator++++++++\n')
   
    packet_time = setArrivals(clients(selected_client).lambda, time_since_last_generation, tot_timesteps);
    
    if (packet_time ~= -1)
    clients(selected_client).packet_deadline_array(end + 1) = packet_time;
    clients(selected_client).delay_time_array(end + 1) = packet_time + (clients(selected_client).delay / clients(selected_client).lambda);
    else
        % don't add a packet
    end
    
    
    %for d = 1 : length(clients(selected_client).packet_deadline_array)
    %fprintf('packet_generation_time for client %d: %d\n', selected_client, clients(selected_client).packet_deadline_array(d))
    %fprintf('packet delay time for client %d: %d\n', selected_client, clients(selected_client).delay_time_array(d))
    %end

   
   %fprintf('\n---------packet_generator---------\n') 
end







