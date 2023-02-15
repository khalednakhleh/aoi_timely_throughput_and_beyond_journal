






function calculate_theoretical_interrupt_rate(clients, num_clients, sigma_tot, delays)


global clients num_clients


for x = 1 : num_clients
   
     clients(x).theoretical_vwd_rate = (clients(x).clientVars / (2*clients(x).delay));
     clients(x).theoretical_wld_rate = (sigma_tot^2 / (2*sum(delays)^2));
     clients(x).theoretical_dbldf_rate = ((sigma_tot/num_clients)^2 / (2*clients(x).delay));
end


end



