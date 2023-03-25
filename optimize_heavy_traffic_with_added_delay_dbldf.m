% author: Khaled Nakhleh
% optimizer for the Gilbert-Elliot channel model for the over-loaded
% regime


function [MS, varChannel, mu,clientVars, weights, delays] = optimize_heavy_traffic_with_added_delay_dbldf(num_clients, p, q, periods, delay_tot)

% lambdas are the arrival rates
kIterator = 100;

assert(length(p) == num_clients);
assert(length(q) == num_clients);


%%%%%%%%%%%%%%%%%%% optimization %%%%%%%%%%%%%%%%%%%%%%%
MS = CalculateMeans(num_clients, p, q); % ms for the entire set
varChannel = calculateChannelVar(num_clients, p,q, kIterator);


weights =   1.0e-07 *[   0.311453156800177,   0.040669005015323,   0.012208295050929,   0.005177082691539,   0.002656116196590,   0.001537908336630,   0.000985724711660,   0.000661837336185,   0.000464858011146, 0.000338833445834,   0.000254534915920,   0.000196035627508,   0.000154175731241,   0.000123435653474,   0.000100354817032,   0.000082688617181,   0.000068937779696,   0.000058074883349,  0.000049379801791,   0.000042337598140]

fprintf("channel mean: %.16f\n", MS)
fprintf("channel variance: %.16f\n", varChannel)


mu = 1./periods;

clientVars = zeros(1,num_clients)

delays = repelem(floor(delay_tot/num_clients), num_clients)

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


