%% Initialization
clear; clc % initialize MATLAB
path(path,genpath("./lib")); % initilize functions
ofdm_params = ofdm_param_gen(64); % initialize parameters with 64 sub-carriers

%% Channel Flags and Parameters
SIM_FLAG = 1;     % flag to run simulation, 0 to run SDR
CFO_FLAG = 0;     % flag to add CFO in simulation
SFO_FLAG = 0;     % flag to add SFO in simulation
CHANNEL_FLAG = 0; % flag to apply channel in simulation

fs = 1e6; % sampling rate
fc = 2.45e9; % carrier frequency, roughly middle of ISM band
CFO = 0; % CFO in Hz
SFO = 0; % SFO in Hz
SNRdB = Inf; % awgn SNR (dB) in channel; set inf for no noise
ofdm_params.MOD_ORDER = 2; % Modulation order (2/4/16/64 = BPSK/QPSK/16-QAM/64-QAM)
params.N_OFDM_SYMS = 50; % Number of OFDM symbols per packet

%% Generate Data
rng(1)
[tx_samples,ofdm_params] = ofdm_tx(ofdm_params); % take tx packets from ofdm_tx.m
tx_samples_rep = repmat(tx_samples,1000,1); % repeat packets
tx_samples_rep = 0.5*tx_samples_rep./max(real(tx_samples_rep)); % normalize

%% Run Simulation / Run SDR
if(SIM_FLAG) % run simulation
    
    rx_samples = tx_samples_rep; % initialize received samples

    % apply channel
    if(CHANNEL_FLAG)
        h=set_channel(); % generate impulse response
        rx_samples = conv(tx_samples_rep,h); % apply impulse response
    end

    rx_samples = awgn(rx_samples, SNRdB, 'measured'); % add awgn

    % add CFO
    if(CFO_FLAG)
        rx_samples = rx_samples .* exp(1j*2*pi*(1:length(rx_samples)).'* CFO/fs);
    end
    % add SFO
    if(SFO_FLAG)
        rx_samples = resample(rx_samples, fs+SFO, fs);
    end
else % run SDR

    rx_samples = []; % initialize received samples

    % set SDR
    tx = sdrtx('Pluto', ...
        'CenterFrequency', fc, ...
        'BasebandSampleRate', fs, ...
        'Gain', -30);
    rx = sdrrx('Pluto', ...
        'CenterFrequency', fc+CFO_FLAG*CFO, ...
        'BasebandSampleRate', fs+SFO_FLAG*SFO, ...
        'SamplesPerFrame', length(tx_samples_rep), ...
        'OutputDataType', 'double',...
        'GainSource', 'Manual',...
        'Gain', 0);
    
    transmitRepeat(tx, [zeros(fs,1);tx_samples_rep]); % transmit data
    
    % receive data
    while length(rx_samples)<1.1*length(tx_samples_rep)
        rx_samples = [rx_samples;rx()];
    end

    % end transmission
    release(tx);
    release(rx);
end

%% Decoder Flags and Parameters
ofdm_params.DO_DECODE = 1;
ofdm_params.DO_APPLY_CFO_CORRECTION = 0;
ofdm_params.DO_APPLY_SFO_CORRECTION = 0;
ofdm_params.DO_APPLY_PHASE_ERR_CORRECTION = 0;
ofdm_params.plot_flag = 1; % Plot all figures
ofdm_params.num_packets = 10; % Number of packets to decode
ofdm_params.packet_step_size = 1; % keep it 1 in hw4

%% Decoding
tic
[op_struct, ofdm_params_out] = ofdm_decoder(rx_samples(1:end), ofdm_params);
toc