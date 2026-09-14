%% FMCW radar: Breathing / Heart-rate estimation
% clear; close all; clc;

%% FMCW parameters (from HW statement)
f_start   = 5e9;          % Start frequency [Hz]
B_chirp   = 1e9;          % Chirp bandwidth [Hz]
T_chirp   = 0.1e-6;       % Chirp duration [s]  (0.1 us)
N_sample  = 256;          % Samples per chirp

Fs_adc    = N_sample / T_chirp;   % ADC sampling rate [Hz]
Ts_adc        = 1 / Fs_adc;           % ADC sampling period [s]

t_fast    = (0:N_sample-1) * Ts_adc;  % "Fast time" within one chirp [s]

k         = B_chirp / T_chirp;          % Chirp slope [Hz/s]

c         = 3e8;                  % Speed of light [m/s]
lambda    = c / f_start;          % Wavelength [m]

%% Slow-time sampling (chirp repetition)
T_rep = 1 / 120;        % Time between chirps [s]
N_chirps  = 1000;                 % Number of chirps (slow-time samples)
t_slow    = (0:N_chirps-1) * T_rep;   % Slow-time axis [s]

%% Target motion model (breathing + heart + hand motion)
d_0   = 5;        % Average chest distance [m]
d_B   = 0.07;     % Breathing amplitude [m]
d_H   = 0.01;     % Heartbeat amplitude [m]
f_B   = 0.2;      % Breathing rate [Hz]
f_H   = 1.2;      % Heart rate [Hz]

% Small high-frequency hand motion (micro-Doppler)
hand_amp = 0.1;   % [m]
f_hand   = 5;     % [Hz]

% Chest distance vs time (slow time)
d_chest = d_0 ...
        + d_B   * sin(2*pi*f_B   .* t_slow) ...
        + d_H   * sin(2*pi*f_H   .* t_slow) ...
        + hand_amp * sin(2*pi*f_hand .* t_slow);

%% Second person (e.g., dancing user) at another range
fan_ampl = 0.2;   % Dance amplitude [m]
f_dance  = 3;     % Dance frequency [Hz]
d2       = 20 + fan_ampl * sin(2*pi*f_dance .* t_slow);   % [m]

%% Round-trip delays
tau_chest = 2 * d_chest / c;    % Round-trip delay to chest [s]
tau_dance = 2 * d2      / c;    % Round-trip delay to dancing user [s]

% Range resolution (from FMCW theory)
range_resolution = c / (2*B_chirp);   % [m]

%% Transmit chirp (same for every chirp)
% s_tx(t) = exp(j2*pi (f0 t + 0.5 k t^2))
tx_chirp = exp(1j * 2*pi * (f_start .* t_fast + 0.5*k.*t_fast.^2));

%% Received signal for each chirp
% We simulate two moving scatterers: chest and dancing user
rx_sig = zeros(N_chirps, N_sample);

for m = 1:N_chirps
    t_delayed_chest = t_fast - tau_chest(m);
    t_delayed_dance = t_fast - tau_dance(m);

    % Chest echo
    s_chest = exp(1j * 2*pi * (f_start .* t_delayed_chest ...
                             + 0.5*k.*t_delayed_chest.^2));

    % Dancing user echo
    s_dance = exp(1j * 2*pi * (f_start .* t_delayed_dance ...
                             + 0.5*k.*t_delayed_dance.^2));

    % Total received signal (additive echoes)
    rx_sig(m,:) = s_chest + s_dance;
end

%% Dechirping: mix RX with conjugate of TX
adc_sampled = conj(rx_sig .* conj(tx_chirp));      % N_chirps x N_sample

%% TODO: Range FFT (fast-time FFT for each chirp)
[RangeFFT,range_axis] = compute_range_fft(adc_sampled,N_sample,B_chirp,c);


%% Plot RangeFFT
figure(1);clf;
avg_range_profile = mean(abs(RangeFFT), 1);  % Average over slow time
plot(range_axis, 20*log10(avg_range_profile/max(avg_range_profile)), 'LineWidth',2);
grid on;
xlabel('Range (m)');
ylabel('Magnitude (dB)');
title('Average rangeFFT profile (over all chirps)');
set(gca,'fontsize',20)

%% Plot Range-time map 
RTI_dB = 20*log10(abs(RangeFFT).');   % transpose: columns = slow time

figure(2);clf;
imagesc(t_slow, range_axis, RTI_dB);
axis xy;
xlabel('Slow time (s)');
ylabel('Range (m)');
title('Range–time intensity (dB)');
set(gca,'fontsize',20)
colorbar;


%% Select range bin corresponding to chest (closest to d_0)
[~, rangeBin] = min(abs(range_axis - d_0));

%% TODO: Extract slow-time phase at that range bin
[phase_all] = extract_phase(RangeFFT,rangeBin,T_rep);


%% Plot Phase Profile for breathing and heart rate 
figure(3);clf;
plot(t_slow, phase_all, 'LineWidth',2);
grid on;
xlabel('Slow time after averaging (s)');
ylabel('Unwrapped phase (rad)');
title('Phase vs. time at chest range bin');
set(gca,'fontsize',20)



%% TODO: FFT of phase to estimate breathing and heart-rate
[Pabs,f_axis] = analyze_fft_for_breathing_heart_rate(T_rep,N_chirps,phase_all);


%% Plot FFT profile for breathing and heart rate
figure(4);clf;
plot(f_axis(1:60), Pabs(1:60), '--o', 'LineWidth',2);
grid on;
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Breathing / heart-rate spectrum from phase');
set(gca,'fontsize',20)
