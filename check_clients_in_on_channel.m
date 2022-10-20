



function ON_clients_index = check_clients_in_on_channel(clients, num_clients)


ON_clients_index = zeros(1, num_clients);


for x = 1 : num_clients
    ON_clients_index(x) =  clients(x).current_channel_state;
end

ON_clients_index = find(ON_clients_index == 1);


end