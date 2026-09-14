
% MCS Lab 3 Pilot-only OFDM channel estimation
% 1) Place pilots on subcarriers (frequency domain)
% 2) IFFT to time, add CP
% 3) Pass through multipath channel (linear convolution) + AWGN
% 4) Remove CP, FFT
% 5) Per-subcarrier channel estimation (Hhat = Y/X)
% 6) Plot true vs. estimated channel in frequency and time domains
% 7) Getv multiple plots for each sub-question


clearvars
rng(123);

%% Parameters 
N       = 64;            % FFT size
CP      = 30;            % CP length 
SNRdB   = inf;           % SNR (dB); set inf for no noise
useDC   = true;          % set false to remove DC subcarrier 
useGuards = false;       % set true to remove Guard bands
guard = 10;              % guard band #subcarriers one of the two edges

% Multipath channel (discrete-time tapped delay line) 
% delays in samples, complex gains
tap_delays = [0 2 5 9 13];  
tap_gains  = [1.0 0.6 0.4 0.25 0.15] .* exp(1j*2*pi*[0.00 0.11 -0.27 0.37 -0.41]);
tap_gains  = tap_gains / sqrt(sum(abs(tap_gains).^2)); % normalize power to 1

%% Pilot allocation 
% Fill all usable subcarriers with BPSK pilots

pilotF = randi([0 1], N, 1) * 2 - 1;   % values in {+1, -1} pilot value on each subcarrier
if ~useDC
    pilotF(N/2+1) = 0;           % DC bin (center) set to zero
end
if useGuards 
    pilotF(1:guard)     = 0;     % here we simply null a few bins at edges
    pilotF(end-guard+1:end) = 0; 
end


%% TX: IFFT, CP append 
% NOTE: We'll treat 'pilotF' as an FFT-shifted vector for visualization.
% For actual IFFT, we need unshifted frequency ordering.
pilotF_unshift = ifftshift(pilotF);        % put DC at index 1 for ifft()
x_noCP = ifft(pilotF_unshift, N);          % time-domain symbol (length N)
x_tx   = [x_noCP(end-CP+1:end); x_noCP];   % prepend CP  (length N+CP)

%% Channel 
% Build discrete LTI channel impulse response h (length Lh = max delay +1)
Lh = max(tap_delays) + 1;
h  = zeros(Lh,1);
h(tap_delays + 1) = tap_gains;

% The "true" frequency response for circular convolution of length N
% is the N-point DFT of h zero-padded to length N, viewed with fftshift.
H_true_unshift = fft([h; zeros(N - numel(h), 1)], N);
H_true = fftshift(H_true_unshift);

freq_axis = -N/2:N/2-1; % shifted freq axis

% For comparison, we plot first, say, 2*CP taps 
plot_taps = min(N, max(2*CP, Lh + 8));        % a reasonable window

%% Plot ground truth True channel
figure(1);clf;
subplot(2,2,1);
plot(freq_axis, abs(H_true), 'o-', 'DisplayName','True'); hold on;
xlabel('Subcarrier index k'); ylabel('Magnitude');
title('Frequency Response Magnitude');
legend('Location','northeast');

subplot(2,2,3);
plot(freq_axis, angle(H_true), 'o-', 'DisplayName','True'); hold on;
xlabel('Subcarrier index k'); ylabel('Phase (rad)');
title('Frequency Response Phase');
legend('Location','northeast');

subplot(2,2,2);
stem(0:plot_taps-1, abs([h; zeros(plot_taps-numel(h),1)]), 'filled', 'DisplayName','True'); hold on;
xlabel('Tap index n'); ylabel('Magnitude');
title('Channel Impulse Response');
legend('Location','northeast');

subplot(2,2,4);
stem(0:plot_taps-1, angle([h; zeros(plot_taps-numel(h),1)]), 'filled', 'DisplayName','True'); hold on;
xlabel('Tap index n'); ylabel('Phase Rad');
title('Channel Impulse Response');
legend('Location','northeast');


% All blocks below are TODO

%% Apply channel

%TODO

%% Add AWGN

%TODO

%% RX: Remove CP, take FFT 

% For a single symbol, emulate a perfectly timed receiver that drops CP
% We take the window aligned to the symbol after channel: start after CP
% NOTE: Due to linear convolution, the last (Lh-1) samples are transient.
% We'll take the N samples starting from CP; i.e.; drop the CP and
% transient samples

%TODO

%% OFDM Channel estimate (estimate in freq domain then take ifft for time domain)

%TODO

%% Plot Channel frequency response (magnitude and phase); and Channel impulse response (magnitude and phase)
% COmpare True channel with estimated channel as two legends in each
% subplot. Compute NMSE and display it in the plot.

%TODO