function dV = squareGen(t,dVmax)
% squareGen(t,dVmax) generates a squarewave which represents the bladder
% changes for the underwater glider. Currently it assumes an instaneous
% change.

% pause(0.001)

% Time taken to 
dVtime = 30;

% Checks for the first 30 seconds as dV starts at 0 instead of +- 0.06
if t <= 30
    dV = -(dVmax/(dVtime))*rem(t,600);
else
    if mod(fix(t/600),2) == 0
        if rem(t,600) <= 30
            dV = dVmax-(dVmax/(dVtime/2))*rem(t,600);
            % disp('1')
        else
            dV = -dVmax;
            % disp('2')
        end
    else
        if rem(t,600) <= 30
            dV = -dVmax+(dVmax/(dVtime/2))*rem(t,600);
            % disp('3')
        else
            dV = dVmax;
            % disp('4')
        end
    end
end