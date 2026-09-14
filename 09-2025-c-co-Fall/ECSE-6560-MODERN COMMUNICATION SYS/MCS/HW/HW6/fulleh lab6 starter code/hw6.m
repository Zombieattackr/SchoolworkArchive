%% Initialization
clearvars;
SNR_list = 0:1:10; % SNR in dB
N_iter = 100; % number of Monte-Carlo iterations

global noLTScount
noLTScount=0;

%% Parameters
USE_CHANNEL_ESTIMATES = 1;
CFO_FLAG = 0; % flag to enable CFO
DETECTION_OFFSET = 100; % to add packet detection error
LTS_CORR_THRESH = .8; % correlation threshold for LTS detection
DO_APPLY_CFO_CORRECTION = 0; % flag to enable CFO correction

TX_SPATIAL_STREAM_SHIFT=3;

% Waveform parameters
N_OFDM_SYMS             = 500;       % Number of OFDM symbols
MOD_ORDER               = 2;         % BPSK: 2; QPSK: 4,16,64
TX_SCALE                = 1;         % Scale for Tx waveform ([0:1])

% OFDM parameters
SC_IND_PILOTS           = [8 22 44 58];                           % Pilot subcarrier indices
SC_IND_DATA             = [2:7 9:21 23:27 39:43 45:57 59:64];     % Data subcarrier indices
N_SC                    = 64;                                     % Number of subcarriers
CP_LEN                  = 16;     
N_DATA_IND              = length(SC_IND_DATA);
N_DATA_SYMS             = N_OFDM_SYMS * length(SC_IND_DATA);      % Number of data symbols (one per data-bearing subcarrier per OFDM symbol)

% Channel parameters
% case 2
h1A = 1; % also used for case 1 and case 3
h1B = 0.5; % also used for case 1 and case 3
h1C = 1;
h1D = 0.5; 

%% Preamble
% Preamble is a concatenation of multiple copies of STS and LTS
% It is used for packet detection and CFO and channel estimation
% LTS is sufficient to be used for the above three blocks in a way similar to what is given in OFDM thesis.
% If you want to use STS in place of LTS, read the paper below:
% 'Robust Frequency and Timing Synchronization for OFDM' by Timothy M. Schmidl and Donald C. Cox

% STS
sts_f = zeros(1,64);
sts_f(1:27) = [0 0 0 0 -1-1i 0 0 0 -1-1i 0 0 0 1+1i 0 0 0 1+1i 0 0 0 1+1i 0 0 0 1+1i 0 0];
sts_f(39:64) = [0 0 1+1i 0 0 0 -1-1i 0 0 0 1+1i 0 0 0 -1-1i 0 0 0 -1-1i 0 0 0 1+1i 0 0 0];
sts_t = ifft(sqrt(13/6).*sts_f, 64);
sts_t = sts_t(1:16);

% LTS
lts_f = [0 1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1];
lts_t = ifft(lts_f, 64);

% We break the construction of our preamble into two pieces. First, the
% legacy portion, is used for CFO recovery and timing synchronization at
% the receiver. The processing of this portion of the preamble is SISO.
% Second, we include explicit MIMO channel training symbols.

% Legacy Preamble

% Use 30 copies of the 16-sample STS for extra AGC settling margin
% To avoid accidentally beamforming the preamble transmissions, we will
% let RFA be dominant and handle the STS and first set of LTS. We will
% append an extra LTS sequence from RFB so that we can build out the
% channel matrix at the receiver

sts_t_rep = repmat(sts_t, 1, 30);

preamble_legacy_A = [sts_t_rep, lts_t(33:64), lts_t, lts_t];
preamble_legacy_B = [circshift(sts_t_rep, [0, TX_SPATIAL_STREAM_SHIFT]), zeros(1, 160)];

% MIMO Preamble

% There are many strategies for training MIMO channels. Here, we will use
% the LTS sequence defined before and orthogonalize over time. First we
% will send the sequence on stream A and then we will send it on stream B

preamble_mimo_A = [lts_t(33:64), 0.5*lts_t, zeros(1,96)];
preamble_mimo_B = [zeros(1,96), lts_t(33:64), 0.5*lts_t];

preamble_A = [preamble_legacy_A, preamble_mimo_A];
preamble_B = [preamble_legacy_B, preamble_mimo_B];

pilots_A= [1 1 -1 1].';
pilots_B= [0 0 0 0].';

% Generate a payload of random integers
tx_data = randi([0 MOD_ORDER-1], N_DATA_IND, N_OFDM_SYMS);

