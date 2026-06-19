% ==========================================================
% EIT NOISE ANALYSIS — Homogeneous Phantom
% 16-Electrode Arduino-Based System
% Metrics: SNR, CV, Reciprocity Error, Contact Uniformity
% ==========================================================
clear; clc; close all;

% -------------------------------------------------------
% Step 1: Load Data
% -------------------------------------------------------
data     = readmatrix('C:\Users\mahee_xmhrgt1\Downloads\data\eit_reading.csv');
voltages = data(:, 3);   % raw voltage column

n_elec   = 16;
n_total  = length(voltages);   % should be 256

fprintf('Total measurements loaded: %d\n', n_total);

% Reshape into 16x16 matrix (injection × sensing)
V = reshape(voltages(1:n_elec^2), n_elec, n_elec);
% Rows = injection electrode index (1–16)
% Cols = sensing electrode index  (1–16)

% -------------------------------------------------------
% Step 2: Basic Signal Statistics
% -------------------------------------------------------
V_mean   = mean(voltages);
V_std    = std(voltages);
V_min    = min(voltages);
V_max    = max(voltages);
CV       = (V_std / V_mean) * 100;          % coefficient of variation (%)
SNR_dB   = 20 * log10(V_mean / V_std);      % SNR in dB

fprintf('\n--- Global Signal Statistics ---\n');
fprintf('Mean Voltage     : %.4f V\n',   V_mean);
fprintf('Std Deviation    : %.4f V\n',   V_std);
fprintf('Min / Max        : %.4f / %.4f V\n', V_min, V_max);
fprintf('Dynamic Range    : %.4f V\n',   V_max - V_min);
fprintf('Coeff. of Variation (CV): %.2f %%\n', CV);
fprintf('SNR              : %.2f dB\n',  SNR_dB);

% -------------------------------------------------------
% Step 3: Per-Electrode SNR and Contact Uniformity
% Each row of V = one injection pair's 16 readings
% -------------------------------------------------------
elec_mean = mean(V, 2);    % mean voltage per injection pair
elec_std  = std(V,  0, 2); % std per injection pair
elec_SNR  = 20 * log10(elec_mean ./ elec_std);
elec_CV   = (elec_std ./ elec_mean) * 100;

fprintf('\n--- Per-Injection-Pair Statistics ---\n');
fprintf('Elec | Mean(V) | Std(V)  | SNR(dB) | CV(%%)\n');
fprintf('-----|---------|---------|---------|------\n');
for i = 1:n_elec
    fprintf('  %2d | %.4f  | %.4f  | %6.2f  | %.2f\n', ...
        i, elec_mean(i), elec_std(i), elec_SNR(i), elec_CV(i));
end

% Flag electrodes with poor contact (CV > 10% threshold)
bad_elec = find(elec_CV > 10);
if isempty(bad_elec)
    fprintf('\nAll electrodes within acceptable CV (<10%%). Good contact.\n');
