%{
% Author: Khaled Nakhleh.
%}


SEED = 24642;

rng(SEED);

global LAMBDA L

%% Constants 

LAMBDA = 0.5; % 1 / LAMBDA must be an integer. 

L = 2; % delay.

mustBeInteger(1/LAMBDA)
mustBeInteger(L)

P = 0.8; % prob of going from ON to OFF channel state.

Q = 0.21; % prob of going from OFF to ON channel state.

TIME = 150000; % total timesteps.

MC = createmc(P, Q);


% First element holds the timeslot a packet is generated (generated at the end of that timeslot).
% Second element holds the time by which the packet must be sent. 
[packet_generation_array, packet_delay] = set_arrivals(TIME);

packet_generation_array;
packet_delay;

channel_states = simulate(MC, TIME)';

channel_states(channel_states == 2) = 0;
% Print the number of timeslots we are in the on or off channel states.
len_on = length(channel_states(channel_states==1));
len_off = length(channel_states(channel_states==2));


%% Main loop

A_t = 0; % number of packets sent.
U_t = 0; % number of dummy packets sent.
D_t = 0; % video interruption rate. 

% We start at timeslot 1. We always have the first packet generated at
% timeslot 0 ( generated at the end of timeslot 0 and ready for transmission in timeslot 1).


counter_one = 0;
counter_two = 0;



for current_timeslot = 1 : TIME

%fprintf('current timeslot: %d\n', current_timeslot)
%fprintf('channel state: %d\n', channel_states(current_timeslot))
%packet_generation_array
%packet_delay
%fprintf('A_t: %d\n', A_t)
%fprintf('U_t: %d\n', U_t)
%fprintf('D_t: %d\n', D_t)
%disp('+++++++++++++++++++++++++')


    if (channel_states(current_timeslot) == 1) % If we are in the ON channel.
        
        counter_one = counter_one + 1;
    
        if (~isempty(packet_generation_array))
    
        if (current_timeslot > packet_generation_array(1)) 
            
            A_t = A_t + 1;
            packet_generation_array(1) = [];
            packet_delay(1) = [];
            
        elseif(current_timeslot <= packet_generation_array(1))
            U_t = U_t + 1;
        end
        else
            U_t = U_t + 1;
        end
    
     else % If we are in the OFF channel. 
         counter_two = counter_two + 1;
         if(isempty(packet_generation_array))
             continue
         else
             if (current_timeslot >= packet_delay(1))
                 packet_delay(1) = [];
                 packet_generation_array(1) = [];
                 D_t = D_t + 1;
             end
         end
         
    end
end



fprintf('A_t: %d\n', A_t)
fprintf('U_t: %d\n', U_t)
fprintf('D_t: %d\n', D_t)

counter_one
counter_two

first_client_asymptotics = asymptotics(MC)

%% Utility functions


function MC = createmc(P, G)

TRANS = [1-P, P ;
         G, 1-G];

MC =  dtmc(TRANS, 'StateNames', ["ON", "OFF"]);
graphplot(MC,'ColorEdges',true);
end



function [packet_generation_array, packet_delay] = set_arrivals(TIME)

  global LAMBDA L
  arrival_every_timeslots = 1/LAMBDA;

  repeating_array = [1, repelem( 0, arrival_every_timeslots-1)];

  arrivals = repmat(repeating_array, 1, ceil(TIME/length(repeating_array)) + 1);

  arrivals = arrivals(1:TIME + 1); % trimming the packets' sequence

  inds=find(arrivals==1);

  inds = inds - 1;


  packet_generation_array = inds; % times at which we generate a packet (available to transmit at end of timestep)
  packet_delay = inds + (L / LAMBDA); % time for a packet's deadline


end


