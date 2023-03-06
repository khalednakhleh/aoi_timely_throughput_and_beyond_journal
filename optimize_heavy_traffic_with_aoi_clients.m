% author: Khaled Nakhleh
% optimizer for the Gilbert-Elliot channel model for the over-loaded
% regime


function [MS, varChannel, mu, clientVars, weights] = optimize_heavy_traffic_with_aoi_clients(num_clients, p, q, periods, delays, lambdas)

% lambdas are the arrival rates
kIterator = 100;

assert( length(p) == num_clients);
assert( length(q) == num_clients);


%%%%%%%%%%%%%%%%%%% optimization %%%%%%%%%%%%%%%%%%%%%%%
MS = CalculateMeans(num_clients, p, q); % ms for the entire set
varChannel = calculateChannelVar(num_clients, p,q, kIterator);

prob = optimproblem('ObjectiveSense', 'minimize');

vars = optimvar('vars', 1, num_clients,'Type','continuous','LowerBound',0,'UpperBound', 100000);
aoi_means = optimvar('aoi_means', 1, floor(num_clients/2), 'Type', 'continuous', 'LowerBound',0, 'UpperBound', 100000);


aoi_clients_num = floor(num_clients/2); % will be 3 for the case of 6 clients. 5 for 10 total clients, and 10 for 20 total clients.

realtime_clients_num = num_clients - aoi_clients_num;

assert(realtime_clients_num + aoi_clients_num == num_clients);
weights = ones(1,num_clients); % not used here.


realtime_means = 1./periods;
realtime_means = realtime_means(1:realtime_clients_num);


% AoI objective function according to equation 14.
obj_func_aoi = sum(0.5.*(vars(1:aoi_clients_num)./(aoi_means.^2) + (1./aoi_means)) + (1./lambdas(1:aoi_clients_num)) - 0.5);
obj_func_throughput = sum((delays(realtime_clients_num+1:num_clients).^2).*(vars(realtime_clients_num+1:num_clients) ./ (2.*delays(realtime_clients_num+1:num_clients))));

objectiveFunction = obj_func_aoi + obj_func_throughput;
prob.Objective = objectiveFunction;

prob.Constraints.varConstraint = sum(sqrt(vars)) == sqrt(varChannel);
prob.Constraints.aoimeanConstraint = sum(aoi_means) == (MS - sum(realtime_means));

x0.vars = rand(size(vars));
x0.aoi_means = rand(size(aoi_means));

solution = solve(prob, x0)


MS 

for i = 1:num_clients
    fprintf("client %d variance: %.14f\n",i, solution.vars(i))
end

fprintf("channel mean: %.16f\n", MS)
fprintf("channel variance: %.16f\n", varChannel)

clientVars = solution.vars;
aoi_means = solution.aoi_means;

mu = [aoi_means realtime_means]

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



