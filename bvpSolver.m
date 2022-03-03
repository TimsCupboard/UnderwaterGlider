function z = bvpSolver(xb,yb,dt,tend,emax)
% bvpSolver    Solve a boundary value problem (BVP) and plot the result
% 
%     Z = bvpSolver(Xb,Yb,Dt,TEnd,EMax) computes the BVP solution using the
%     shooting method. The shooting method starts off by using the
%     ivpSolver to solve the problem for two initial guesses and then by
%     determining the boundary value error for both so that they can be 
%     compared. From the error a third guess can be generated and solved so
%     that its error can be determined. This is then looped until the error
%     is low enough so that it is acceptable
%     bvpSolver(400,-20,0.1,4400,0.1);
%     See bvpSolverCollisionAvoid for the same but it can do collision
%     avoidance.

%% Toggleables
% Include moments for advanced hydrodynamics?
moments = false;

%% Prerequisites
close all

if xb < 0 || yb > 0 || tend < 0 || emax > 1
    warning('Please enter reasonable values for your conditions')
    return
end

if moments == true
    initZ = [0,0,0,0,-90,0];
else
    initZ = [0,0,0,0];
end

%% Inital guess
% 0.06 and 0.03 works for instantaneous dV change, 0.06 and 0.04 for linear
% dV change
dVmax = [0.06,0.04];

% Guess 1
[~,z] = ivpSolver(0,initZ,dt,tend,dVmax(1));

% Find the time position for when x = xb
[~,pos(1)]=min(abs(z(1,:)-xb));

% Error 1
error(1) = z(3,pos(1)) - yb;

% Guess 2
[~,z] = ivpSolver(0,initZ,dt,tend,dVmax(2));

% Find the time position for when x = xb
[~,pos(2)]=min(abs(z(1,:)-xb));

% Error 2
error(2) = z(3,pos(2)) - yb; 

%% Guess 3 and onwards
m = 2;

% This breaks the loop if it exceeds the timeout limit
internalTimer = tic;
% Increase the timeout limit if a solution is not found
timeout = 25;
while min(abs(error)) > emax && toc(internalTimer)<timeout
    
    % Calculates the next value of dVmax
    dVmax(m+1) = dVmax(m) - error(m)*((dVmax(m)-dVmax(m-1))/(error(m)-error(m-1)));
    
    % Passes the guess dVmax into ipvSolver
    [~,z] = ivpSolver(0,initZ,dt,tend,dVmax(m+1));
    
    % Find the time position for when x = xb
    [~,pos(m+1)]=min(abs(z(1,:)-xb));
    
    % Next error
    error(m+1) = z(3,pos(m+1)) - yb;
    
    % Increment the counter by 1
    m = m + 1;
    % pause(2)
   
end

%% End results
    hold on
    plot(z(1,:),z(3,:),'LineWidth',3)
    xline(xb);
    yline(yb);
    ylabel('Depth (m)')
    xlabel('Distance (m)')
    hold off
    disp('Tried values of dV')
    disp(dVmax)
    disp('Error for each value of dV')
    disp(error)
if dVmax(end) <= 0.06 && dVmax(end) >= 0 && abs(error(end)) < emax && z(1,end) >= xb
    successMsg = ['A delta V of ', num2str(dVmax(end),'%4.4f'),'(L) was found to cross the boundary conditions with an error of ',num2str(error(end),'%4.4f'),'.'];
    disp(successMsg)
else
    if abs(error(end)) > emax
        fprintf(2,'Warning!!! With a linear approximation for the shooting method it is not possible to obtain a value of dV which satifies the boundary conditions\n')
    elseif (z(1,end)<xb)
        doesNotReachxb = ['Warning!!! The solution does not reach x = ', num2str(xb),' in time! Please increase TEnd!\n'];
        fprintf(2,doesNotReachxb)
    else
        fprintf(2,'Warning!!! A solution was found but it may not be useful, please check constraints\n')
    end
end

