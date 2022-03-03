function [t,z] = bvpSolverCollisionAvoid(xb,yb,dt,tend,emax)
% bvpSolver    Solve a boundary value problem (BVP) and plot the result
% 
%     [T,Z] = bvpSolverCollisionAvoid(Xb,Zb,Dt,TEnd,EMax) computes the BVP
%     solution using the shooting method. The shooting method starts off by using the
%     ivpSolverCollisionAvoid to solve the problem for two initial guesses and then by
%     determining the boundary value error for both so that they can be
%     compared. From the error a third guess can be generated and solved so
%     that its error can be determined. This is then looped until the error
%     is low enough so that it is acceptable. This varies maximum depth
%     that the glider is allowed to reach instead of dV.
%     bvpSolverCollisionAvoid(400,-20,0.1,6400,0.1);

close all

if xb < 0 || yb > 0 || tend < 0 || emax > 1
    warning('Please enter reasonable values for your conditions')
    return
end


%% Inital guesses
maxDepth = [-60,-30];

% Guess 1
[~,z] = ivpSolverCollisionAvoid(0,[0,0,0,0],dt,tend,maxDepth(1));

% Find the time position for when x = xb
[~,pos(1)]=min(abs(z(1,:)-xb));

% Error 1
error(1) = z(3,pos(1)) - yb;

% Guess 2
[~,z] = ivpSolverCollisionAvoid(0,[0,0,0,0],dt,tend,maxDepth(2));

% Find the time position for when x = xb
[~,pos(2)]=min(abs(z(1,:)-xb));

% Error 2
error(2) = z(3,pos(2)) - yb; 


% dVmax(3) = dVmax(2) - error(2)*((dVmax(2)-dVmax(1))/(error(2)-error(1)));

%% Guess 3 and onwards
m = 2;
while min(abs(error)) > emax
    
    % Calculates the next value of dVmax
    maxDepth(m+1) = maxDepth(m) - error(m)*((maxDepth(m)-maxDepth(m-1))/(error(m)-error(m-1)));
    
    % Passes the guess dVmax into ipvSolver
    [~,z] = ivpSolverCollisionAvoid(0,[0,0,0,0],dt,tend,maxDepth(m+1));
    
    % Find the time position for when x = xb
    [~,pos(m+1)]=min(abs(z(1,:)-xb));
    
    % Next error
    error(m+1) = z(3,pos(m+1)) - yb;
    
    % Increment the counter by 1
    m = m + 1;
%     pause(2)
end
hold on
plot(z(1,:),z(3,:),'LineWidth',3)

xline(xb);
yline(yb);
hold off
disp(maxDepth)
disp(error)


