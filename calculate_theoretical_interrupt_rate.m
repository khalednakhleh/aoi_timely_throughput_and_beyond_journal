






function calculate_theoretical_interrupt_rate(clients, num_clients, sigma_tot, delays, regime_selection)


global clients num_clients


for x = 1 : num_clients

    if(regime_selection == 1 && x<(floor(num_clients/2))) % if client is an AoI client
     clients(x).theoretical_vwd_rate = -0.5 * (vars(x)/(mu(x)^2) + (((1/mu(x)) + 1)) + (periods(x)) - 1);
     clients(x).theoretical_wld_rate = -0.5 * (vars(x)/(mu(x)^2) + (((1/mu(x)) + 1)) + (periods(x)) - 1);
     clients(x).theoretical_dbldf_rate = -0.5 * (vars(x)/(mu(x)^2) + (((1/mu(x)) + 1)) + (periods(x)) - 1);

    else
     clients(x).theoretical_vwd_rate = (clients(x).clientVars / (2*clients(x).delay));
     clients(x).theoretical_wld_rate = (sigma_tot^2 / (2*sum(delays)^2));
     clients(x).theoretical_dbldf_rate = ((sigma_tot/num_clients)^2 / (2*clients(x).delay));
    end
end


end



