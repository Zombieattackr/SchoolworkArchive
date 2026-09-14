function [rx_H_est,params] = rx_channel_estimation(rx_vec_cfo_corr,lts_ind,params)

lts_ind_range = 1.5*params.N_SC+1:2.5*params.N_SC; % 97:160 for number of sub-carriers N_SC=64

% Reextract LTS of CFO corrected signal.
rx_lts = rx_vec_cfo_corr(lts_ind : lts_ind+2.5*params.N_SC-1); 
rx_lts1 = rx_lts(-params.N_SC+-params.FFT_OFFSET + lts_ind_range);
rx_lts2 = rx_lts(-params.FFT_OFFSET + lts_ind_range);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Complete this section        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%take fft for the two LTSs
rx_lts1_f = fft();
rx_lts2_f = fft();

% Calculate channel estimate from average of 2 training symbols
% The original LTS in frequency domain (array with same size) is params.lts_f(:)
rx_H_est = 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SNR estimate: this is better than EVM method and gives ~5db higher SNR
%estimate. 
meanvalue = (rx_lts1_f(:) + rx_lts2_f(:))/2;
varvalue = var([rx_lts1_f(:),rx_lts2_f(:)],0,2);

snrestimate = meanvalue./sqrt(varvalue + 1e-20);
meansnr = mean(db(snrestimate));
params.meansnr= meansnr;

if(params.plot_flag)
    figure(params.cf);clf;
    plot(db(snrestimate),'linewidth',2)
    hold on; yline(meansnr,'r','linewidth',3);
    % plot([1 length(evm_mat(:))], 100*[aevms(1), aevms(1)],'r','LineWidth',4)
    myAxis = axis;
    h = text(round(.05*params.N_SC), meansnr+ .1*(myAxis(4)-myAxis(3)), sprintf('Effective SNR: %.1f dB', meansnr));
    set(h,'Color',[1 0 0])
    set(h,'FontWeight','bold')
    set(h,'FontSize',10)
    set(h,'EdgeColor',[1 0 0])
    set(h,'BackgroundColor',[1 1 1])
    xlabel('subcarrier index'); ylabel('SNR (dB)');
end
end