close all
clear variables

rng(0,'twister');
a = 0;
b = 5;
n = 100;
r = (b-a).*rand(n,1) + a;

t=0;
tp=0;
tSpan=100;
tInterval=0.1;
toutput=[];

for i=1:n
    t
    t=t+r(i);     % Update the simulation timer
    
    if t>tSpan
        % End the simulation
        
        t=tSpan;
    end
    tp=tp+r(i);   % Update the time interval for the output
    
    if tp>tInterval

        tp=0;   % reset the timer for the output
    end
end