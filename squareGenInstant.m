function dV = squareGenInstant(t,dVmax)
% squareGen(t,dVmax) generates a squarewave which represents the bladder
% changes for the underwater glider. Currently it assumes an instaneous
% change.

if mod(fix(t/600),2) == 0
         dV = -dVmax;
else
         dV = dVmax;
end