else
    fprintf('\nPoor contact detected at electrodes: %s\n', num2str(bad_elec'));
end

% -------------------------------------------------------
% Step 4: Reciprocity Error
% By the reciprocity theorem: V(i→j, sense k–l) = V(k→l, sense i–j)
% For a 16×16 matrix: V(i,j) should ≈ V(j,i)
% Reciprocity error = |V(i,j) - V(j,i)| / mean(V) × 100%
% -------------------------------------------------------
V_recip_err  = abs(V - V') ;                         % absolute error matrix
recip_mean   = mean(V_recip_err(:));                 % mean reciprocity error
recip_max    = max(V_recip_err(:));                  % worst case
recip_pct    = (recip_mean / V_mean) * 100;          % as % of signal

fprintf('\n--- Reciprocity Error ---\n');
fprintf('Mean Reciprocity Error : %.4f V  (%.2f %% of signal)\n', ...
         recip_mean, recip_pct);
fprintf('Max  Reciprocity Error : %.4f V\n', recip_max);

% Acceptable threshold: < 1% for good EIT systems
if recip_pct < 1
    fprintf('Reciprocity: GOOD (< 1%%)\n');
elseif recip_pct < 5
    fprintf('Reciprocity: ACCEPTABLE (1–5%%)\n');
else
    fprintf('Reciprocity: POOR (> 5%%) — check electrode contact\n');
end

% -------------------------------------------------------
% Step 5: Noise Floor Estimation
% Diagonal of V matrix = self-measurement (electrode injecting = sensing)
% These should be zero in ideal EIT — their magnitude = noise floor
% -------------------------------------------------------
noise_floor   = diag(V);                         % 16 self-measurement values
noise_floor_V = mean(abs(noise_floor));

fprintf('\n--- Noise Floor (Self-Measurements) ---\n');
fprintf('Mean Noise Floor : %.4f V\n',  noise_floor_V);
fprintf('Noise Floor / Signal : %.2f %%\n', (noise_floor_V/V_mean)*100);

% -------------------------------------------------------
% Step 6: Symmetry Analysis
% Homogeneous phantom should produce a symmetric voltage matrix
% Asymmetry = deviation from expected symmetry
% -------------------------------------------------------
V_sym   = (V + V') / 2;            % perfectly symmetric version
V_asym  = V - V_sym;               % asymmetric component = noise
asym_rms = rms(V_asym(:));

fprintf('\n--- Symmetry Analysis ---\n');
fprintf('RMS Asymmetry : %.4f V  (%.2f %% of signal)\n', ...
         asym_rms, (asym_rms/V_mean)*100);

% -------------------------------------------------------
% Step 7: Plots
% -------------------------------------------------------

% --- Plot 1: Voltage Distribution Histogram ---
figure('Name', 'Voltage Distribution');
histogram(voltages, 30, 'FaceColor', [0.2 0.5 0.8], 'EdgeColor', 'white');
xlabel('Voltage (V)'); ylabel('Count');
title('Measured Voltage Distribution — Homogeneous Phantom');
xline(V_mean, 'r--', 'LineWidth', 2, 'Label', sprintf('Mean = %.3fV', V_mean));
xline(V_mean + V_std, 'g--', 'LineWidth', 1.2, 'Label', '+1\sigma');
xline(V_mean - V_std, 'g--', 'LineWidth', 1.2, 'Label', '-1\sigma');
grid on;
saveas(gcf, 'Noise_VoltageDistribution.png');

% --- Plot 2: 16×16 Voltage Matrix Heatmap ---
figure('Name', 'Voltage Matrix');
imagesc(V);
colormap(jet); colorbar;
xlabel('Sensing Electrode'); ylabel('Injection Electrode');
title('Measured Voltage Matrix V_{ij} (V)');
xticks(1:n_elec); yticks(1:n_elec);
axis square;
saveas(gcf, 'Noise_VoltageMatrix.png');

% --- Plot 3: Reciprocity Error Matrix ---
figure('Name', 'Reciprocity Error');
imagesc(V_recip_err * 1000);   % convert to mV
colormap(hot); colorbar;
xlabel('Electrode j'); ylabel('Electrode i');
title(sprintf('Reciprocity Error |V_{ij} - V_{ji}| (mV) — Mean = %.2f%%', recip_pct));
xticks(1:n_elec); yticks(1:n_elec);
axis square;
saveas(gcf, 'Noise_ReciprocityError.png');

% --- Plot 4: Per-Electrode SNR ---
figure('Name', 'Per-Electrode SNR');
bar(1:n_elec, elec_SNR, 'FaceColor', [0.3 0.7 0.4]);
xlabel('Injection Electrode Pair');
ylabel('SNR (dB)');
title('Per-Electrode SNR — Contact Quality Assessment');
yline(mean(elec_SNR), 'r--', 'LineWidth', 1.5, ...
      'Label', sprintf('Mean = %.1f dB', mean(elec_SNR)));
grid on;
saveas(gcf, 'Noise_PerElectrodeSNR.png');

% --- Plot 5: CV per Electrode ---
figure('Name', 'Coefficient of Variation');
bar(1:n_elec, elec_CV, 'FaceColor', [0.8 0.4 0.2]);
xlabel('Injection Electrode Pair');
ylabel('CV (%)');
title('Coefficient of Variation per Electrode Pair');
yline(10, 'r--', 'LineWidth', 1.5, 'Label', '10% threshold');
grid on;
saveas(gcf, 'Noise_CV_PerElectrode.png');

% --- Plot 6: Asymmetry Matrix ---
figure('Name', 'Asymmetry');
imagesc(abs(V_asym) * 1000);
colormap(parula); colorbar;
xlabel('Electrode j'); ylabel('Electrode i');
title('Voltage Asymmetry |V_{ij} - V_{ji}|/2 (mV)');
axis square;
saveas(gcf, 'Noise_Asymmetry.png');

% -------------------------------------------------------
% Step 8: Export Summary Table
% -------------------------------------------------------
summary = table((1:n_elec)', elec_mean, elec_std, elec_SNR, elec_CV, ...
    'VariableNames', {'Electrode','Mean_V','Std_V','SNR_dB','CV_pct'});
writetable(summary, 'Noise_Summary_PerElectrode.csv');

fprintf('\n--- Saved Outputs ---\n');
fprintf('Noise_VoltageDistribution.png\n');
fprintf('Noise_VoltageMatrix.png\n');
fprintf('Noise_ReciprocityError.png\n');
fprintf('Noise_PerElectrodeSNR.png\n');
fprintf('Noise_CV_PerElectrode.png\n');
fprintf('Noise_Asymmetry.png\n');
fprintf('Noise_Summary_PerElectrode.csv\n');
fprintf('\nNoise analysis complete.\n');