% we will use same tx data for both the TX antenna
tx_payload_vec_A=generate_ofdm_tx(tx_data, pilots_A, MOD_ORDER, N_SC, CP_LEN, SC_IND_DATA, SC_IND_PILOTS, N_OFDM_SYMS);
tx_payload_vec_B=generate_ofdm_tx(tx_data, pilots_B, MOD_ORDER, N_SC, CP_LEN, SC_IND_DATA, SC_IND_PILOTS, N_OFDM_SYMS);
tx_data_a = tx_data(:);
tx_data_b = tx_data(:);

[tx_vec_air_A]=generate_mimo(preamble_A,tx_payload_vec_A, TX_SCALE,CFO_FLAG);
[tx_vec_air_B]=generate_mimo(preamble_B,tx_payload_vec_B, TX_SCALE,CFO_FLAG);

    
% MRC precoding for case 3 (MIMO 2x1)
[tx_vec_air_AA,tx_vec_air_BA] = tx_precoding(tx_vec_air_A,tx_vec_air_B,h1A,h1B);

for j=1:length(SNR_list)
    ber1=[];
    ber2=[];
    ber3=[];
    
    for i=1:N_iter
        
        % Channel for case 2 (MIMO 1x4) including case 1 (MIMO 1x2)

        rx_vec_air_1A = h1A*tx_vec_air_A;
        rx_vec_air_1B= h1B*tx_vec_air_A;
        rx_vec_air_1C = h1C*tx_vec_air_A;
        rx_vec_air_1D= h1D* tx_vec_air_A;
                
        rx_vec_air_1A = [zeros(1,DETECTION_OFFSET), rx_vec_air_1A];
        rx_vec_air_1B = [zeros(1,DETECTION_OFFSET), rx_vec_air_1B];
        rx_vec_air_1C = [zeros(1,DETECTION_OFFSET), rx_vec_air_1C];
        rx_vec_air_1D = [zeros(1,DETECTION_OFFSET), rx_vec_air_1D];
        
        noise_power = var(rx_vec_air_1A) * 10 .^(-SNR_list(j)/10);
        noise_power = sqrt(noise_power);
        rx_vec_air_1A = rx_vec_air_1A + noise_power.*complex(randn(1,length(rx_vec_air_1A)), randn(1,length(rx_vec_air_1A)));
        rx_vec_air_1B = rx_vec_air_1B + noise_power.*complex(randn(1,length(rx_vec_air_1B)), randn(1,length(rx_vec_air_1B)));
        rx_vec_air_1C = rx_vec_air_1C + noise_power.*complex(randn(1,length(rx_vec_air_1C)), randn(1,length(rx_vec_air_1C)));
        rx_vec_air_1D = rx_vec_air_1D + noise_power.*complex(randn(1,length(rx_vec_air_1D)), randn(1,length(rx_vec_air_1D)));
               
        % Channel for case 3 (MIMO 2x1)

        rx_vec_air_AA = h1A*tx_vec_air_AA + h1B*tx_vec_air_BA;

        rx_vec_air_AA = [zeros(1,DETECTION_OFFSET), rx_vec_air_AA];
 
        rx_vec_air_AA = rx_vec_air_AA + noise_power.*complex(randn(1,length(rx_vec_air_1A)), randn(1,length(rx_vec_air_1A)));
        

        % Receiver

        [ber1i,ber2i,ber3i] = MIMO_OFDM_RX(lts_t,lts_f,sts_t,...
            N_OFDM_SYMS,CP_LEN,N_SC,SC_IND_DATA,MOD_ORDER,...
            rx_vec_air_1A,rx_vec_air_1B,rx_vec_air_1C,rx_vec_air_1D,...
            rx_vec_air_AA,tx_data(:),h1A,h1B, h1C,h1D,USE_CHANNEL_ESTIMATES,LTS_CORR_THRESH,DO_APPLY_CFO_CORRECTION);

        
        ber1 = [ber1, ber1i];
        ber2 = [ber2, ber2i];
        ber3 = [ber3, ber3i];

    end
    
    ber_avg1(j)=mean(ber1); % average BER for case 1
    ber_avg2(j)=mean(ber2); % average BER for case 2
    ber_avg3(j)=mean(ber3); % average BER for case 3

end
%% Plots
figure(22); clf;
semilogy(SNR_list,ber_avg1, 'x-','LineWidth',3)
xlabel('SNR(dB)')
ylabel('average of BER')
hold on;grid on; grid minor;

semilogy(SNR_list,ber_avg2, 'o-','LineWidth',3)
xlabel('SNR(dB)')
ylabel('average of BER')

semilogy(SNR_list,ber_avg3, '>-','LineWidth',3)
xlabel('SNR(dB)')
ylabel('average of BER')

legend('1x2 MIMO', '1x4 MIMO', '2x1 MIMO')
title('BER vs SNR')
set(gca, 'fontsize', 18)