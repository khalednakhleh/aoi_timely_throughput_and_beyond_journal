


function calculate_interrupt_rate(clients, num_clients, tot_timesteps, regime_selection)


global num_clients tot_timesteps clients


for x = 1 : num_clients

     if(regime_selection == 1 && x<=(floor(num_clients/2)))
     clients(x).tot_interrupt_rate = sum(clients(x).current_aoi_array)/ tot_timesteps;
     else

         if(regime_selection == 2 || regime_selection == 1)
    clients(x).tot_interrupt_rate = (clients(x).delay^2) * (clients(x).D_t / tot_timesteps);
         else
     clients(x).tot_interrupt_rate = (clients(x).D_t / tot_timesteps) + (clients(x).weight * clients(x).delay^2);        
     end
end


end
