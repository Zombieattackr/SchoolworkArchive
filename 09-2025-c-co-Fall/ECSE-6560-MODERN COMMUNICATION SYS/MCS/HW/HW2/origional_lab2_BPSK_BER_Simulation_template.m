%% BPSK BER Simulation 
% ------------------------------------------------------------------------------
% This script simulates the BER of coherent BPSK over an AWGN channel and
% compares it to the analytical expression Q(sqrt(2*Eb/N0)) = 0.5*erfc(sqrt(Eb/N0)).
%
% COMPLETE ALL TODOs. 
% For theory, follow https://piazza.com/class_profile/get_resource/mevvk9kirhg2fu/mfwtorbg5i25kj
%
% Q1: Simulate BER vs SNR for coherent BPSK and compare to analytical curve.
% Q2: (6560 only)Repeat with "oversampling" factors L in {1,2,4} by reducing per-sample
%     noise variance by 1/L (processing-gain modeling).
%
% IMPORTANT MODELING NOTE:
% - We use the common simulation normalization Eb = 1 (dimensionless) so that
%   N0 = Eb / (Eb/N0) is also treated numerically as a dimensionless quantity.
% - In "Part 2", we model an "oversampling factor" (oversamp_fac) by reducing the
%   *effective* noise variance per sample by 1/oversamp_fac. This mimics the idea
%   that more samples per bit allow lower per-sample noise if total noise energy
%   over a bit is held fixed. Practically, this behaves like a processing gain
%   and shows a BER improvement as oversamp_fac increases.
% ------------------------------------------------------------------------------

clear; clc;
rng(123);  % for Reproducibility

%% ---------------------------- Simulation Parameters ---------------------------
num_bits   = 1e5;     % Number of BPSK symbols (bits) to transmit in each trial
snr_db_vec = 0:1:10;  % Vector of Eb/N0 points in dB to simulate
num_snrs   = numel(snr_db_vec);

% Generate random BPSK symbols in {-1, +1}
% bits = 0/1 -> map to -1/+1 via 2*bits - 1

% TODO

%% -------------------- Part 1: Single "oversampling" setting -------------------
% We simulate BER for a single oversampling factor (oversamp_fac = 1).
% With oversamp_fac = 1, the "effective" noise variance equals the baseline.
oversamp_fac = 1;                 % No oversampling-based noise scaling
ber_vec = zeros(1, num_snrs);     % Preallocate simulated BER array

for i = 1:num_snrs
    % Select Eb/N0 for this run from snr_db_vec, db to linear scale mapping
    % to get ebn0 
    
    %TODO

    % Energy per bit (normalized): Eb = 1 (dimensionless)
    % Under this normalization, N0 = Eb / (Eb/N0) is numerically dimensionless too.
    
    %TODO

    % Effective noise scaling due to oversampling:
    % We reduce the per-sample noise variance by oversamp_fac (processing gain model).
    % For *real* BPSK baseband, the per-sample *variance* from "N0" is N0/2.
    % Here we scale that variance by 1/oversamp_fac.
    n0_effective = n0 / oversamp_fac;

    % Generate real AWGN samples: variance = (n0_effective)/2
    % randn() has variance 1, so scale by sqrt(variance)
    
    %TODO

    % Pass bpsk_symbs through AWGN channel to get noisy symbols

    %TODO

    % Hard-decision detection for BPSK:
    % Decision rule: y >= 0 -> +1, else -> -1
    
    %TODO

    % Compute BER:
    % An error occurs where transmitted and detected symbols differ.
    % |rx - tx| is 0 for correct decisions, 2 for errors (since values are ±1).
    % So, number_of_errors = sum(|rx - tx|/2).
    
    %TODO: get ber_vec(i)
end

% Analytical BER for coherent BPSK in AWGN:
% Pb = Q( sqrt(2*Eb/N0) ) = 0.5*erfc( sqrt(Eb/N0) ).

% TODO: Get ber_vec_analytical vector for all SNR values in snr_db_vec

% Plot (Part 1): Simulated vs Analytical
figure(1); clf;
semilogy(snr_db_vec, ber_vec, 'LineWidth', 2, 'LineStyle', ':'); hold on;
semilogy(snr_db_vec, ber_vec_analytical, 'LineWidth', 2);
legend('Simulated BER', 'Analytical Expression', 'Location', 'southwest');
title('BER Curves for BPSK (Normalized Eb=1)');
xlabel('Eb/N0 (dB)');
ylabel('BER');
grid on; grid minor;

%% -------- Part 2: "Oversampling" sweep via effective-noise scaling ------------
% Here we sweep oversamp_fac in {1, 2, 4} by *reducing* the per-sample noise
% variance linearly with oversamp_fac. This models a processing-gain-like effect.
% As oversamp_fac increases, you will see a BER improvement (by design).

oversamp_fac_vec = [1, 2, 4];      % Oversampling-like scaling values
ber_mat = zeros(numel(oversamp_fac_vec), num_snrs);  % BER for each oversamp + SNR

for osamp_idx = 1:numel(oversamp_fac_vec)
    oversamp_fac = oversamp_fac_vec(osamp_idx);

    for i = 1:num_snrs
         
        % TODO follow prev part to compute ber_mat(osamp_idx, i)

        
    end
end

% Plot (Part 2): Effect of "oversampling" (via noise scaling) on BER
figure(2); clf; 
semilogy(snr_db_vec, ber_mat(1,:), 'LineWidth', 2, 'LineStyle', ':'); hold on;
semilogy(snr_db_vec, ber_mat(2,:), 'LineWidth', 2, 'LineStyle', ':');
semilogy(snr_db_vec, ber_mat(3,:), 'LineWidth', 2, 'LineStyle', ':');
legend('Simulated BER, Oversamp 1', ...
       'Simulated BER, Oversamp 2', ...
       'Simulated BER, Oversamp 4', ...
       'Location', 'southwest');
xlabel('Eb/N0 (dB)');
ylabel('BER');
title('Modeled Effect of "Oversampling" on BPSK BER (Noise-Scaling View)');
grid on; grid minor;

