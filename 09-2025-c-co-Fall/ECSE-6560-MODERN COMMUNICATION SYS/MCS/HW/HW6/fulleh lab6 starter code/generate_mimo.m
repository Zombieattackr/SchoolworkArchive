function [tx_vec_air_A]=generate_mimo(preamble_A,tx_payload_vec_A,TX_SCALE,CFO_FLAG)

% Construct the full time-domain OFDM waveform
tx_vec_A = [preamble_A tx_payload_vec_A];

% Pad with zeros for transmission
tx_vec_air_A = [tx_vec_A zeros(1,50)];

% Scale the Tx vector to +/- 1
tx_vec_air_A = TX_SCALE .* tx_vec_air_A ./ rms(tx_vec_air_A);

% to enable CFO make CFO_FLAG=1
if(CFO_FLAG)
    tx_vec_air_A = tx_vec_air_A .* exp(-1i*2*pi*1e-4*(0:length(tx_vec_air_A)-1));
end

end
