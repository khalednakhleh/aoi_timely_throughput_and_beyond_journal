



function [betas, delays, lambdas, p, q, qoe_penalty_constant] = get_client_values(num_clients, delay_total)

% p_n: prob of going from ON to OFF channel.
% q_n: prob of going from OFF to ON channel.

a = 0.15;
b = 0.85;

penalty_constant_array = [1,2];

%p = (b-a).*rand(num_clients,1) + a;
%q = (b-a).*rand(num_clients,1) + a;


q = [0.75, 0.85, 0.65, 0.9, 0.7, 0.4, 0.7, 0.8, 0.45, 0.25]%, 0.15];
p = [0.6, 0.5, 0.7, 0.45, 0.35, 0.4, 0.3, 0.4, 0.55, 0.45]%, 0.65]; 


betas = repelem(1/num_clients, num_clients);
delays = zeros(1,num_clients);
qoe_penalty_constant = [2,2,2,2,2,1,1,1,1,1] %,2,1,1,1];%zeros(1, num_clients);


for x = 1 : num_clients
    %qoe_penalty_constant(x) = penalty_constant_array(randi(length(penalty_constant_array), 1));
    delays(x) = (betas(x) / sum(betas)) * delay_total;
end


lambdas = [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1]; %, 0.1, 0.2, 0.2, 0.01, 0.05]%, 0.2, 0.2, 0.2, 0.1]; %,0.5,0.5,0.5,0.5] % for two clients


assert(length(p) == num_clients);
assert(length(q) == num_clients);
assert(length(betas) == num_clients);
assert(length(delays) == num_clients);
assert(length(lambdas) == num_clients);


delays 
lambdas 

%for i = 1 : num_clients
%    mustBeInteger(delays(i) / lambdas(i));
%end

end