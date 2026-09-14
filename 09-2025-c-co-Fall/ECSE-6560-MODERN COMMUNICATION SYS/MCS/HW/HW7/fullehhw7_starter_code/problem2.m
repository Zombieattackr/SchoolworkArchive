%% Programming Q2: Channel Phase and Motion Detection

clearvars;
close all;
clc;

%% Load data
% h1: 200 x 2 complex channel matrix (segment 1)
% t1: 200 x 1 timestamps (ms) for h1
% h2: 198 x 2 complex channel matrix (segment 2)
% t2: 198 x 1 timestamps (ms) for h2
load('h_move.mat');

%% ToDo write code 
% convert timestamps to seconds relative to first packet in each segment
t1s = (t1 - t1(1)) / 1000;   % seconds
t2s = (t2 - t2(1)) / 1000;

% compute phases
phase1_seg1 = angle(h1(:,1));
phase2_seg1 = angle(h1(:,2));
phase1_seg2 = angle(h2(:,1));
phase2_seg2 = angle(h2(:,2));

% unwrap absolute phases
phase1_seg1_unw = unwrap(phase1_seg1);
phase2_seg1_unw = unwrap(phase2_seg1);
phase1_seg2_unw = unwrap(phase1_seg2);
phase2_seg2_unw = unwrap(phase2_seg2);

% relative phase (antenna1 / antenna2) and unwrap
relPhase_seg1 = angle(h1(:,1) ./ h1(:,2));
relPhase_seg2 = angle(h2(:,1) ./ h2(:,2));
relPhase_seg1_unw = unwrap(relPhase_seg1);
relPhase_seg2_unw = unwrap(relPhase_seg2);

% Part (a): plots for segment 1
figure('Name','Segment 1: absolute phases and relative phase','NumberTitle','off','Position',[100 100 900 600]);
subplot(3,1,1);
plot(t1s, phase1_seg1, '.-'); hold on; plot(t1s, phase2_seg1, '.-');
title('Segment 1: Wrapped absolute phases'); xlabel('Time (s)'); ylabel('Phase (rad)');
legend('ant1','ant2'); grid on;

subplot(3,1,2);
plot(t1s, phase1_seg1_unw, '.-'); hold on; plot(t1s, phase2_seg1_unw, '.-');
title('Segment 1: Unwrapped absolute phases'); xlabel('Time (s)'); ylabel('Phase (rad)');
legend('ant1','ant2'); grid on;

subplot(3,1,3);
plot(t1s, relPhase_seg1, '.-'); hold on; plot(t1s, relPhase_seg1_unw, '.-');
title('Segment 1: Relative phase (h1./h2) — wrapped (dots) and unwrapped (line)');
xlabel('Time (s)'); ylabel('Rel phase (rad)'); legend('wrapped','unwrapped'); grid on;

%% Part (a): plots for segment 2
figure('Name','Segment 2: absolute phases and relative phase','NumberTitle','off','Position',[1100 100 900 600]);
subplot(3,1,1);
plot(t2s, phase1_seg2, '.-'); hold on; plot(t2s, phase2_seg2, '.-');
title('Segment 2: Wrapped absolute phases'); xlabel('Time (s)'); ylabel('Phase (rad)');
legend('ant1','ant2'); grid on;

subplot(3,1,2);
plot(t2s, phase1_seg2_unw, '.-'); hold on; plot(t2s, phase2_seg2_unw, '.-');
title('Segment 2: Unwrapped absolute phases'); xlabel('Time (s)'); ylabel('Phase (rad)');
legend('ant1','ant2'); grid on;

subplot(3,1,3);
plot(t2s, relPhase_seg2, '.-'); hold on; plot(t2s, relPhase_seg2_unw, '.-');
title('Segment 2: Relative phase (h1./h2) — wrapped (dots) and unwrapped (line)');
xlabel('Time (s)'); ylabel('Rel phase (rad)'); legend('wrapped','unwrapped'); grid on;

