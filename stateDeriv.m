function dz = stateDeriv(t,z,dVmax)
% Calculate the state derivative for an underwater glider system
% 
%     DZ = stateDeriv(T,Z,dVmax) computes the derivative DZ = [V; A] of the 
%     state vector Z = [X; V], where X is displacement, V is velocity,
%     and A is acceleration. dVmax is the maximum volume of the bladder at
%     any given time, this determines the trajectory that the underwater
%     glider takes. For use without moments z should have 4 elements x, dx,
%     y, dy. For use with moments z should have 6 elements x, dx, y, dy,
%     theta, dtheta.

%% Toggleables
% Include underwater currents?
currents = false;

% More realistic bouyancy engine? 
realisticBoyuancy = true;

%% Underwater currents
current = 0;

if currents == true
    % Dont use a negative current, only go with the current.
    % Constant current
     current = 0.1; % m/s
    
    % Varies with depth linearly
    % current = -0.0018*(-z(3)); % m/s
    
    % current increases to the power of 2 with depth
    % current = -0.0007*(z(3)^2); % m/s
end

%% Velocity angle
vtheta = atand(z(4)/(z(2)+current));

if isnan(vtheta) == true
    vtheta = -90;
end

%% Coefficients of lift and drag
% If z has 6 elements in it, it calculates advanced Cd and Cl values. If
% not it uses constant values of Cd and Cl
if length(z) == 6
    % Angle of Attack
    AoA = diff([vtheta,z(5)]);
    
    % Uses the hydrodynamics function to produce more realistic coefficients of drag and lift values
    [Cd, Cl]=hydrodynamics(deg2rad(AoA));
else
    % Coefficient of drag
    Cd = 0.78;
    
    % Coefficient of lift
    Cl = 2.76;
end

%% Conditions
% Mass
M = 3.9;

% Density of water
Rhow = 1000;

% Surface area when viewed from the front
S = (pi * 0.1^2) / 4;

% Drag
% D = Cd * (0.5 * Rhow * (z(2).^2 + z(4).^2) * S);
% Drag but with currents accounted for 
D = Cd * (0.5 * Rhow * ((z(2)+current)^2 + z(4)^2) * S);

% Lift
% L = sign(z(4)) * 0.5 * abs(Cl) * Rhow * S * (z(2)^2 + z(4)^2);
% Lift but with currents
L = sign(z(4)) * 0.5 * abs(Cl) * Rhow * S * ((z(2)+current)^2 + z(4)^2);

% Water resistance constant, used for dz6 as it slows down the rotation of the
% glider
Wr = 0.1;

% Total volume (litres)
V = 3.9;   

% Max bladder volume in L
% dVmax = 0.06;

% Finds current volume
if realisticBoyuancy == true
    % More realistic
    currentV = V + squareGen(t,dVmax);
else
    % Less realistic
    currentV = V + squareGenInstant(t,dVmax);
end

% g
g = 9.81;

% Weight
W = M * g;

% Upthrust
Fu = Rhow * g * currentV/1000;

%% Derivatives
dz1 = z(2);                                         % dx
dz3 = z(4);                                         % dy
dz2 = (L/M)*sind(vtheta) - (D/M)*cosd(vtheta);        % ddx
dz4 = (Fu - W - D*sind(vtheta) - L*cosd(vtheta))/M;   % ddy

% Only calculates dz5 and dz6 if z contains 6 elements
if length(z) == 6
    % Calculates the +- 5mm for the moment exerted by the bouyancy engine
    bladderMoment = -((currentV - V)/0.06)*5;
    
    dz5 = z(6);                                     % dtheta
    dz6 = (W*(sqrt(100^2+37.5^2)*cosd(z(5)+atand(37.5/100))) ... % ddtheta
        + 150*L*cosd(AoA) - 150*D*sind(AoA) ...
        - (100+bladderMoment)*Fu*cosd(z(5)))/(1000*0.25) - (Wr*z(6))/0.25;

    dz = [dz1; dz2; dz3; dz4; dz5; dz6];
else
    dz = [dz1; dz2; dz3; dz4];
end
