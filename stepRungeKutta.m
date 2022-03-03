function znext = stepRungeKutta(t,z,dt,dVmax)
% stepRungeKutta    Compute one step using the RK4 method
% 
%     ZNEXT = stepRungeKutta(T,Z,DT,DVmax) computes the state vector ZNEXT at the next
%     time step T+DT. DVmax is passed through to stateDeriv.

A = dt * stateDeriv(t, z,dVmax);

B = dt * stateDeriv(t + dt/2, z + A/2,dVmax);

C = dt * stateDeriv(t + dt/2, z + B/2,dVmax);

D = dt * stateDeriv(t + dt, z + C,dVmax);

% Calculate the next state vector from the previous one using the Runge-Kutta
% update equation
znext = z + (A + 2*B + 2*C + D)/6;
