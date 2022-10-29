

clc, clear all



P = 0.128

G = 0.435

time = 500000


TRANS = [1-P, P ;
         G, 1-G];

mc =  dtmc(TRANS, 'StateNames', ["ON", "OFF"]);


walk_in = simulate(mc, time);

walk_in(walk_in == 2) = 0;
walk_in = walk_in(1:time);


mc_2 =  dtmc(TRANS, 'StateNames', ["ON", "OFF"]);


walk_in_two = simulate(mc_2, time);

walk_in_two(walk_in_two == 2) = 0;
walk_in_two = walk_in_two(1:time);




other_walks = zeros(1, time);




%rng(seed)

mc =  dtmc(TRANS, 'StateNames', ["ON", "OFF"]);

for x = 1 : time
    val = simulate(mc,1);
    other_walks(x) = val(2);
    
end

other_walks(other_walks == 2) = 0;

walk_in_one = sum(walk_in == 1)
walk_in_zero = sum(walk_in == 0)

other_walks_one = sum(other_walks == 1)
other_walks_zero = sum(other_walks == 0)


walk_in_two_one = sum(walk_in_two == 1)

walk_in_two_zero = sum(walk_in_two == 0)


%walk_in = walk_in(end);


%graphplot(mc,'ColorEdges',true);

