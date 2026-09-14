function [tx_vec_air_AA, tx_vec_air_BA] = tx_precoding(tx_vec_air_A, tx_vec_air_B, h1A, h1B)
% MRT precoding (time-domain scalar-channel version)

% If channels are scalars, perform simple MRT scaling:
if isscalar(h1A) && isscalar(h1B)
    % weight by conj(channel)
    wA = conj(h1A);
    wB = conj(h1B);
    % normalize so total Tx power remains same
    normFactor = sqrt(abs(wA)^2 + abs(wB)^2);
    if normFactor == 0
        wA = 1; wB = 0; normFactor = 1;
    end
    wA = wA / normFactor;
    wB = wB / normFactor;
    tx_vec_air_AA = wA .* tx_vec_air_A;
    tx_vec_air_BA = wB .* tx_vec_air_B;
else
    % Fallback: if not scalars, just pass through
    tx_vec_air_AA = tx_vec_air_A;
    tx_vec_air_BA = tx_vec_air_B;
end
end
