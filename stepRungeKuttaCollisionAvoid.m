function znext = stepRungeKuttaCollisionAvoid(t,z,dt,maxDepth)
% stepRungeKuttaCollisionAvoid    Compute one step using the RK4 method
% 
%     ZNEXT = stepRungeKutta(T,Z,DT,maxDepth) computes the state vector ZNEXT at the next
%     time step T+DT. maxDepth is passed through.


A = dt * stateDerivCollisionAvoid(t, z,maxDepth);

B = dt * stateDerivCollisionAvoid(t + dt/2, z + A/2,maxDepth);

C = dt * stateDerivCollisionAvoid(t + dt/2, z + B/2,maxDepth);

D = dt * stateDerivCollisionAvoid(t, z + C,maxDepth);


% Calculate the next state vector from the previous one using the Runge-Kutta
% update equation
znext = z + (A + 2*B + 2*C + D)/6;
