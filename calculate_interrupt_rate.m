


function calculate_interrupt_rate(clients, num_clients, tot_timesteps)


global num_clients tot_timesteps clients


for x = 1 : num_clients
    clients(x).tot_interrupt_rate = clients(x).D_t / tot_timesteps;
end


end
