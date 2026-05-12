# Low-Cost Electrical Impedance Tomography System Validation
## Overview
This project presents the experimental validation of a low-cost 16-electrode Electrical Impedance Tomography (EIT) system developed for biomedical imaging and computational reconstruction studies.
The system integrates:
- Arduino-based sinusoidal excitation
- 16-channel multiplexer switching
- Circular "Stainless steel electrodes 
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
- Mean SNR: 23.0 dB across all 16 electrodes
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
Supervisor Dr. Naima amin
Adler A, Lionheart WRB. Uses and abuses of EIDORS. Physiol Meas. 2006;27(5):S25–S42.
