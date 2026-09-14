function [syms_eq_mat_pilots_case1, syms_eq_mat_pilots_case2, syms_eq_mat_pilots_case3] = ...
    mimo_processing(h1A_in,h1B_in,h1C_in,h1D_in, syms_f_mat_1A, syms_f_mat_1B, syms_f_mat_1C, syms_f_mat_1D, syms_f_mat_AA)
% MIMO combining

% Determine if inputs are scalars or frequency vectors
if isscalar(h1A_in)
    % broadcast scalars to per-subcarrier form
    [N_SC, ~] = size(syms_f_mat_1A);
    h1A = h1A_in * ones(N_SC,1);
    h1B = h1B_in * ones(N_SC,1);
    h1C = h1C_in * ones(N_SC,1);
    h1D = h1D_in * ones(N_SC,1);
else
    % Frequency-domain channel estimates (vectors)
    h1A = h1A_in(:); h1B = h1B_in(:); h1C = h1C_in(:); h1D = h1D_in(:);
    N_SC = length(h1A);
end

% Case 1: 1x2 MIMO 
denom12 = (abs(h1A).^2 + abs(h1B).^2);
denom12(denom12==0) = 1; % avoid divide by zero
% expand to matrices for elementwise ops
denom12_mat = repmat(denom12,1,size(syms_f_mat_1A,2));
syms_eq_mat_pilots_case1 = (conj(repmat(h1A,1,size(syms_f_mat_1A,2))).*syms_f_mat_1A + ...
                           conj(repmat(h1B,1,size(syms_f_mat_1B,2))).*syms_f_mat_1B) ./ denom12_mat;

% Case 2: 1x4 MIMO
denom14 = (abs(h1A).^2 + abs(h1B).^2 + abs(h1C).^2 + abs(h1D).^2);
denom14(denom14==0) = 1;
denom14_mat = repmat(denom14,1,size(syms_f_mat_1A,2));
syms_eq_mat_pilots_case2 = (conj(repmat(h1A,1,size(syms_f_mat_1A,2))).*syms_f_mat_1A + ...
                           conj(repmat(h1B,1,size(syms_f_mat_1B,2))).*syms_f_mat_1B + ...
                           conj(repmat(h1C,1,size(syms_f_mat_1C,2))).*syms_f_mat_1C + ...
                           conj(repmat(h1D,1,size(syms_f_mat_1D,2))).*syms_f_mat_1D) ./ denom14_mat;

% Case 3: 2x1 MIMO
h_eff = sqrt(abs(h1A).^2 + abs(h1B).^2);
h_eff(h_eff==0) = 1;
h_eff_mat = repmat(h_eff,1,size(syms_f_mat_AA,2));
syms_eq_mat_pilots_case3 = syms_f_mat_AA ./ h_eff_mat;

end
