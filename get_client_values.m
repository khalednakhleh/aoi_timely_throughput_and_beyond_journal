



function [betas, delays, lambdas, p, q] = get_client_values(num_clients, delay_total)

a = 0.05;
b = 0.95;


p = (b-a).*rand(num_clients,1) + a;
q = (b-a).*rand(num_clients,1) + a;


betas = linspace(a,b, num_clients);
%betas = repelem(1/num_clients, num_clients);


delays = repelem(1/delay_total, num_clients);


lambdas = [0.2, 0.5];


assert( length(p) == num_clients);
assert( length(q) == num_clients);
assert( length(betas) == num_clients);
assert( length(delays) == num_clients);
assert( length(lambdas) == num_clients);

end