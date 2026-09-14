function [rx_vec_cfo_corr,params] = rx_cfo_correction(raw_rx_dec,lts_ind,params)
lts_ind_range = 1.5*params.N_SC+1:2.5*params.N_SC; % 97:160 for N_SC=64
if(params.DO_APPLY_CFO_CORRECTION)
    %Extract LTS (not yet CFO corrected)
    rx_lts = raw_rx_dec(lts_ind : lts_ind+2.5*params.N_SC-1);
    rx_lts1 = rx_lts(-params.N_SC+-params.FFT_OFFSET + lts_ind_range);
    rx_lts2 = rx_lts(-params.FFT_OFFSET + lts_ind_range);
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Complete this section        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Calculate CFO estimation from rx_lts1 and rx_lts2
    % useful MATLAB function: xcorr() angle()
    % note the number of sub-carriers is params.N_SC
    rx_cfo_est_lts = 

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    rx_cfo_est_lts = 0;
end
params.rx_cfo_est_lts = rx_cfo_est_lts;
% Apply CFO correction to raw Rx waveform
rx_cfo_corr_t = exp(-1i*2*pi*rx_cfo_est_lts*(0:length(raw_rx_dec)-1));
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Complete this section        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the raw Rx waveform is raw_rx_dec(:)
rx_vec_cfo_corr = 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end