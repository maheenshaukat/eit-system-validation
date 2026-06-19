% ==========================================================
% Author: Maheen Shaukat
% Project: Low-Cost EIT System Validation
% Date: 2025
% ==========================================================
clear; clc; close all;

% -------------------------------------------------------
% Step 1: Load CSV Data
% -------------------------------------------------------
data     = readmatrix('C:\Users\mahee_xmhrgt1\Downloads\data\eit_reading.csv');
voltages = data(:, 3);   % adjust column index if needed

disp('CSV loaded.');
disp(['Measurements in CSV: ', num2str(length(voltages))]);

% -------------------------------------------------------
% Step 2: Build 2D Circular FEM Model (16 electrodes)
% mk_circ_tank(n_rings, z_planes, n_electrodes)
% Leaving z_planes empty [] forces a 2D model
% -------------------------------------------------------
n_elec = 16;
fmdl   = mk_circ_tank(8, [], n_elec);

% -------------------------------------------------------
% Step 3: Define Adjacent-Drive Stimulation Pattern
% '{ad}' = adjacent drive (inject E1-E2, E2-E3, ... E16-E1)
% '{ad}' = adjacent measurement
% 'no_meas_current' = skip measuring on injecting electrodes
% amplitude = 1 (arbitrary units — scales with your current)
% -------------------------------------------------------
stim_pat = mk_stim_patterns(n_elec, 1, '{ad}', '{ad}', ...
                             {'no_meas_current'}, 1);
fmdl.stimulation = stim_pat;

% -------------------------------------------------------
% Step 4: Homogeneous Background Image
% -------------------------------------------------------
sigma_hom = 1.0;
img_hom   = mk_image(fmdl, sigma_hom);

% -------------------------------------------------------
% Step 5: Visualize FEM Mesh
% -------------------------------------------------------
figure;
show_fem(fmdl);
title('FEM Mesh — 16-Electrode 2D Circular Phantom');

% -------------------------------------------------------
% Step 6: Solve Forward Problem (Simulated Reference)
% This gives the expected measurement count for stim pattern
% -------------------------------------------------------
vh_ref     = fwd_solve(img_hom);
n_expected = length(vh_ref.meas);
n_loaded   = length(voltages);

disp(['EIDORS expects : ', num2str(n_expected), ' measurements.']);
disp(['Your CSV has   : ', num2str(n_loaded),   ' measurements.']);

% -------------------------------------------------------
% Step 7: Handle Measurement Count Mismatch
% Adjacent drive, no_meas_current, 16 electrodes → 208 measurements
% hardware (16 × 14) → 224 measurements
% Trimming is safe for homogeneous baseline reconstruction
% -------------------------------------------------------
if n_loaded == n_expected
    vh_meas = voltages;
    disp('Count matches. No trimming needed.');

elseif n_loaded > n_expected
    warning('Trimming CSV to first %d values.', n_expected);
    vh_meas = voltages(1:n_expected);

else
    error(['CSV has fewer measurements (%d) than expected (%d).\n' ...
           'Check stim pattern or CSV export from Arduino.'], ...
           n_loaded, n_expected);
end

% Insert real voltages into EIDORS reference structure
vh_real      = vh_ref;
vh_real.meas = vh_meas;
disp('Real voltages inserted into EIDORS structure.');

% -------------------------------------------------------
% Step 8: Build Inverse Model
% -------------------------------------------------------
inv_mdl = struct();
inv_mdl.name                 = 'EIT Inverse Model';
inv_mdl.reconst_type         = 'difference';
inv_mdl.fwd_model            = fmdl;
inv_mdl.solve                = @inv_solve_diff_GN_one_step;
inv_mdl.RtR_prior            = @prior_laplace;
inv_mdl.hyperparameter.value = 0.01;
inv_mdl.jacobian_bkgnd       = img_hom;        % ← ADD THIS LINE
inv_mdl = eidors_obj('inv_model', inv_mdl);
% -------------------------------------------------------
% Step 9: Reconstruct Image
% inv_solve(inv_model, reference_data, measured_data)
% -------------------------------------------------------
vh_ref_meas        = vh_ref;
vh_ref_meas.meas   = vh_meas;   % use your own measured data as reference
img_rec = inv_solve(inv_mdl, vh_ref_meas, vh_real);

% -------------------------------------------------------
% Step 10: Display Results
% -------------------------------------------------------
figure;
show_fem(img_rec);
title('Reconstructed \DeltaConductivity — Real Measured Data');
colorbar;

figure;
plot(vh_meas, 'b-', 'LineWidth', 1.5); hold on;
plot(vh_ref.meas, 'r--', 'LineWidth', 1.2);
xlabel('Measurement Index');
ylabel('Voltage (V)');
title('Boundary Voltages: Measured vs Simulated Reference');
legend('Measured (Real)', 'Simulated (Homogeneous)');
grid on; hold off;

% -------------------------------------------------------
% Step 11: Save Outputs
% -------------------------------------------------------
saveas(gcf, 'Measured_Voltage_Comparison.png');

figure;
show_fem(img_rec);
title('EIT Reconstructed Conductivity Map');
colorbar;
saveas(gcf, 'EIT_Reconstruction_RealData.png');

writematrix(img_rec.elem_data, 'Reconstructed_Conductivity_Data.csv');

disp('Saved: Measured_Voltage_Comparison.png');
disp('Saved: EIT_Reconstruction_RealData.png');
disp('Saved: Reconstructed_Conductivity_Data.csv');