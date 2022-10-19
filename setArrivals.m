




function arrival = setArrivals(lambda, time_since_last_generation, tot_timeslots)

time_if_packet_arrives = time_since_last_generation - log(rand)/lambda;

  if time_if_packet_arrives <= tot_timeslots
      arrival = ceil(time_if_packet_arrives);
  else
      arrival = -1;
  end


end