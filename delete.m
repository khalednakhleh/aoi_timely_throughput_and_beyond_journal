


lambda = 1;


arrTime = [];
t = 1;
T = 500000;
while true 
  t = t - log(rand)/lambda;
  if t <= T
    arrTime(end+1) = t;
  else
    break
  end
end 


arrTime = ceil(arrTime);

length(arrTime)/T







