function [t,z] = ivpSolverCollisionAvoid(t0,z0,dt,tend,maxDepth)
% ivpSolver    Solve an initial value problem (IVP) and plot the result
% 
%     [T,Z] = ivpSolverCollisionAvoid(T0,Z0,DT,TEnd,maxDepth) computes the 
%     IVP solution using a step size DT, beginning at time T0 and initial 
%     state Z0 and ending at time TEND. The solution is output as a time 
%     vector T and a matrix of state vectors Z.
%     ivpSolverCollisionAvoid(0,[0,0,0,0],0.1,2400,-50);
%     Any equation to model maxDepth can be used, see stateDerivCollisionAvoid
%     for examples

% Set initial conditions
t(1) = t0;
z(:,1) = z0;
% dVmax = 0.06; 

% Continue stepping until the end time is exceeded
n=1;
while t(n) <= tend
    % Increment the time vector by one time step
    t(n+1) = t(n) + dt;
    
    % Apply RK4 method for one time step
    z(:,n+1) = stepRungeKuttaCollisionAvoid(t(n), z(:,n), dt,maxDepth);
    
    n = n+1;
end

if 1
hold on
plot(z(1,:),z(3,:))
hold off
% pause(1)
end
