






function calculate_theoretical_interrupt_rate(clients, num_clients, sigma_tot, delays, regime_selection)


global clients num_clients


for x = 1 : num_clients

    if(regime_selection == 1 && x<=(floor(num_clients/2))) % if client is an AoI client
     clients(x).theoretical_vwd_rate = 0.5 * (clients(x).clientVars /(clients(x).mu^2) + 1/clients(x).mu) + 1/clients(x).aoi_lambda - 0.5;
    else
     clients(x).theoretical_vwd_rate = (clients(x).clientVars / (2*clients(x).delay));
     clients(x).theoretical_wld_rate = (sigma_tot^2 / (2*sum(delays)^2));
     clients(x).theoretical_dbldf_rate = ((sigma_tot/num_clients)^2 / (2*clients(x).delay));
    end
end


end



