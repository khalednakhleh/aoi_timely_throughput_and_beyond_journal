



function [betas, delays, lambdas, p, q, qoe_penalty_constant] = get_client_values(num_clients, delay_total)

a = 0.05;
b = 0.95;


%p = (b-a).*rand(num_clients,1) + a;
%q = (b-a).*rand(num_clients,1) + a;

p = 0.5;
q = 0.8;


%betas = linspace(a,b, num_clients);
betas = repelem(1/num_clients, num_clients);

delays = zeros(1,num_clients);
qoe_penalty_constant = [1];%,2,1,1,1]; % for calculating qoe_penalty.

for x = 1 : num_clients
   delays(x) = (betas(x) / sum(betas)) * delay_total;
end

lambdas = [0.01]; %, 0.5]; % for two clients


assert(length(p) == num_clients);
assert(length(q) == num_clients);
assert(length(betas) == num_clients);
assert(length(delays) == num_clients);
assert(length(lambdas) == num_clients);

end