function mc = createmc(P, G)

TRANS = [1-P, P ;
         G, 1-G];

mc =  dtmc(TRANS, 'StateNames', ["ON", "OFF"]);
graphplot(mc,'ColorEdges',true)
end
