function [flag_lts_not_found, rx_dec_cfo_corr_1A,rx_dec_cfo_corr_1B,rx_dec_cfo_corr_1C,...
    rx_dec_cfo_corr_1D,rx_dec_cfo_corr_AA,...
    rx_H_est_1A,rx_H_est_1B,rx_H_est_1C,rx_H_est_1D] = packet_detection_and_channel_estimation(lts_t, ...
    raw_rx_dec_1A,N_OFDM_SYMS,CP_LEN,N_SC,raw_rx_dec_1B,raw_rx_dec_1C, ...
    raw_rx_dec_1D,raw_rx_dec_AA,sts_t,lts_f,LTS_CORR_THRESH,DO_APPLY_CFO_CORRECTION)
global noLTScount

% For simplicity, we'll only use RFA for LTS correlation and peak
% discovery. A straightforward addition would be to repeat this process for
% RFB and combine the results for detection diversity.
% Complex cross correlation of Rx waveform with time-domain LTS
lts_corr = abs(conv(conj(fliplr(lts_t)), sign(raw_rx_dec_1A)));

% Skip early and late samples - avoids occasional false positives from pre-AGC samples
lts_corr = lts_corr(32:end-32);

% Find all correlation peaks
lts_peaks = find(lts_corr > LTS_CORR_THRESH*max(lts_corr));

% Select best candidate correlation peak as LTS-payload boundary
% In this MIMO example, we actually have 3 LTS symbols sent in a row.
% The first two are sent by RFA on the TX node and the last one was sent
% by RFB. We will actually look for the separation between the first and the
% last for synchronizing our starting index.
[LTS1, LTS2] = meshgrid(lts_peaks,lts_peaks);
[lts_last_peak_index,~] = find(LTS2-LTS1 == length(lts_t));

% Stop if no valid correlation peak was found
flag_lts_not_found  =0;
if(isempty(lts_last_peak_index))
    noLTScount=noLTScount+1;
    warning(strcat('No LTS Correlation Peaks Found!',num2str(noLTScount)));
    flag_lts_not_found  =1;
    return;
end

% Set the sample indices of the payload symbols and preamble
% The "+32" here corresponds to the 32-sample cyclic prefix on the preamble LTS
% The "+192" corresponds to the length of the extra training symbols for MIMO channel estimation
mimo_training_ind = lts_peaks(max(lts_last_peak_index))+32;
payload_ind = mimo_training_ind+ 192;


% Subtract of 2 full LTS sequences and one cyclic prefixes
% The "-160" corresponds to the length of the preamble LTS (2.5 copies of 64-sample LTS)
lts_ind = mimo_training_ind-160;

if(DO_APPLY_CFO_CORRECTION)
    %Extract LTS (not yet CFO corrected)
    rx_lts = raw_rx_dec_1A(lts_ind : lts_ind+159); %Extract the first two LTS for CFO
    rx_lts1 = rx_lts(-64 + (97:160));
    rx_lts2 = rx_lts( 97:160);

    %Calculate coarse CFO est
    rx_cfo_est_lts = mean(unwrap(angle(rx_lts2 .* conj(rx_lts1))));
    rx_cfo_est_lts = rx_cfo_est_lts/(2*pi*64);
else
    rx_cfo_est_lts = 0;
end

% Apply CFO correction to raw Rx waveforms
rx_cfo_corr_t = exp(-1i*2*pi*rx_cfo_est_lts*(0:40832-1));

try
% case 2
rx_dec_cfo_corr_1A = raw_rx_dec_1A(lts_ind-480:payload_ind+N_OFDM_SYMS*(CP_LEN+N_SC)-1) .* rx_cfo_corr_t;
rx_dec_cfo_corr_1B = raw_rx_dec_1B(lts_ind-480:payload_ind+N_OFDM_SYMS*(CP_LEN+N_SC)-1) .* rx_cfo_corr_t;
rx_dec_cfo_corr_1C = raw_rx_dec_1C(lts_ind-480:payload_ind+N_OFDM_SYMS*(CP_LEN+N_SC)-1) .* rx_cfo_corr_t;
rx_dec_cfo_corr_1D = raw_rx_dec_1D(lts_ind-480:payload_ind+N_OFDM_SYMS*(CP_LEN+N_SC)-1) .* rx_cfo_corr_t;
% case 3
rx_dec_cfo_corr_AA = raw_rx_dec_AA(lts_ind-480:payload_ind+N_OFDM_SYMS*(CP_LEN+N_SC)-1) ;
catch
error('something wrong')
end

% MIMO Channel Estimatation for case 2 (MIMO 1x4)

lts_ind_TXA_start = 30*length(sts_t)+ 2.5*length(lts_t)+ 0.5*length(lts_t)+ 1 ;
lts_ind_TXA_end = lts_ind_TXA_start + 64 - 1;

rx_lts_A = rx_dec_cfo_corr_1A(lts_ind_TXA_start:lts_ind_TXA_end);
rx_lts_B = rx_dec_cfo_corr_1B(lts_ind_TXA_start:lts_ind_TXA_end);
rx_lts_C = rx_dec_cfo_corr_1C(lts_ind_TXA_start:lts_ind_TXA_end);
rx_lts_D = rx_dec_cfo_corr_1D(lts_ind_TXA_start:lts_ind_TXA_end);

rx_lts_A_f=fft(rx_lts_A);
rx_lts_B_f=fft(rx_lts_B);
rx_lts_C_f=fft(rx_lts_C);
rx_lts_D_f=fft(rx_lts_D);


% Perform Channel estimation for case 2 (MIMO 1x4)

rx_H_est_1A= rx_lts_A_f./lts_f; % (also used for case 1)
rx_H_est_1B= rx_lts_B_f./lts_f; % (also used for case 1)
rx_H_est_1C= rx_lts_C_f./lts_f;
rx_H_est_1D= rx_lts_D_f./lts_f;

end