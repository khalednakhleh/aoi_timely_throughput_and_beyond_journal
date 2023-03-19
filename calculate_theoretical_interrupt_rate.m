



function calculate_theoretical_interrupt_rate(clients, num_clients, sigma_tot, delays, regime_selection)


global clients num_clients

   
for x = 1 : num_clients

    if(regime_selection == 1 && x<=(floor(num_clients/2))) % if client is an AoI client
     clients(x).theoretical_vwd_rate = 0.5 * (clients(x).clientVars /(clients(x).mu^2) + 1/clients(x).mu) + 1/clients(x).aoi_lambda - 0.5;

    elseif(regime_selection == 1 && x>(floor(num_clients/2)))

     clients(x).theoretical_vwd_rate = (clients(x).delay^2)*(clients(x).clientVars / (2*clients(x).delay));
     clients(x).theoretical_wld_rate = (clients(x).delay^2)*((sigma_tot^2 * clients(x).delay) / (2*(sum(delays))^2));
     clients(x).theoretical_dbldf_rate = (clients(x).delay^2)*((sigma_tot/num_clients)^2 / (2*clients(x).delay));

    elseif(regime_selection == 2)

     clients(x).theoretical_vwd_rate = (clients(x).delay^2)*(clients(x).clientVars / (2*clients(x).delay));
     clients(x).theoretical_wld_rate = (clients(x).delay^2)*((sigma_tot^2 * clients(x).delay) / (2*(sum(delays))^2));
     clients(x).theoretical_dbldf_rate = (clients(x).delay^2)*((sigma_tot/num_clients)^2 / (2*clients(x).delay));

    elseif(regime_selection == 3)
     clients(x).theoretical_vwd_rate = (3*clients(x).weight*sqrt(clients(x).clientVars)^(4/3)) / ((4 * clients(x).weight)^(2/3));
     clients(x).theoretical_wld_rate = ((sigma_tot^2 * clients(x).delay) / (2 * (sum(delays))^2))  + clients(x).weight * clients(x).delay^2; 
     clients(x).theoretical_dbldf_rate = (sigma_tot^2 / (2 * num_clients^2 * clients(x).delay)) + clients(x).weight * clients(x).delay^2;

    else
      error("Selected regime does not have theoretical value. Exiting.");
     

    end
end


end



