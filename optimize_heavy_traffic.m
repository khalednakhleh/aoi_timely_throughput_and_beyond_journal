% author: Khaled Nakhleh
% optimizer for the Gilbert-Elliot channel model for the over-loaded
% regime


function [MS, varChannel, mu, clientVars, weights] = optimize_heavy_traffic(num_clients, p, q, periods, delays)

% lambdas are the arrival rates
kIterator = 100;

assert( length(p) == num_clients);
assert( length(q) == num_clients);
assert(all(periods == periods(1))); % check that we have the same period value for all clients. 

%%%%%%%%%%%%%%%%%%% optimization %%%%%%%%%%%%%%%%%%%%%%%
MS = CalculateMeans(num_clients, p, q); % ms for the entire set
varChannel = calculateChannelVar(num_clients, p,q, kIterator);

prob = optimproblem('ObjectiveSense', 'minimize');

vars = optimvar('vars', 1, num_clients,'Type','continuous','LowerBound',0,'UpperBound', 100000);

objectiveFunction = sum((delays.^2).*(vars ./ (2.*delays))); % setting the weights as delays^2.

prob.Objective = objectiveFunction;


prob.Constraints.varConstraint = sum(sqrt(vars)) == sqrt(varChannel);

weights = ones(1,num_clients);

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



