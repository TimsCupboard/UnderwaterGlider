function [Cd, Cl] = hydrodynamics(attack)
%% Hydrodynamics    Advanced drag and lift coefficient model for the micro-glider
%
% [CD, CL] = hydrodynamics(ATTACK) outputs vectors CD and CL of modelled 
% drag and lift coefficients at the corresponding attack angles in the 
% input vector ATTACK. The attack angles are assumed to be in radians.
% 
% The model is based on empirical data taken from:
% Zhang et al., "Hydrodynamic performance and calculation of lift-drag 
% ratio on underwater glider", Journal of Marine Science and Technology, 
% volume 26, pages 16-23, 2021
%
% Alan Hunter, University of Bath, Nov 2021.

Cd = 9.8 * cos( 2*attack + pi ) + 10.2;
Cl = 10 * sin( 2*attack );

I = find( attack > pi/2 | attack < -pi/2 );
Cd(I) = 5 * cos( 2*attack(I) + pi ) + 15;

I = find( attack > pi/4 );
Cl(I) = 7.5 * sin( 2*attack(I) ) + 2.5;
I = find( attack < -pi/4 );
Cl(I) = 7.5 * sin( 2*attack(I) ) - 2.5;

if 0
    figure(1)
    subplot(2,1,1)
    plot(attack*180/pi,Cd,attack*180/pi,Cl,'LineWidth',2)
    ylabel('Drag and Lift Coefficients')
    legend('Drag','Lift')
    subplot(2,1,2)
    plot(attack*180/pi,Cl./Cd,'LineWidth',2)
    ylim([-1 1]*6)
    xlabel('Attack Angle, deg')
    ylabel('Lift:Drag Ratio, deg')
end