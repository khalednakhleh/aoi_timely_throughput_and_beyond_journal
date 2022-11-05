

clc, clear all

lambda = 0.2

tot_timesteps = 11

arrival_every_timeslots = 1/lambda

mustBeInteger(arrival_every_timeslots)

repeating_array = [1, repelem( 0, arrival_every_timeslots-1)]
arrival_array = repmat(repeating_array, 1, ceil(tot_timesteps/length(repeating_array)))



    
inds=find(arrival_array==1)
