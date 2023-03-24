% author: Khaled Nakhleh
% optimizer for the Gilbert-Elliot channel model for the over-loaded
% regime


function [MS, varChannel, mu, clientVars, weights, delays] = optimize_heavy_traffic_with_added_delay_wld(num_clients, p, q, periods)

% lambdas are the arrival rates
kIterator = 100;

assert(length(p) == num_clients);
assert(length(q) == num_clients);


%%%%%%%%%%%%%%%%%%% optimization %%%%%%%%%%%%%%%%%%%%%%%
MS = CalculateMeans(num_clients, p, q); % ms for the entire set
varChannel = calculateChannelVar(num_clients, p,q, kIterator);

prob = optimproblem('ObjectiveSense', 'minimize');

vars = optimvar('vars', 1, num_clients,'Type','continuous','LowerBound',0,'UpperBound', 100000);

delay_tot = 146
weights =  1.0e-06 *  [0.199252750702208,   0.099095218915311,   0.065945182018015,   0.049414448405438,   0.039510253731204];

objectiveFunction = sum( (sqrt(varChannel).^3 .*sqrt(vars) + 2 .* weights .* vars .* delay_tot.^3) ./  (2 .* delay_tot .* varChannel) );

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



weights


delays = floor((sqrt(clientVars) .* delay_tot)./(sqrt(varChannel)))

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


