


function total_interrupt_rate = calculate_interrupt_rate(clients)


total_interrupt_rate = 0;

for x = 1 : num_clients
    total_interrupt_rate = total_interrupt_rate + clients(x).D_t;
end

total_interrupt_rate = total_interrupt_rate / tot_timesteps;


end