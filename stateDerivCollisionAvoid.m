function dz = stateDerivCollisionAvoid(~,z,maxDepth)
% Calculate the state derivative for an underwater glider system
% 
%     DZ = stateDeriv(T,Z) computes the derivative DZ = [V; A] of the 
%     state vector Z = [X; V], where X is displacement, V is velocity,
%     and A is acceleration. maxDepths is the maximum allowed depth that
%     the glider is allowed to reach.

% Velocity angle
vtheta = atand(z(4)/z(2));
if isnan(vtheta) == true
    vtheta = -90;
end

%% Conditions
M = 3.9;                                                        % Mass
Rhow = 1000;                                                    % Density of water
S = (pi * 0.1^2) / 4;                                           % SA when viewed from the front
Cd = 0.78;                                                      % Coefficient of drag
D = Cd * (0.5 * Rhow * (z(2).^2 + z(4).^2) * S);                % Drag
V = 3.9;                                                        % Total volume in litres
 dVmax = 0.06;                                                   % Max bladder volume in litres
 
% Upperbound must == 0 when using a lowerbound that is not a constant
% unless the function is adjusted so that upperbound > lowerbound at all
% points
upperBound = -10;
% Checks that the upperBound is not in the air. Useful if you want to enter
% a strange ceiling 
if upperBound > 0
    upperbound = 0;
end
 lowerBound = maxDepth;
% lowerBound = (0.001*z(1)-7)^2-50;
% lowerBound = -12*sin(z(1)/40)-z(1)/6 - 40 + (z(1)/110)^2;

%% Collision avoidance with the ceiling or floor
descend = false;

if  z(4) <= 0 && z(3) >= upperBound
    descend = true;
%     disp('1')
elseif z(4) <= 0 && z(3) < upperBound && z(3) > lowerBound
    descend = true;
%     disp('2')
elseif z(4) <= 0 && z(3) <= lowerBound
    descend = false;
%     disp('3')
elseif z(4) >= 0 && z(3) < upperBound && z(3) > lowerBound
    descend = false;
%     disp('4')
elseif z(4) >= 0 && z(3) >= upperBound
    descend = true;
%     disp('5')
end

if descend == true
    currentV = V - dVmax;
else
    currentV = V + dVmax;
end



g = 9.81;                                                       % Acceleration due to gravity
W = M * g;                                                      % Weight
Fu = Rhow * g * currentV/1000;                                  % Upthrust
Cl = 2.76;                                                        % Varies between PM 2.76
L = sign(z(4)) * 0.5 * abs(Cl) * Rhow * S * (z(2).^2 + z(4).^2);     % Lift



%% Derivatives
dz1 = z(2);                                         % x
dz3 = z(4);                                         % y
dz2 = (L/M)*sind(vtheta) - (D/M)*cosd(vtheta);        % dx
dz4 = (Fu - W - D*sind(vtheta) - L*cosd(vtheta))/M;   % dy

dz = [dz1; dz2; dz3; dz4];