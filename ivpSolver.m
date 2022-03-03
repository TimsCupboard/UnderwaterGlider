function [t,z] = ivpSolver(t0,z0,dt,tend,dVmax)
% ivpSolver    Solve an initial value problem (IVP) and plot the result
% 
%     [T,Z] = ivpSolver(T0,Z0,DT,TEnd,DVmax) computes the IVP solution using a step 
%     size DT, beginning at time T0 and initial state Z0 and ending at time 
%     TEND. The solution is output as a time vector T and a matrix of state 
%     vectors Z.
%     Example without moments
%     ivpSolver(0,[0,0,0,0],0.1,4400,0.06);
%
%     Example with moments considered
%     ivpSolver(0,[0,0,0,0,-90,0],0.1,4400,0.06);

%% Toggleables
% Plot intermediate steps?
plotSteps = true;

%% ivpSolver script

if xor(length(z0) ~= 4,length(z0) ~= 6) == 0 
    fprintf(2,'Please check the initial conditions.\n')
    return
end
% Set initial conditions
% Preallocating the size of t. **NOTE** I could not see any real gains from
% preallocation, in fact, during testing preallocating made the overall
% script slower??
% t = zeros(1,tend/dt + 1);

t(1) = t0;
z(:,1) = z0;
% dVmax = 0.06; 

% Continue stepping until the end time is exceeded

n=1;
while t(n) <= tend
    % Increment the time vector by one time step
    t(n+1) = t(n) + dt;
    
    % Apply RK4 method for one time step (stepEuler can also be used ...
    % but why?)
    z(:,n+1) = stepRungeKutta(t(n), z(:,n), dt,dVmax);
    
    n = n+1;
end

% Toggles if the intermediate steps should be plotted or not
if plotSteps == true
hold on
plot(z(1,:),z(3,:))
hold off
% pause(1)
end
