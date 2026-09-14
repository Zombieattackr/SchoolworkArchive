function [ber1,ber2,ber3] = MIMO_OFDM_RX(lts_t,lts_f,sts_t,...
            N_OFDM_SYMS,CP_LEN,N_SC,SC_IND_DATA,MOD_ORDER,...
            rx_vec_air_1A,rx_vec_air_1B,rx_vec_air_1C,rx_vec_air_1D,...
            rx_vec_air_AA,tx_data,h1A,h1B,h1C,h1D,USE_CHANNEL_ESTIMATES,LTS_CORR_THRESH,DO_APPLY_CFO_CORRECTION)

ber1 = [];
ber2 = [];
ber3 = [];

flag_lts_not_found= ...
    packet_detection_and_channel_estimation(lts_t,rx_vec_air_1A,N_OFDM_SYMS,CP_LEN,N_SC,rx_vec_air_1B,rx_vec_air_1C,rx_vec_air_1D,rx_vec_air_AA,sts_t,lts_f,LTS_CORR_THRESH,DO_APPLY_CFO_CORRECTION);

if(flag_lts_not_found)
    return
end

[~,rx_dec_cfo_corr_1A,rx_dec_cfo_corr_1B,rx_dec_cfo_corr_1C,rx_dec_cfo_corr_1D,...
    rx_dec_cfo_corr_AA,rx_H_est_1A,rx_H_est_1B,...
    rx_H_est_1C,rx_H_est_1D] = ...
    packet_detection_and_channel_estimation(lts_t,rx_vec_air_1A,N_OFDM_SYMS,CP_LEN,N_SC,rx_vec_air_1B,rx_vec_air_1C,rx_vec_air_1D,rx_vec_air_AA,sts_t,lts_f,LTS_CORR_THRESH,DO_APPLY_CFO_CORRECTION);

%% Extract the payload samples (integral number of OFDM symbols following preamble)

% case 2 (MIMO 1x4) including case 1 (MIMO 1x2)

payload_mat_1A=rx_dec_cfo_corr_1A(30*length(sts_t)+(2.5+3)*length(lts_t)+1:30*length(sts_t)+(2.5+3)*length(lts_t)+N_OFDM_SYMS*(N_SC+CP_LEN));
payload_mat_1B=rx_dec_cfo_corr_1B(30*length(sts_t)+(2.5+3)*length(lts_t)+1:30*length(sts_t)+(2.5+3)*length(lts_t)+N_OFDM_SYMS*(N_SC+CP_LEN));
payload_mat_1C=rx_dec_cfo_corr_1C(30*length(sts_t)+(2.5+3)*length(lts_t)+1:30*length(sts_t)+(2.5+3)*length(lts_t)+N_OFDM_SYMS*(N_SC+CP_LEN));
payload_mat_1D=rx_dec_cfo_corr_1D(30*length(sts_t)+(2.5+3)*length(lts_t)+1:30*length(sts_t)+(2.5+3)*length(lts_t)+N_OFDM_SYMS*(N_SC+CP_LEN));

payload_mat_1A=reshape(payload_mat_1A,(N_SC+CP_LEN),N_OFDM_SYMS);
payload_mat_1B=reshape(payload_mat_1B,(N_SC+CP_LEN),N_OFDM_SYMS);
payload_mat_1C=reshape(payload_mat_1C,(N_SC+CP_LEN),N_OFDM_SYMS);
payload_mat_1D=reshape(payload_mat_1D,(N_SC+CP_LEN),N_OFDM_SYMS);


% case 3 (MIMO 2x1)

payload_mat_AA=rx_dec_cfo_corr_AA(30*length(sts_t)+(2.5+3)*length(lts_t)+1:30*length(sts_t)+(2.5+3)*length(lts_t)+N_OFDM_SYMS*(N_SC+CP_LEN));

payload_mat_AA=reshape(payload_mat_AA,(N_SC+CP_LEN),N_OFDM_SYMS);


%% Remove the cyclic prefix

% case 2 (MIMO 1x4) including case 1 (MIMO 1x2)
payload_mat_noCP_1A = payload_mat_1A(CP_LEN+(1:N_SC), :);
payload_mat_noCP_1B = payload_mat_1B(CP_LEN+(1:N_SC), :);
payload_mat_noCP_1C = payload_mat_1C(CP_LEN+(1:N_SC), :);
payload_mat_noCP_1D = payload_mat_1D(CP_LEN+(1:N_SC), :);
% case 3 (MIMO 2x1)
payload_mat_noCP_AA = payload_mat_AA(CP_LEN+(1:N_SC), :);

%% Take the FFT

% case 2 (MIMO 1x4) including case 1 (MIMO 1x2)
syms_f_mat_1A = fft(payload_mat_noCP_1A, N_SC, 1);
syms_f_mat_1B = fft(payload_mat_noCP_1B, N_SC, 1);
syms_f_mat_1C = fft(payload_mat_noCP_1C, N_SC, 1);
syms_f_mat_1D = fft(payload_mat_noCP_1D, N_SC, 1);

% case 3 (MIMO 2x1)
syms_f_mat_AA = fft(payload_mat_noCP_AA, N_SC, 1);


%% Combine received signals
if(USE_CHANNEL_ESTIMATES)
    [syms_eq_mat_pilots_case1,syms_eq_mat_pilots_case2,syms_eq_mat_pilots_case3] = ...
        mimo_processing(rx_H_est_1A,rx_H_est_1B,rx_H_est_1C,rx_H_est_1D,...
        syms_f_mat_1A,syms_f_mat_1B,syms_f_mat_1C,syms_f_mat_1D,syms_f_mat_AA);
else
    [syms_eq_mat_pilots_case1,syms_eq_mat_pilots_case2,syms_eq_mat_pilots_case3] = ...
        mimo_processing(h1A,h1B,h1C,h1D,...
        syms_f_mat_1A,syms_f_mat_1B,syms_f_mat_1C,syms_f_mat_1D,syms_f_mat_AA);
end

% Extract data
% case 1 (MIMO 1x2)
payload_syms_mat_1 = syms_eq_mat_pilots_case1(SC_IND_DATA, :);
rx_syms_case_1 = payload_syms_mat_1(:);

% case 2 (MIMO 1x4)
payload_syms_mat_2 = syms_eq_mat_pilots_case2(SC_IND_DATA, :);
rx_syms_case_2 = payload_syms_mat_2(:);

% case 3 (MIMO 2x1)
payload_syms_mat_AA = syms_eq_mat_pilots_case3(SC_IND_DATA, :);
rx_syms_case_AA = payload_syms_mat_AA(:);

% Demodulation
rx_data_final_1 = qamdemod(rx_syms_case_1, MOD_ORDER, 'OutputType', 'integer'); % Demodulate the signal
rx_data_final_2 = qamdemod(rx_syms_case_2, MOD_ORDER, 'OutputType', 'integer'); % Demodulate the signal
rx_data_final_AA = qamdemod(rx_syms_case_AA, MOD_ORDER, 'OutputType', 'integer'); % Demodulate the signal

% rx_data is the final output corresponding to tx_data, which can be used
% to calculate BER
[~,ber1] = biterr(tx_data,rx_data_final_1);
[~,ber2] = biterr(tx_data,rx_data_final_2);
[~,ber3] = biterr(tx_data,rx_data_final_AA);

end