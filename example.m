

t = 1;
T = 100000;
lambda = 0.2;
arrTime = [];
while true 
  t = t - log(rand)/lambda;
  if t <= T
    arrTime(end+1) = t;
  else
    break
  end
end 


ceil(arrTime);


length(arrTime)
T/(length(arrTime))