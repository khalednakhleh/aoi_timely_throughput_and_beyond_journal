% author: Khaled Nakhleh
% optimizer for the Gilbert-Elliot channel model for the over-loaded
% regime


function [MS, varChannel, mu, clientVars, weights, delays] = optimize_heavy_traffic_with_added_delay_vwd(num_clients, p, q, periods, delays)

% lambdas are the arrival rates
kIterator = 100;

assert(length(p) == num_clients);
assert(length(q) == num_clients);


%%%%%%%%%%%%%%%%%%% optimization %%%%%%%%%%%%%%%%%%%%%%%
MS = CalculateMeans(num_clients, p, q); % ms for the entire set
varChannel = calculateChannelVar(num_clients, p,q, kIterator);

prob = optimproblem('ObjectiveSense', 'minimize');

vars = optimvar('vars', 1, num_clients,'Type','continuous','LowerBound',0,'UpperBound', 100000);


weight_values = 4.*delays.^3;
weights = vars./weight_values;


objectiveFunction = sum((3 .* (weights).^(1/3) .* (sqrt(vars).^(4/3)))./((4).^(2/3)))

prob.Objective = objectiveFunction;

prob.Constraints.varConstraint = sum(sqrt(vars)) == sqrt(varChannel);


x0.vars = zeros(size(vars));

solution = solve(prob, x0)

for i = 1:num_clients
    fprintf("client %d variance: %.14f\n",i, solution.vars(i))
end

fprintf("channel mean: %.16f\n", MS)
fprintf("channel variance: %.16f\n", varChannel)

clientVars = solution.vars;

mu = 1./periods;


weights = (solution.vars)./weight_values

delays = floor((sqrt(clientVars).^(2/3)) ./ (4.*weights).^(1/3))

delay_tot = sum(delays)

delays_wld = floor((sqrt(clientVars) .* delay_tot)./(sqrt(varChannel)))

delay_dbldf = floor(repelem((delay_tot / num_clients), num_clients))

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


