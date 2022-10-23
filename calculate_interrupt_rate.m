


function calculate_interrupt_rate(clients, num_clients, tot_timesteps)


global num_clients tot_timesteps clients


total_interrupt_rate = 0;

qoe_penalty = 0;

for x = 1 : num_clients
    total_interrupt_rate = total_interrupt_rate + clients(x).D_t;
    qoe_penalty = qoe_penalty + (clients(x).qoe_penalty_constant *(clients(x).D_t / tot_timesteps)^2 );
end

total_interrupt_rate = total_interrupt_rate / tot_timesteps;


for i = 1 : num_clients
    
   clients(i).avg_tot_interrupt_rate =  total_interrupt_rate; 
 
end


for i = 1 : num_clients
    clients(i).qoe_penalty = qoe_penalty;
end

end
