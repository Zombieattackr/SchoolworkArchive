clearvars;
close all;
clc;
load('h_static.mat');   % provides h (100x2), t (100x1)

%% ToDo write code 
% Convert timestamps to relative time
time_s = (t - t(1)) / 1000;   % seconds from first packet
pkt_idx = (1:size(h,1))';

% (a) absolute phase (wrapped) and unwrapped for each antenna
phase1_wrapped = angle(h(:,1));
phase2_wrapped = angle(h(:,2));
phase1_unwrapped = unwrap(phase1_wrapped);
phase2_unwrapped = unwrap(phase2_wrapped);

figure;
plot(time_s, phase1_wrapped, '.-'); hold on;
plot(time_s, phase2_wrapped, '.-');
xlabel('Time (s)'); ylabel('Wrapped phase (rad)');
title('Wrapped phase on antennas 1 & 2'); legend('ant1','ant2'); grid on;

figure;
plot(time_s, phase1_unwrapped, '.-'); hold on;
plot(time_s, phase2_unwrapped, '.-');
xlabel('Time (s)'); ylabel('Unwrapped phase (rad)');
title('Unwrapped phase on antennas 1 & 2 (shows drift)'); legend('ant1','ant2'); grid on;

% (c) relative phase between antennas
relPhase_wrapped = angle(h(:,1) ./ h(:,2));
relPhase_unwrapped = unwrap(relPhase_wrapped);

figure;
plot(time_s, relPhase_wrapped, '.-'); hold on;
plot(time_s, relPhase_unwrapped, '.-');
xlabel('Time (s)'); ylabel('Relative phase (rad)');
legend('wrapped','unwrapped');
title('Relative phase h1/h2 (wrapped and unwrapped)');
grid on;

% (e) AoA estimate from averaged unwrapped relative phase
c = 3e8; f_c = 5.5e9; lambda = c / f_c;
S = lambda/2;

% average unwrapped relative phase across packets
avg_delta_phi = mean(relPhase_unwrapped);
med_delta_phi = median(relPhase_unwrapped);

cos_arg_mean = (avg_delta_phi * lambda) / (2*pi*S);
cos_arg_med  = (med_delta_phi * lambda) / (2*pi*S);

theta_mean_deg = rad2deg(acos(cos_arg_mean));
theta_med_deg  = rad2deg(acos(cos_arg_med));

fprintf('AoA estimate (mean unwrapped rel-phase):  %.2f degrees\n', theta_mean_deg);
fprintf('AoA estimate (median unwrapped rel-phase): %.2f degrees\n', theta_med_deg);

path_diff_m = (lambda/(2*pi)) * avg_delta_phi;
fprintf('Equivalent path-length difference from avg rel-phase: %.3f m\n', path_diff_m);