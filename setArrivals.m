




function arrival = setArrivals(lambda, time_since_last_generation, tot_timeslots)

global the_array_of_arrivals

time_if_packet_arrives = time_since_last_generation - log(rand)/lambda;

  if time_if_packet_arrives <= tot_timeslots
      arrival = ceil(time_if_packet_arrives);
      the_array_of_arrivals(end+1) = arrival;
  else
      arrival = -1;
  end


end