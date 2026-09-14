function [syms_eq_pc_mat,param] = rx_sfo_and_phase_error_correction(syms_eq_mat,param)
% After channel estimation run this function to apply SFO and phase
% correction

% Extract the pilot tones and "equalize" them by their nominal Tx values
pilots_f_mat = syms_eq_mat(param.SC_IND_PILOTS, :);
pilots_f_mat_comp = pilots_f_mat.*param.pilots_mat;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Complete this section        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the phases of every Rx pilot tone
% You need to implement the following:
% 1) apply fftshift for each column of pilots_f_mat_comp
% 2) get phase angle by MATALB function angle()
% 3) Normalize with MATLAB function unwrap() for each column (OFDM symbol)
pilot_phases = % this should be a matrix, with each column the phases of the pilots in an OFDM symbol

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if param.DO_APPLY_SFO_CORRECTION
    % SFO manifests as a frequency-dependent phase whose slope increases
    % over time as the Tx and Rx sample streams drift apart from one
    % another. To correct for this effect, we calculate this phase slope at
    % each OFDM symbol using the pilot tones and use this slope to
    % interpolate a phase correction for each data-bearing subcarrier.
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Complete this section        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate slope of pilot tone phases vs frequency in each OFDM symbol
    pilot_spacing_mat = repmat(mod(diff(fftshift(param.SC_IND_PILOTS)),param.N_SC).', 1, param.N_OFDM_SYMS);
    % calculate the slope for each column of pilot_phases
    param.pilot_slope_mat = 

    % Calculate the SFO correction phases for each OFDM symbol
    pilot_phase_sfo_corr = fftshift((-(param.N_SC/2):(param.N_SC/2-1)).' * param.pilot_slope_mat, 1);
    pilot_phase_corr_sfo = exp(-1i*(pilot_phase_sfo_corr));

    % Apply the pilot phase correction per symbol
    syms_eq_mat_sfo = 

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    % Define an empty SFO correction matrix (used by plotting code below)
    pilot_phase_sfo_corr = zeros(param.N_SC, param.N_OFDM_SYMS);
    syms_eq_mat_sfo = syms_eq_mat;
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Complete this section        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract the pilots and calculate per-symbol phase error
pilots_f_mat = syms_eq_mat_sfo(param.SC_IND_PILOTS, :);
pilots_f_mat_comp_err = pilots_f_mat.*param.pilots_mat;
if param.DO_APPLY_PHASE_ERR_CORRECTION
    % the phase error is estimated as the phase of the mean of pilots_f_mat_comp_err
    pilot_phase_err = 
else
    % Define an empty phase correction vector (used by plotting code below)
    pilot_phase_err = zeros(1, param.N_OFDM_SYMS);
end
pilot_phase_err_corr = repmat(pilot_phase_err, param.N_SC, 1);
pilot_phase_corr = exp(-1i*(pilot_phase_err_corr));

param.pilot_phase_err=pilot_phase_err;
% Apply the pilot phase correction per symbol
syms_eq_pc_mat = 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% --plot SFO
if(param.plot_flag)
    %%
    freq_axis = ((-(param.N_SC/2):(param.N_SC/2-1)).');
    aa = fftshift(1:param.N_SC);
    for ii = 1:length(param.SC_IND_PILOTS)
        idx = find(aa ==param.SC_IND_PILOTS(ii) );
        pilot_axis(ii) = freq_axis(idx);
    end
    [pilot_axis_sort, sortidx] = sort(pilot_axis);
    figure(23); clf;
    tiledlayout(2,1);
    %     nexttile;
    %     plot((param.SC_IND_PILOTS),pilot_phases, 'o--'  )
    %     xlabel('Pilot index')
    %     ylabel('Phase Radians')
    %     title('Pilots per packet after phase compensation')

    nexttile;
    for ii = 1:min(param.N_OFDM_SYMS,2)
        plot(freq_axis,fftshift(pilot_phase_sfo_corr(:,ii)))
        hold on; grid on;
    end

    set(gca,'ColorOrderIndex',1)
    for ii = 1:min(param.N_OFDM_SYMS,2)
        plot(pilot_axis_sort,pilot_phases(:,ii), 'o--'  )
    end
    ylabel('Phase radians')
    xlabel('Freq subcarriers idx')
    title('SFO corr: Solid Line-Modeled, Broken Line-Actual')

    nexttile;
    set(gca,'ColorOrderIndex',1)
    for ii = 1:min(param.N_OFDM_SYMS,2)
        plot(freq_axis, pilot_phase_err_corr(:,ii))
        hold on; grid on;
    end

    set(gca,'ColorOrderIndex',1)
    for ii = 1:min(param.N_OFDM_SYMS,2)
        plot(pilot_axis_sort, fftshift(angle(pilots_f_mat_comp_err(:,ii))), 'o--')
    end
    ylabel('Phase radians')
    xlabel('Freq subcarriers idx')
    title('Phase corr: Solid Line-Modeled, Broken Line-Actual')
end

end