




function set_arrivals(tot_timesteps)

global the_array_of_arrivals how_many_times_I_have_arrival 
global clients num_clients tot_timesteps



%{
time_if_packet_arrives = time_since_last_generation - log(rand)/lambda;

  if time_if_packet_arrives <= tot_timeslots
      arrival = ceil(time_if_packet_arrives);
      the_array_of_arrivals(end+1) = arrival;
  else
      arrival = -1;
  end
  
  %}
  
  for x = 1 : num_clients 
      events = zeros(1, tot_timesteps);
      R = rand(size(events));
      events(R<clients(x).lambda)=1;
      inds=find(events==1);
      
      clients(x).packet_deadline_array = inds;
      clients(x).delay_time_array = inds + (clients(x).delay / clients(x).lambda);
  end

how_many_times_I_have_arrival = how_many_times_I_have_arrival + 1;




end




