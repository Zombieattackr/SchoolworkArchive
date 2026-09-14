function [tx_vec_air,params] = ofdm_tx(params)
%OFDM_TX OFDM Tx samples generation using warplab inspired code.
%Generalized to any number of subcarriers
%  TODO
params.N_DATA_SYMS  = params.N_OFDM_SYMS * length(params.SC_IND_DATA);

sts_t = params.sts_t;
lts_t = params.lts_t;

% Configurable copies of STS, 2.5 Copies of LTS
preamble = [repmat(sts_t, 1, params.N_STS)  lts_t((params.N_SC/2+1):params.N_SC) lts_t lts_t];

params.preamble = preamble;

%% Generate a payload of random integers
if(isfield(params, 'tx_data'))
    assert(size(params.tx_data , 2) == 1, 'params.tx_data is not a column vector');
    assert(size(params.tx_data , 1) == params.N_DATA_IND*params.N_OFDM_SYMS, 'params.tx_data size doesn"t match N_DATA_INDxN_OFDM_SYMS' );
    assert(params.tx_data(1)==0 | params.tx_data(1)==1)
    inSig = reshape(params.tx_data, params.N_DATA_IND, params.N_OFDM_SYMS);
else
    inSig = randi([0 params.MOD_ORDER-1],params.N_DATA_IND,params.N_OFDM_SYMS);
    params.tx_data = inSig(:);
end
tx_syms_mat = qammod(inSig,params.MOD_ORDER,'UnitAveragePower',true);
params.tx_syms_mat = tx_syms_mat;

% Define the pilot tone values as BPSK symbols
pilots = params.pilots;

% Repeat the pilots across all OFDM symbols
% pilots_mat = repmat(pilots, 1, params.N_OFDM_SYMS);
% Using Random pilots to prevent formation of spectral lines
pilots_mat = 2*randi([0 1],[length(pilots),params.N_OFDM_SYMS])-1;
params.pilots_mat = pilots_mat;

%% IFFT
% Construct the IFFT input matrix
ifft_in_mat = zeros(params.N_SC, params.N_OFDM_SYMS);

% Insert the data and pilot values; other subcarriers will remain at 0
ifft_in_mat(params.SC_IND_DATA, :)   = tx_syms_mat;
ifft_in_mat(params.SC_IND_PILOTS, :) = pilots_mat;

%Perform the IFFT
tx_payload_mat = ifft(ifft_in_mat, params.N_SC, 1);

% Insert the cyclic prefix
if(params.CP_LEN > 0)
    tx_cp = tx_payload_mat((end-params.CP_LEN+1 : end), :);
    tx_payload_mat = [tx_cp; tx_payload_mat];
end

% Reshape to a vector
tx_payload_vec = reshape(tx_payload_mat, 1, numel(tx_payload_mat));
params.tx_payload_vec = tx_payload_vec;

% Construct the full time-domain OFDM waveform
tx_vec = [preamble tx_payload_vec];

% Pad with zeros if required
tx_vec_padded = [tx_vec, zeros(1, params.N_ZERO_PAD)];
tx_vec_air = tx_vec_padded;

% Scale the Tx vector to +/- 1
if(isfield(params,'TX_SCALE_FLAG') && params.TX_SCALE_FLAG==0)
    %Don't scale
else
    tx_vec_air = params.TX_SCALE .* tx_vec_air ./ max(abs(tx_vec_air));
end
params.TX_NUM_SAMPS = length(tx_vec_air);
tx_vec_air = tx_vec_air.'; % We deal with columns everywhere else



% Tx signal
if(params.plot_flag)
    figure(params.cf); clf;

    subplot(2,1,1);
    plot(real(tx_vec_air), 'b');
    axis([0 length(tx_vec_air) -params.TX_SCALE params.TX_SCALE])
    sp1 = gca;
    grid on;
    title('Tx Waveform (I)');

    subplot(2,1,2);
    plot(imag(tx_vec_air), 'r');
    axis([0 length(tx_vec_air) -params.TX_SCALE params.TX_SCALE])
    sp2 = gca;
    grid on;
    title('Tx Waveform (Q)');
    
    linkaxes([sp1 sp2],'x');

    if(params.WRITE_PNG_FILES)
        print(gcf,sprintf('wl_ofdm_plots_%s_txIQ', params.example_mode_string), '-dpng', '-r96', '-painters')
    end
end

end
