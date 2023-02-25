



function index = check_clients_in_on_channel(clients, num_clients, time)


global num_clients clients


index = zeros(1, num_clients);


for x = 1 : num_clients

    clients(x).current_state = simulate(clients(x).mc, 2);
    clients(x).current_state = clients(x).current_state(end);
    if (clients(x).current_state == 2)
    clients(x).current_state = 0;
    end
    

    index(x) =  clients(x).current_state;
end

index = find(index == 1);


end