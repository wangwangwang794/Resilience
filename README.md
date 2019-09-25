# Resilience
This repository contains the MATLAB implementation code of the results presented in article "Computation of Stability and Performance related Resilience Measures for Power Systems".

# Installation 
### Step 1. 
Install the supporting open-source MATLAB libaries: PSAT (http://faraday1.ucd.ie/psat.html), CVX (http://cvxr.com/cvx/download/), SOSTOOLS (https://www.cds.caltech.edu/sostools/) and SeDumi 1.3 (http://sedumi.ie.lehigh.edu/?page_id=58). Note that CVX needs to be separately installed (follow the user-guide in the provided link), while the other dependencies can be downloaded and their respective directories can be added to MATLAB path. Although CVX includes a SeDuMi package, SeDuMi needs to be separately downloaded from the link provided, for SOSTOOLS to work. Make sure the path of all these tools are added to MATLAB path file.  

### Step 2.
Clone/download this repository.

### Step 3.
The power-system network data is provided by user through the file 'data.m', which is loaded with the data corresponding to System # 1 (of the article) by default. This file can be found in the parent directory of this repository. Also user can set the probability of the different type of faults (e.g. line fault, transformer fault, generator fault and bus fault) by changing the elements of vectors variable 'p' of 'main.m', located in the parent directory. Note that all elements need to be non-negative and sum up to unity.

### Step 4.
For running the tool, just open and run the 'main.m' file. Path for this repository need not be added by the user. It is done automatically by the tool.

Contact me (talukder@iastate.edu) if any installation-issue is encountered.

# Note
This tool is tested in Windows 10 with MATLAB 2019a. The tool first generates a consolidated list of all possible length-l contingencies which is saved in a MATLAB data file named 'eventlist' in the parent folder. The final results (with the list of contingencies with their corresponding resilience measures) are saved in a .csv file named 'resilience'.

