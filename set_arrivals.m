

function set_arrivals(tot_timesteps)

global clients num_clients tot_timesteps


  for x = 1 : num_clients 

      arrival_every_timeslots = 1/clients(x).lambda;
      
      mustBeInteger(arrival_every_timeslots);
      repeating_array = [1, repelem( 0, arrival_every_timeslots-1)];

      arrivals = repmat(repeating_array, 1, ceil(tot_timesteps/length(repeating_array)) + 1);
      
      arrivals = arrivals(1:tot_timesteps + 1); % trimming the packets' sequence
      
      inds=find(arrivals==1);
      
      inds = inds - 1;

      
      clients(x).packet_deadline_array = inds; % times at which we generate a packet (available to transmit at end of timestep)
      clients(x).delay_time_array = inds + (clients(x).delay / clients(x).lambda); % time for a packet's deadline
      
  end


end




