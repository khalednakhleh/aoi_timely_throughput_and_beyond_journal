



function index = check_clients_in_on_channel(clients, num_clients, time)


global num_clients clients


index = zeros(1, num_clients);


for x = 1 : num_clients
    index(x) =  clients(x).channel_states(time);
end

index = find(index == 1);


end