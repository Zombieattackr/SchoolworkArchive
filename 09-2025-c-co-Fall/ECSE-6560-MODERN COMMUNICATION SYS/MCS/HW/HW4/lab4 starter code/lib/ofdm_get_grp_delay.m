function [group_delay_ns] = ofdm_get_grp_delay(channel_in,ofdm_params)
%OFDM_GET_GRP_DELAY Estimate group delay from given channel and given ofdm
%parameters. Returns group delay in ns

assert(size(channel_in,2)==1,"Expected channel_in to be a column vector");

% replace unused subcarriers with nan
temp_filled_backup = channel_in(ofdm_params.FILLED_SC_IND);
channel_in(:)  = nan;
channel_in(ofdm_params.FILLED_SC_IND) = temp_filled_backup;
% fftshift
channel_in_fft_shift = fftshift(channel_in);
% unwrap
channel_angle_unwr = unwrap(angle(channel_in_fft_shift));

% extract values
TF = ~isnan(channel_angle_unwr);
indcs = find(TF);

p = polyfit(indcs,channel_angle_unwr(TF),1);

subc_spacing = ofdm_params.SAMP_FREQ/ofdm_params.N_SC;
group_delay_ns = p(1)/(-2*pi*subc_spacing)*1e9;

end

