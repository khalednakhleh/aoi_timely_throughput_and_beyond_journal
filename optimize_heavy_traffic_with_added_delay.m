% author: Khaled Nakhleh
% optimizer for the Gilbert-Elliot channel model for the over-loaded
% regime


function [MS, varChannel, mu, clientVars, weights, delays] = optimize_heavy_traffic_with_added_delay(num_clients, p, q, periods)

% lambdas are the arrival rates
kIterator = 100;

assert( length(p) == num_clients);
assert( length(q) == num_clients);

%%%%%%%%%%%%%%%%%%% optimization %%%%%%%%%%%%%%%%%%%%%%%
MS = CalculateMeans(num_clients, p, q); % ms for the entire set
varChannel = calculateChannelVar(num_clients, p, q, kIterator);

weights = randi([100 1000], 1, num_clients); % pick random integers in range for the number of clients we have.


% Define the objective function
objfun = @(x) objectivefunction(x, num_clients, weights); % The objective function is the sum of the first 5 variables


% Define the bounds for the variables
lb = [zeros(1,5) 10*ones(1,5)]; % Lower bounds
ub = [100000*ones(1,5) 100000*ones(1,5)]; % Upper bounds

% Define the integer constraint for the last 5 variables
intcon = [6 7 8 9 10];



Aeq = [ones(1,num_clients), zeros(1, num_clients)];
beq = sqrt(varChannel);

options = optimoptions('surrogateopt','Display','none');

% Call the surrogateopt function
[x,fval] = surrogateopt(objfun,lb,ub,intcon, [], [], Aeq, beq, options);

% Display the results
disp(['Optimal solution: ' num2str(x)])
disp(['Optimal objective value: ' num2str(fval)])

for i = 1:num_clients
    fprintf("client %d variance: %.14f\n", i, x(i))
end

fprintf("channel mean: %.16f\n", MS)
fprintf("channel variance: %.16f\n", varChannel)

clientVars = x(1:num_clients);
delays = x(num_clients+1:end);

mu = 1./periods;

end


%% functions 


function [f] = objectivefunction(x, num_clients, weights)
    f = sum((x(1:num_clients).^2 ./ (2.*x(num_clients+1:end))) + (weights.*(x(num_clients+1:end).^2)));
end


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



