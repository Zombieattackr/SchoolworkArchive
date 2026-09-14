function [tx_vec_cfo_mat] = add_cfo(input_mat, cfo)
%ADD_CFO Adds cfo to input signal (cfo is normalized frequency)
%   Detailed explanation goes here
    n_dim = size(input_mat);
    if(n_dim(1)>n_dim(2))
        error('wcsng_ofdm_lib: add_cfo: Oops, please send in a matrix with each signal along a row.');
    end
    tx_vec_cfo_mat = input_mat .* exp(-1i*2*pi*cfo*[0:n_dim(2)-1]);
end