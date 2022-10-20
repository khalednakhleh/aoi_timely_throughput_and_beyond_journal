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




function packet_generator(clients, num_clients, time_since_last_generation, tot_timesteps)


for x = 1 : num_clients
    
    packet_time = setArrivals(clients(x).lambda, time_since_last_generation, tot_timesteps);
    
    if (packet_time ~= -1)
    clients(x).packet_deadline_array(end + 1) = packet_time;
    clients(x).delay_time_array(end + 1) = packet_time + (clients(x).delay / clients(x).lambda);
    else
        % do nothing
    end
        

   
    
end


end





