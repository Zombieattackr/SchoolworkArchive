function op_struct=rx_demodulation(pidx,op_struct,params)
% Here we learn to use MATLAB built-in function qamdemod
% Input signal: op_struct.rx_syms(:,pidx)
% Modulation order: params.MOD_ORDER
% We want to have UnitAveragePower

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Complete this section        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
op_struct.rx_data(:,pidx) = qamdemod();

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end