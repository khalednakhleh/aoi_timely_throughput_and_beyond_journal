


lambda = 0.5; % lambda in my case


%lambda=1/arrivals; % arrival rate per second (1 minute per packet)

T=10; % simulation time in timeslots

delta=1; % simulation step size in second

N=10; % same as timeslots

event=zeros(1,N); % initialize counters to zeros

R=rand(size(event)) % generate a random array with size as "event"

event(R<lambda*delta)=1; % event occur if R < lambda*delta

inds=find(event==1) % getting indices of arrivial

int_times=diff(inds)*delta; % interarrival times in seconds



length(inds)
%edges=0:10:400; % define histogram bin

%count=histc(int_times,edges);







