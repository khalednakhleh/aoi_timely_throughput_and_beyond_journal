% author: Khaled Nakhleh
% optimizer for the Gilbert-Elliot channel model for the over-loaded
% regime


function [MS, varChannel, mu, clientVars, weights] = optimize_heavy_traffic_with_added_delay(num_clients, p, q, periods)

% lambdas are the arrival rates
kIterator = 100;

assert( length(p) == num_clients);
assert( length(q) == num_clients);


%%%%%%%%%%%%%%%%%%% optimization %%%%%%%%%%%%%%%%%%%%%%%
MS = CalculateMeans(num_clients, p, q); % ms for the entire set
varChannel = calculateChannelVar(num_clients, p,q, kIterator);

prob = optimproblem('ObjectiveSense', 'minimize');

vars = optimvar('vars', 1, num_clients,'Type','continuous','LowerBound',0,'UpperBound', 100000);

weight_min_range = 0.000000000001
weight_max_range = 0.00000000001
weights = (weight_max_range-weight_min_range).*rand(1, num_clients) + weight_min_range  % pick random integers in range for the number of clients we have.
%weights = [0.000001, 0.000001, 0.0000001, 0.000001, 0.0000001]


objectiveFunction = sum((3 .* weights .* (sqrt(vars).^(4/3)))./((4 .* weights).^(2/3)));

prob.Objective = objectiveFunction;

prob.Constraints.varConstraint = sum(sqrt(vars)) == sqrt(varChannel);


x0.vars = rand(size(vars));

solution = solve(prob, x0)

for i = 1:num_clients
    fprintf("client %d variance: %.14f\n",i, solution.vars(i))
end

fprintf("channel mean: %.16f\n", MS)
fprintf("channel variance: %.16f\n", varChannel)

clientVars = solution.vars;

mu = 1./periods;

end

%% functions 
function MS = CalculateMeans(numClients, p, q)

pOverQ = [];


for i = 1 : numClients
    pOverQ(i) = p(i) / (p(i) + q(i));
end

pOverQProd = prod(pOverQ);
MS = 1 - pOverQProd;



end


function varChannel = calculateChannelVar(numClients, p, q, kIterator)

for i = 1 : numClients
    pOverQ(i) = p(i) / (p(i) + q(i));
end

G = zeros(numClients, kIterator); % 

for i = 1 : numClients
for k = 1 : kIterator
 G(i,k) = pOverQ(i) + (q(i) / (p(i) + q(i)))*(1 - p(i) - q(i))^k;
end
end 


GBeforeSum = (prod(G,1) - prod(pOverQ)).*prod(pOverQ);
%sum(GBeforeSum)
varChannel = 2*sum(GBeforeSum) + prod(pOverQ) - (prod(pOverQ))^2;



end 


