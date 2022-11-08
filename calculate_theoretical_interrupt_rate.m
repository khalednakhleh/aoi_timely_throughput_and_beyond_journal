






function calculate_theoretical_interrupt_rate(clients, num_clients, regime_selection)


global clients num_clients


for x = 1 : num_clients
   
    if (regime_selection == 1) % under-loaded regime
        clients(x).theoretical_interrupt_rate = exp(((-2*(clients(x).mu - clients(x).lambda)) / clients(x).clientVars) * clients(x).delay);
        disp(clients(x).theoretical_interrupt_rate)
    elseif (regime_selection == 2) % over-loaded regime
        clients(x).theoretical_interrupt_rate = (clients(x).clientVars / (2*clients(x).delay));
    end
    
end


end



