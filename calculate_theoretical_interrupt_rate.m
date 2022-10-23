






function calculate_theoretical_interrupt_rate(clients, num_clients, regime_selection)


global clients num_clients


tot_theoretical_interrupt_rate = 0;


for x = 1 : num_clients
   
    if (regime_selection == 1) % under-loaded regime
        tot_theoretical_interrupt_rate = tot_theoretical_interrupt_rate + exp(((-2*(clients(x).mu - clients(x).lambda)) / clients(x).clientVars) * clients(x).delay);
    elseif (regime_selection == 2) % over-loaded regime
        tot_theoretical_interrupt_rate = tot_theoretical_interrupt_rate + (clients(x).clientVars / (2*clients(x).delay));
    end
    
end


for x = 1 : num_clients
    clients(x).theoretical_interrupt_rate = tot_theoretical_interrupt_rate; % same for all clients.
end

end



