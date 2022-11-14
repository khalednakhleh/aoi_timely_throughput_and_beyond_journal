



function [betas, delays, lambdas, p, q, qoe_penalty_constant] = get_client_values(num_clients, delay_total)

% p_n: prob of going from ON to OFF channel.
% q_n: prob of going from OFF to ON channel.

a = 0.15;
b = 0.85;

penalty_constant_array = [1,2];

%p = (b-a).*rand(num_clients,1) + a;
%q = (b-a).*rand(num_clients,1) + a;


q = [0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05]
p = [0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95]


betas = repelem(1/num_clients, num_clients);
delays = zeros(1,num_clients);
qoe_penalty_constant = [2,2,2,2,2,1,1,1,1,1] %,2,1,1,1];%zeros(1, num_clients);


for x = 1 : num_clients
    %qoe_penalty_constant(x) = penalty_constant_array(randi(length(penalty_constant_array), 1));
    delays(x) = (betas(x) / sum(betas)) * delay_total;
end



lambdas = [0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04]


assert(length(p) == num_clients);
assert(length(q) == num_clients);
assert(length(betas) == num_clients);
assert(length(delays) == num_clients);
assert(length(lambdas) == num_clients);
assert(length(qoe_penalty_constant) == num_clients);

delays 
lambdas 

%for i = 1 : num_clients
%    mustBeInteger(delays(i) / lambdas(i));
%end

end