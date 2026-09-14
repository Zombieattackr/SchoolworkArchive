function h = set_channel()
% this function genrate discrete LTI channel impulse response h

% Multipath channel (discrete-time tapped delay line) 
% delays in samples, complex gains
tap_delays = [0 2 5 9 13];  
tap_gains  = [1.0 0.6 0.4 0.25 0.15] .* exp(1j*2*pi*[0.00 0.11 -0.27 0.37 -0.41]);
tap_gains  = tap_gains / sqrt(sum(abs(tap_gains).^2)); % normalize power to 1

% Build discrete LTI channel impulse response h (length Lh = max delay +1)
Lh = max(tap_delays) + 1;
h  = zeros(Lh,1);
h(tap_delays + 1) = tap_gains;