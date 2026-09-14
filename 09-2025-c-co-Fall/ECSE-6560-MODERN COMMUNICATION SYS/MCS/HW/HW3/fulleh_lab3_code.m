
% MCS Lab 3 Pilot-only OFDM channel estimation
% Hayden Fuller
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
CP      = 24;            % CP length 
SNRdB   = 30;           % SNR (dB); set inf for no noise
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

%% Apply channel TODO
y_conv = conv(x_tx, h);
timing_offset = 0;


%% Add AWGN TODO
if isinf(SNRdB)
    y_rx_full = y_conv;
else
    y_rx_full = awgn(y_conv, SNRdB, 'measured');
end


%% RX: Remove CP, take FFT TODO
% For a single symbol, emulate a perfectly timed receiver that drops CP
% We take the window aligned to the symbol after channel: start after CP
% NOTE: Due to linear convolution, the last (Lh-1) samples are transient.
% We'll take the N samples starting from CP; i.e.; drop the CP and
% transient samples
rx_start = CP + 1 + timing_offset;
y_rx = y_rx_full(rx_start : rx_start + N - 1).';
Y_unshift = fft(y_rx, N);


%% OFDM Channel estimate (estimate in freq domain then take ifft for time domain) TODO
X_unshift = pilotF_unshift(:);
Y_unshift = Y_unshift(:);

if length(X_unshift) ~= length(Y_unshift)
    error('Length mismatch: X_unshift (%d) vs Y_unshift (%d)', ...
          length(X_unshift), length(Y_unshift));
end

Hhat_unshift = zeros(N,1);
used_idx = abs(X_unshift) > 0;
Hhat_unshift(used_idx,1) = Y_unshift(used_idx,1) ./ X_unshift(used_idx,1);
Hhat_unshift(~used_idx,1) = 0;
Hhat = fftshift(Hhat_unshift);
h_hat_circ = ifft(Hhat_unshift, N);


%% Plot Channel frequency response (magnitude and phase); and Channel impulse response (magnitude and phase)
% COmpare True channel with estimated channel as two legends in each
% subplot. Compute NMSE and display it in the plot. TODO
U = find(used_idx);

num = sum(abs(Hhat_unshift(U) - H_true_unshift(U)).^2);
den = sum(abs(H_true_unshift(U)).^2);
NMSE_linear = num / den;
NMSE_dB = 10*log10(NMSE_linear);

h_plot = [h; zeros(plot_taps - numel(h), 1)];
hhat_plot = [h_hat_circ(1:plot_taps).'; zeros(max(0, plot_taps - numel(h_hat_circ)),1)]; % ensure column

figure(2); clf;

% Frequency magnitude
subplot(2,2,1);
plot(freq_axis, abs(H_true), 'o-', 'DisplayName','H_{true}'); hold on;
plot(freq_axis, abs(Hhat), 'x--', 'DisplayName','H_{est}'); hold off;
xlabel('Subcarrier index k'); ylabel('|H(k)|');
title(sprintf('Frequency Magnitude — NMSE = %.3e (%.2f dB)', NMSE_linear, NMSE_dB));
legend('Location','best');

% Frequency phase
subplot(2,2,3);
plot(freq_axis, unwrap(angle(H_true)), 'o-', 'DisplayName','H_{true}'); hold on;
plot(freq_axis, unwrap(angle(Hhat)), 'x--', 'DisplayName','H_{est}'); hold off;
xlabel('Subcarrier index k'); ylabel('Phase (rad)');
title('Frequency Phase');
legend('Location','best');

% Time-domain magnitude (impulse responses)
subplot(2,2,2);
stem(0:plot_taps-1, abs(h_plot), 'filled', 'DisplayName','h_{true}'); hold on;
stem(0:plot_taps-1, abs(hhat_plot), 'x', 'DisplayName','h_{est}'); hold off;
xlabel('Tap index n'); ylabel('|h[n]|');
title('Impulse Response Magnitude');
legend('Location','best');

% Time-domain phase (impulse responses)
subplot(2,2,4);
stem(0:plot_taps-1, angle(h_plot), 'filled', 'DisplayName','h_{true}'); hold on;
stem(0:plot_taps-1, angle(hhat_plot), 'x', 'DisplayName','h_{est}'); hold off;
xlabel('Tap index n'); ylabel('Phase (rad)');
title('Impulse Response Phase');
legend('Location','best');
