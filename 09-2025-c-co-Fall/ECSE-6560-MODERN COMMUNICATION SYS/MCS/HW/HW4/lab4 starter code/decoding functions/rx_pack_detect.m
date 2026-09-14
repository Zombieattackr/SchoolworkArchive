function [lts_ind,params] = rx_pack_detect(raw_rx_dec,params)

if(~isfield(params,'max_len_to_check'))
    params.max_len_to_check = min(40000,length(raw_rx_dec));
else
    params.max_len_to_check = min(params.max_len_to_check, length(raw_rx_dec));
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Complete this section        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Complex cross correlation of Rx waveform with time-domain LTS
    % use conv() function to compute the running cross correlation between 
    % LTS in time domain, params.lts_t, and the received samples, raw_rx_dec
lts_corr = % this should be an array of running cross correlation

% Skip early and late params.N_SC/2 samples - avoids occasional false positives from pre-AGC samples
lts_corr = 

% Shorten the sampled array to avoid exceeding params.max_len_to_check 
lts_corr = 

% Find all correlation peaks, given the threshold params.LTS_CORR_THRESH*max(lts_corr)
lts_peaks = % use find() function, which returns a Boolean array indicating the peaks

% Select best candidate correlation peak as LTS-payload boundary, 
    % i.e., there should be exactly a LTS length between the selected 2 peaks
lts_second_peak_index = % this is the index of the latter selected peak


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set a random value if no valid correlation peak was found
if(isempty(lts_second_peak_index))
    fprintf('No LTS Correlation Peaks Found!\n');
    lts_ind = -1;
    return;
end


% Set the sample indices of the payload symbols and preamble
payload_ind = lts_peaks(min(lts_second_peak_index)) + params.N_SC/2;
lts_ind = payload_ind-2.5*params.N_SC;

cur_sec_peak_ind = 2;
while(lts_ind<=0)
    payload_ind = lts_peaks(lts_second_peak_index(cur_sec_peak_ind)) + params.N_SC/2;
    lts_ind = payload_ind-2.5*params.N_SC;
    cur_sec_peak_ind = cur_sec_peak_ind+1;
end
% Rx LTS correlation
if(isfield(params,'force_lts_ind'))
    lts_ind = params.force_lts_ind;    
end
params.lts_ind = lts_ind;

if(params.plot_flag)
    figure(params.cf);clf;
    params.cf = params.cf+1;
    lts_to_plot = lts_corr(1:params.max_len_to_check);
    plot(lts_to_plot, '.-b', 'LineWidth', 1);
    hold on;
    grid on;
    line([1 length(lts_to_plot)], params.LTS_CORR_THRESH*max(lts_to_plot)*[1 1], 'LineStyle', '--', 'Color', 'r', 'LineWidth', 2);
    title('LTS Correlation and Threshold')
    xlabel('Sample Index')
    myAxis = axis();
    axis([1, params.max_len_to_check, myAxis(3), myAxis(4)]);
end
end
