# SIM_MFM
This code accompanies the publication in 2021 Nature Communications "Turn-key super-resolution
mapping of cell receptor force orientation and magnitude using a commercial structured
illumination microscope" By Blanchard et al.

All software was developed using MATALB 2018b on a laptop running Windows 10 x64, version
10.0.18363. This code can be run by unzipping the folder, opening SIMMFM.m in MATLAB, and
clicking run. Within a few seconds, this code will reproduce the images shown in figure 2.
This code requires MATLAB's statistics toolbox for the use of the "quantile" function. 

SIMMFM.m performs the following steps:

1) Loads a 15-image SIM-MFM acquisition from .nd2 file. This step requires the bioformats
   package (https://docs.openmicroscopy.org/bio-formats/6.1.0/users/matlab/index.html), which
   is included in the "bfopen" subdirectory. This subdirectory may need to be replaced if a
   different operating system is used.

2) Re-structures the loaded data and applies background correction. This step loads the
   background calibration file (CalibFile3D.mat), which was generated using Create3DCalibFile.m.

3) Calculate and display force orientation. This step requires an input of alpha0, which in
   in our case is 77 degrees.

Colorwheels.png can be viewed to help interpret the orientation colormaps.
