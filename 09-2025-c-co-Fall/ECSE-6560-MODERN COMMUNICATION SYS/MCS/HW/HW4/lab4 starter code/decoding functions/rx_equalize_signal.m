function syms_eq_mat = rx_equalize_signal(rx_vec_cfo_corr,lts_ind,rx_H_est,param)
% Take entire rx signal, get location of one packet using lts_ind.
% Then take one packet and equalize the signal with channel rx_H_est
% Return the equalized packet syms_eq_mat of size 64x100 for 64subs and
% 100symbols

% number of original samples 8000 = 80*100
tx_num_origsamp = (param.N_SC+param.CP_LEN)*param.N_OFDM_SYMS;

%packet index range: rx_lts+160 to rx_lts+160+8000-1
rx_pkt_range = lts_ind+2.5*param.N_SC:lts_ind+2.5*param.N_SC+tx_num_origsamp-1;

% Extract the received packet (remove preamble as well)
payload_vec = rx_vec_cfo_corr(rx_pkt_range);% lts_ind_n+160)

% Reshape
payload_mat = reshape(payload_vec, (param.N_SC+param.CP_LEN), param.N_OFDM_SYMS);

% Remove the cyclic prefix, keeping FFT_OFFSET samples of CP (on average)
payload_mat_noCP = payload_mat(param.CP_LEN-param.FFT_OFFSET+[1:param.N_SC], :);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Complete this section        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Take the FFT of each column of payload_mat_noCP. 
% Note each column is an OFDM symbol in the packet
% The number of subcarrier is param.N_SC
syms_f_mat = fft();

% Equalize (zero-forcing, just divide by complex channel estimates)
rx_H_est=rx_H_est(:)+1e-6; % channel estimate as column vector with safeguard
% you need to reshape rx_H_est to fit the size of syms_f_mat
syms_eq_mat = syms_f_mat ./ 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end