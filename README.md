# Low-Cost Electrical Impedance Tomography System Validation
> Experimental validation of a low-cost 16-electrode Electrical Impedance Tomography (EIT) system using homogeneous phantom measurements and FEM-based reconstruction.
![MATLAB](https://img.shields.io/badge/MATLAB-R2023a-orange)
![EIDORS](https://img.shields.io/badge/EIDORS-v3.12-blue)
![Status](https://img.shields.io/badge/status-active_success-success)
![License](https://img.shields.io/badge/license-MIT-green)
## Overview

This work aims to experimentally validate a low-cost Electrical Impedance Tomography (EIT) system for biomedical imaging applications and evaluate reconstruction stability using FEM-based inverse modeling and signal processing techniques.

The system integrates:
- Arduino-based sinusoidal excitation
- 16-channel multiplexer switching
- Circular stainless steel electrodes 
- FEM-based reconstruction using EIDORS
- Signal processing and noise analysis in MATLAB
---
## Experimental Setup
The experimental setup consists of:
- Arduino-generated sinusoidal excitation
- Breadboard-based acquisition circuitry
- 16-electrode circular measurement geometry
- Multiplexer-based electrode switching
- 60 µA peak-to-peak AC excitation at 500 Hz, 1 kHz, 5 kHz, and 10 kHz
- Homogeneous phantom measurements for baseline validation
---
## Reconstruction Methodology
Image reconstruction was performed using:
- MATLAB
- EIDORS v3.12
- FEM forward modeling
- Gauss-Newton inverse reconstruction
- Laplace regularization prior
---
## Signal Processing and Analysis
Analysis performed:
- Voltage measurement visualization
- FFT spectrum analysis
- Signal-to-noise ratio (SNR) estimation
- Voltage heatmap generation
- Reconstruction stability analysis
  
---
## Results
The system successfully reconstructed conductivity distributions from experimentally acquired voltage measurements using a low-cost experimental setup.
Current outputs include:
- FEM mesh visualization
- Reconstructed conductivity images
- Voltage heatmaps
- FFT spectrum plots
- SNR analysis
-  Mean SNR: 23.0 dB (16 electrodes)
- Reciprocity error: 7.64%
  
---
## Future Work
Planned future work includes:
- Heterogeneous phantom studies
- Noise propagation analysis
- Sensitivity mapping
- Nanoparticle comparative studies
- Quantum dot contrast studies
- Deep-learning-assisted reconstruction
---
## Repository Structure
/data      -> Experimental datasets  
/matlab    -> MATLAB and EIDORS scripts  
/figures   -> Reconstruction images and plots  
/results   -> Analysis outputs  
/docs      -> Research documentation  

---
## Reproducibility
To reproduce the reconstruction pipeline:
1. Import experimental voltage datasets from `/data`
2. Run MATLAB preprocessing and signal analysis scripts
3. Load FEM models using EIDORS v3.12
4. Perform inverse reconstruction using the Gauss-Newton solver
5. Generate conductivity maps and analysis plots
All reconstruction and analysis scripts are available in the `/matlab` directory.

---
## Tools and Technologies
- MATLAB
- EIDORS
- Arduino
- FEM Reconstruction
- Signal Processing
- Electrical Impedance Tomography (EIT)
---
## Author
Maheen Shaukat
Supervisor Dr. Naima Amin

---
## References
Development A Low-Cost Electrical Impedance Tomography System For Non-Invasively Detecting Abnormal In Breast Tissue - Phantom. Kalpa Publications in Engineering. Volume 4, 2022. Proceedings of International Symposium on Applied Science 2021, Pages 1–8.

## Citation Policy
If you use this work, please cite the repository or associated publication. For code usage, please reference the GitHub repository.
