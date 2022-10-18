% author: Khaled Nakhleh
% optimizer for the Gilbert-Elliot channel model for the under-loaded
% regime


function [MS, varChannel, means, clientVars] = optimizer_under_loaded(num_clients, p, q, lambdas, delays)

% lambdas are the arrival rates
kIterator = 100;
epsilon = 0.00001;


assert( length(p) == num_clients);
assert( length(q) == num_clients);

a = 1:1:num_clients;

values = partitions(a);
C = {};

for i = 1 : length(values)
    for j = 1 : length(values{i})
        C(end + 1) = values{i}(j);
    end
end

B = cellfun(@(v)sort(char(v)),C,'uni',0);
C = cellfun(@double,unique(B),'uni',0);


meanConstraints = optimconstr(length(C) - 1, 1);


%%%%%%%%%%%%%%%%%%% optimization %%%%%%%%%%%%%%%%%%%%%%%
MS = CalculateMeans(num_clients, p, q); % ms for the entire set
varChannel = calculateChannelVar(num_clients, p,q, kIterator);

prob = optimproblem('ObjectiveSense', 'minimize');

mu = optimvar('mu', 1, num_clients,'Type','continuous','LowerBound',0,'UpperBound', MS);
vars = optimvar('vars', 1, num_clients,'Type','continuous','LowerBound',0,'UpperBound', 100000);

objectiveFunction = sum(exp((-2.*(mu - lambdas)./vars).*delays));


prob.Objective = objectiveFunction


for i = 1 : length(C)
        
        if length((C{i})) == num_clients
            continue
        end
        a(C{i});
        pVals = p(a(C{i}));
        qVals = q(a(C{i}));
        ms = CalculateMeans(length(a(C{i})), pVals, qVals);
        meanConstraints(i) =  sum(mu(a(C{i}))) <= (ms - epsilon);
        meanConstraints(i);
        %fprintf("--------------------")
end



prob.Constraints.meanMainSetConstraint = sum(mu) == MS;
prob.Constraints.varConstraint = sum(sqrt(vars)) >= sqrt(varChannel);
prob.Constraints.means = meanConstraints;


x0.mu = rand(size(mu));
x0.vars = rand(size(vars));

solution = solve(prob, x0)

for i = 1:num_clients
    fprintf("client %d mean: %.14f\n",i, solution.mu(i))
    fprintf("client %d variance: %.14f\n",i, solution.vars(i))
end

fprintf("channel mean: %.16f\n", MS)
fprintf("channel variance: %.16f\n", varChannel)

means = solution.mu;
clientVars = solution.vars;
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



