

function [delays, periods, p, q, lambdas] = get_client_values(num_clients)

% p_n: prob of going from ON to OFF channel.
% q_n: prob of going from OFF to ON channel.

if num_clients == 1
interval = 0.1;
starting_q = 0.3;
starting_factor = 0.9;
initial_delay_value = [15];

elseif num_clients == 5
% for 5 clients
interval = 0.1;
starting_q = 0.3;
starting_factor = 0.9;
initial_delay_value = [20, 30, 40, 50, 60];
%[10, 20, 30, 40, 50]; % for regime 2
%[5, 5, 10, 20, 30] % for regime 1

elseif num_clients == 10
% for 10 clients
interval = 0.05;
starting_q = 0.2326;
starting_factor = 0.9;
initial_delay_value = [15, 25, 35, 45, 55, 65, 75, 85, 95, 105];
%[10, 10, 10, 10, 10, 15, 25, 35, 45, 55]; % for regime 1
%[15, 25, 35, 45, 55, 65, 75, 85, 95, 105]; % for regime 2


elseif num_clients == 20
% for 20 clients
interval = 0.025;
starting_q = 0.15;
starting_factor = 0.95;
initial_delay_value = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200];
% [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100] % for regime 1
%[10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200]; % for regime 2
else
    error("number of clients not implemented. exiting.");
end

delays = zeros(1,num_clients);
period_val = num_clients + 1;


period_sum = 0;


for x = 1 : num_clients
    periods(x) = period_val;
    delays(x) = initial_delay_value(x); %initial_delay_value + delay_interval*(x-1); % % setting the delay value here. 
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



% for aoi clients only (generate for total number of clients even though we use floor(num_clients/2))


lambda_max_range = 1 / num_clients;
lambda_min_range = 0.1 / num_clients;

lambdas = (lambda_max_range-lambda_min_range).*rand(1,num_clients) + lambda_min_range;


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
assert(length(lambdas) == num_clients)


lambdas
delays
periods
p
q

end