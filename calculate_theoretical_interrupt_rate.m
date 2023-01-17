






function calculate_theoretical_interrupt_rate(clients, num_clients, regime_selection)


global clients num_clients


for x = 1 : num_clients
   
    if (regime_selection == 1) % under-loaded regime
        q_ratio = clients(x).q; % for iid channel. comment out otherwise.
        %q_ratio = clients(x).q/(clients(x).q + clients(x).p);  % for ge channel. comment out otherwise.
        epsilon = 1 - (clients(x).lambda/q_ratio);
        
        clients(x).theoretical_interrupt_rate = exp((-2*(epsilon)*clients(x).delay*q_ratio) / clients(x).clientVars);
        
    elseif (regime_selection == 2) % over-loaded regime
        clients(x).theoretical_interrupt_rate = (clients(x).clientVars / (2*clients(x).delay));
    end
 
end


end



