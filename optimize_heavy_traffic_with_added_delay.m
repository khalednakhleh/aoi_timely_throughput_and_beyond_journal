% author: Khaled Nakhleh
% optimizer for the Gilbert-Elliot channel model for the over-loaded
% regime




function [MS, varChannel, mu, clientVars, weights, delays] = optimize_heavy_traffic_with_added_delay(num_clients, p, q, periods)

% lambdas are the arrival rates
kIterator = 100;

assert(length(p) == num_clients);
assert(length(q) == num_clients);

%%%%%%%%%%%%%%%%%%% optimization %%%%%%%%%%%%%%%%%%%%%%%
MS = CalculateMeans(num_clients, p, q); % ms for the entire set
varChannel = calculateChannelVar(num_clients, p, q, kIterator);

vars0 = rand(num_clients, 1);
delays0 = rand(num_clients, 1);

weights = randi([10 100], 1, num_clients);

% objective function
objFun = @(x) sum((x(1:num_clients) ./ (2.*x(num_clients+1:end))) + (weights.*(x(num_clients+1:end).^2)));

% constraint function
nonlcon = @(x) deal(sum(sqrt(x(1:num_clients))) - sqrt(varChannel), []);

% variable bounds
lb = [zeros(num_clients, 1); ones(num_clients, 1)];
ub = [100000*ones(num_clients, 1); 100000*ones(num_clients, 1)];

options = optimoptions('surrogateopt','MaxFunctionEvaluations',200);

% solve optimization problem
[x, fval] = surrogateopt(objFun);

clientVars = x(1:num_clients);
delays = x(num_clients+1:end);

for i = 1:num_clients
    fprintf("client %d variance: %.14f\n",i, clientVars(i))
    fprintf("delays: %.14f\n", delays(i))
end

fprintf("channel mean: %.16f\n", MS)
fprintf("channel variance: %.16f\n", varChannel)

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



