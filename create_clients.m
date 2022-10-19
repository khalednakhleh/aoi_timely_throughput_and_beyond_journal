



function clients = create_clients(clients, betas, delays, lambdas, p, q, num_clients)



for x = 1 : num_clients

    clients(x).idx = x;
    clients(x).beta = betas(x);
    clients(x).delay = delays(x);
    clients(x).lambda = lambdas(x);
    clients(x).p = p(x);
    clients(x).q = q(x); 
    clients(x).packet_deadline_array = []; 
    clients(x).mc = createmc(p(x), q(x));
end


end