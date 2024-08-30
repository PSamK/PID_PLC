# PID_PLC

This repository contains implementations of PID (Proportional-Integral-Derivative) controllers and PLC (Programmable Logic Controller) programs for industrial automation applications.

## Repository Structure

The repository is divided into two main parts:

1. PID: Implementation of PID controllers for greenhouse temperature control
2. PLC: Implementation of a PLC program for conveyor belt control

## PID Section
The PID section includes:

- A model to evaluate the temperature evolution in a three-sector greenhouse over 24 hours
- Implementation of three types of controllers:
  - Single Relay
  - Double Relay
  - PID (Proportional-Integral-Derivative)

## Tools Used

- MATLAB
- Control System Toolbox

The controllers were designed and simulated using MATLAB and its Control System Toolbox. This allowed for precise modeling of the greenhouse environment and accurate controller tuning.

## PLC Section

The PLC section implements the requirements specified in the 'Exercise 22 PLC' document. It includes:

- A Ladder Logic (LAD) program for controlling a conveyor system
- Implementation of various sensor-based controls and timing functions

## Tools Used

- FX-TRN-BEG (MELSEC-FX Series PLC Training Software)

The PLC program was developed using the FX-TRN-BEG software, which provides a simulation environment for MELSEC-FX Series PLCs.

## Getting Started
To use the programs in this repository:

1. For the PID section:
    - Ensure you have MATLAB installed with the Control System Toolbox
    - Open the MATLAB scripts in the PID folder


2. For the PLC section:
    - Install FX-TRN-BEG software
    - Open the LAD program files in the PLC folder using FX-TRN-BEG

## Authors

- [Martin Martuccio](https://github.com/Martin-Martuccio) - Project Author
- [Samuele Pellegrini](https://github.com/PSamK) - Project Author
- [Daniel Brendo Flores Mendoza](https://github.com/FMDani) - Project Author

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
