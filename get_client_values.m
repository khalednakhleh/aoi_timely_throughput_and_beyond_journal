



function [delays, periods, p, q] = get_client_values(num_clients)

% p_n: prob of going from ON to OFF channel.
% q_n: prob of going from OFF to ON channel.

if num_clients == 1
interval = 0.1;
starting_q = 0.3;
delay_interval = 10;
starting_factor = 0.9;

elseif num_clients == 5
% for 5 clients
interval = 0.1;
starting_q = 0.3;
delay_interval = 10;
starting_factor = 0.9;

elseif num_clients == 10
% for 10 clients
interval = 0.05;
starting_q = 0.25;
delay_interval = 10;
starting_factor = 0.95;

elseif num_clients == 20
% for 20 clients
interval = 0.025;
starting_q = 0.15;
delay_interval = 4;
starting_factor = 0.95;

else
    error("number of clients not implemented. exiting.");
end

delays = zeros(1,num_clients);
period_val = num_clients + 1;


period_sum = 0;


for x = 1 : num_clients
    periods(x) = period_val;
    delays(x) = 20 + delay_interval*(x-1);    % setting the delay value here. 
    period_sum = period_sum + (1/periods(x));
end


pq_ratio = nthroot(1 - period_sum, num_clients); 
p_ratio = pq_ratio / (1 - pq_ratio); % p is equal this value * q. 


q(1) = starting_q; % the first q value 
p(1) = q(1) * p_ratio; 


for x = 1 : num_clients 
    if x == 1 
        continue 
    end
        p(x) = starting_factor*pq_ratio;
        q(x) = starting_factor*(1 - pq_ratio);
        starting_factor = starting_factor - interval;
end 


prod_val = 1;


for x = 1 : num_clients
    prod_val = prod_val*(p(x) / (p(x) + q(x)));
end

prod_val;
value_to_compare_against = 1 - period_sum;

assert(length(p) == num_clients);
assert(length(q) == num_clients);
assert(length(delays) == num_clients);
assert(length(periods) == num_clients);
assert(sum(p > 1) == 0)
assert(sum(p < 0) == 0) % ensure that sum of elements violating condition is zero.
assert(sum(q > 1) == 0)
assert(sum(q < 0) == 0) % ensure that sum of elements violating condition is zero.




end