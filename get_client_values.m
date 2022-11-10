



function [betas, delays, lambdas, p, q, qoe_penalty_constant] = get_client_values(num_clients, delay_total)

a = 0.15;
b = 0.85;

penalty_constant_array = [1,2];

%p = (b-a).*rand(num_clients,1) + a;
%q = (b-a).*rand(num_clients,1) + a;


q = [0.5, 0.45, 0.375, 0.23, 0.11];
p = [0.7, 0.656, 0.93, 0.457, 0.845];

betas = repelem(1/num_clients, num_clients);
delays = zeros(1,num_clients);
qoe_penalty_constant = [1,1,2,2,2];%zeros(1, num_clients);


for x = 1 : num_clients
    %qoe_penalty_constant(x) = penalty_constant_array(randi(length(penalty_constant_array), 1));
    delays(x) = (betas(x) / sum(betas)) * delay_total;
end


lambdas = [0.1, 0.2, 0.2, 0.2, 0.1]; %,0.5,0.5,0.5,0.5] % for two clients


assert(length(p) == num_clients);
assert(length(q) == num_clients);
assert(length(betas) == num_clients);
assert(length(delays) == num_clients);
assert(length(lambdas) == num_clients);


delays 
lambdas 

for i = 1 : num_clients
    mustBeInteger(delays(i) / lambdas(i));
end

end