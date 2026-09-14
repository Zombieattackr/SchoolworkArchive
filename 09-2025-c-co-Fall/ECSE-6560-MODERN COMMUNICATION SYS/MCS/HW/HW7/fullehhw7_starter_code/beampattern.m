function P_theta_dB = beampattern(d_list, idx, N, k, theta0_rad, theta_rad)
% Inputs:
% d_list - vector of spacings (units of lambda, or absolute depending)
% idx - index into d_list for the spacing to evaluate
% N - number of antennas
% k - wavenumber (2*pi / lambda)
% theta0_rad - desired steering angle (radians)
% theta_rad - vector of angles to evaluate (radians)

% Output:
% P_theta_dB - 1 x length(theta_rad) vector: normalized beam pattern in dB

% select spacing
d = d_list(idx);

% construct steering vector for theta0 (column vector of length N)
n = (0:(N-1)).'; % element indices as column
a_theta0 = exp(-1j * k * d * n * cos(theta0_rad)); % Nx1

% compute inner product h^H * a(theta) for each theta
h = a_theta0;

% Preallocate
P = zeros(1, numel(theta_rad));

% compute pattern across theta grid
for ii = 1:numel(theta_rad)
    at = exp(-1j * k * d * n * cos(theta_rad(ii))); % Nx1
    % beamformer response (matched to h)
    resp = h' * at; % scalar (1x1 complex)
    P(ii) = abs(resp)^2; % power
end

% normalize to max = 1
P = P / max(P);

% convert to dB
P_theta_dB = 10*log10(P + eps); % add eps for numerical safety

end
