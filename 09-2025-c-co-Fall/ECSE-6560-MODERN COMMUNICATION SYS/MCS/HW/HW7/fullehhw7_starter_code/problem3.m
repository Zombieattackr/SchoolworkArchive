%% Beam Pattern for ULA with Different Antenna Spacings
% N = 8, AoA(theta0) = 90 degrees
% d in {lambda/4, lambda/2, lambda, 2*lambda}

clearvars;
close all;
clc;

%% Parameters
N       = 8;                 % number of antennas
theta0  = 90;                % desired AoA in degrees
theta0_rad = deg2rad(theta0);

lambda  = 1;                 % normalize wavelength to 1 (only d/lambda matters)
k       = 2*pi / lambda;     % wavenumber

% Candidate spacings (in units of lambda)
d_list  = [lambda/4, lambda/2, lambda, 2*lambda];

% Angle grid for plotting
theta_deg = 0.1:180;              % in degrees
theta_rad = deg2rad(theta_deg);      % in radians

%% Loop over spacings
for idx = 1:length(d_list)
    

    %% TODO: Replace beampattern.p function with your own implementation
    P_theta_dB = beampattern(d_list,idx,N,k,theta0_rad,theta_rad);
    P_all(idx, :) = P_theta_dB;
end

%% Plot
figure(3);clf;
hold on; grid on;

colors = lines(length(d_list));  % distinct colors for each spacing
legend_strings = { ...
    'd = \lambda/4', ...
    'd = \lambda/2', ...
    'd = \lambda',   ...
    'd = 2\lambda'   ...
    };
for idx = 1:length(d_list)
    subplot(2,2,idx)
    plot(theta_deg, P_all(idx, :), 'LineWidth', 2, 'Color', colors(idx,:));
    legend(legend_strings(idx), 'Location', 'best');
    grid on;
    ylim([-40 0]);  % show down to -40 dB
    xlabel('\theta (degrees)');
    ylabel('P(\theta) (dB)');
    sgtitle('Beam Pattern for N = 8 with Different Antenna Spacings');
    set(gca, 'fontsize',15)
end



