% This script has nothing to do with Assignment 2 it is purely for me to
% figure out random things without breaking the main functions for
% Assignment 2 - TL










[~,z] = ivpSolver(0,[0,0,0,0],0.01,4600,0.06);

%% Method 1
tic
% Find the time position for when x = xb
% Assumes that the position increases linearly from 0
n=1;
tg = [0];
while tg(1) == 0 
    if floor(z(1,n)) == 800
        tg(1) = n;
    end 
    n = n + 1;
end
toc



%% Method 2
% Checks all values via a loop
tic

for n=1:numel(z(1,:))
    if floor(z(1,n)) == 800
        tg(1) = n;
    end
end


toc


%% Method 3
% This is straightup better than the previous 2
tic

n=800;
[val,idx]=min(abs(z(1,:)-n));
% minVal=z(1,idx)

toc

%% Checking if deg or rad is more efficient, spoiler, the second one always wins probably because of the prediction algorithm or something

tic
sin(pi/2);
toc


tic
sind(90);
toc

%% Preallocating 
tend = 5000;
dt = 0.01;
tic
% t = zeros(1,tend/dt + 1);
t(1) = 0;
n=1;
while t(n) <= tend
    % Increment the time vector by one time step
    t(n+1) = t(n) + dt;
    % FROM MY TESTING PREALLOCATING DOES NOT MAKE IT FASTER IDK WHY????
    n = n+1;
end

toc






