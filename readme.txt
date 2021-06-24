This code accompanies the publication in 2021 Nature Communications "Turn-key super-resolution
mapping of cell receptor force orientation and magnitude using a commercial structured
illumination microscope" By Blanchard et al.

All software was developed using MATALB 2018b on a laptop running Windows 10 x64, version
10.0.18363. This code can be run by unzipping the folder, opening SIMMFM.m in MATLAB, and
clicking run. Within a few seconds, the code in this directory (SIMMFM.m) will reproduce
the images shown in figure 2.

This code requires MATLAB's statistics toolbox for the use of the "quantile" function. 

SIMMFM.m performs the following steps:

1) Loads a 15-image SIM-MFM acquisition from .nd2 file. This step requires the bioformats
   package (https://docs.openmicroscopy.org/bio-formats/6.1.0/users/matlab/index.html), which
   is included in the "bfmatlab" subdirectory. This subdirectory may need to be replaced if a
   different operating system is used.

2) Re-structures the loaded data and applies background correction. This step loads the
   background calibration file (CalibFile3D.mat), which was generated using Create3DCalibFile.m.

3) Calculate and display force orientation. This step requires an input of alpha0, which in
   in our case is 77 degrees.

Colorwheels.png can be viewed to help interpret the orientation colormaps.


In addition, there are several subdirectories that contain additional MATLAB scripts for
regenerating figures in the main text and SI. Specifically:
* The code SIMMFM.m can be used to generate figures in Figs. 1, 2a-e, and 6b
* "Figure 3 Preparation" - Contains code for generating Figs. 3 and S8
	> to use, run "Fibroblasts.m" to generate "All Images.mat", then run other functions.
* "Figure 4 Preparation" - Contains code for generating Figs. 4a and S10-11
* "Figure 5 Preparation" - Contains code for generating Figs. 4b, 5, S12, and S16 and Table 1
	> to use, run "ROI Selection Process\ExtractTlapseWithDriftCorr.m" to generate "Timelapses.mat"
* "Figure 6 Preparation" - Contains code for generating Figs. 6 and S19
* "SI - Resolution Comparison" - Contains code for generating Figs. 2f-h S6, S7, and S9
* "SI - Extinction Plot" - Contains code for generating Fig. S1
* "SI - Beads DiI SLB" - Contains code for generating Fig. S2
* "SI - many platelets and th vs az" - Contains code for generating Fig. S3 and S13
* "SI - Deviation Angle" - Contains code for generating Fig. S4
* "SI - Background Correction Method Validation" - Contains code for generating Fig. S5
* "SI - Area and Alignment Depictions" - Contains code for generating Figs. S14-15
* "SI - Photobleaching" - Contains code for generating Figs. S17-18


Note that none of the scripts in the sub-directories are commented or professionally written.
The scripts are also not necessarily well-organized, and were used simply to process data and
generate figures. Please use at your own risk. Many of the scripts open data files from the
replication dataset at https://doi.org/10.15139/S3/FXOHWV, and you will need to change folder
names to properly call these files. The scripts also often call functions that were written
by other people, which I have included here for convenience. Specifically, the:
	* Bio-formats package in the "bfmatlab" folder 
	  (https://docs.openmicroscopy.org/bio-formats/6.1.0/users/matlab/index.html)
	* notBoxPlot script in the folder raacampbell-notBoxPlot-3ce29db
	  (https://www.mathworks.com/matlabcentral/fileexchange/26508-notboxplot)
	* spiralSampleSphere.m was used to sample points evenly on a unit sphere in "Figure 4 Preparation".
	  (https://www.mathworks.com/matlabcentral/fileexchange/37004-suite-of-functions-to-perform-uniform-sampling-of-a-sphere)
	* TurboMap.m was used as a colormap in "Figure 4 Preparation".
	  (https://www.mathworks.com/matlabcentral/fileexchange/74662-turbo)
	* polygeom.m and violin.m were used in resolution comparison scripts
	  (https://www.mathworks.com/matlabcentral/fileexchange/319-polygeom-m)
	  (https://www.mathworks.com/matlabcentral/fileexchange/45134-violin-plot)

I hope I didn't miss anything but if I did, please email me at ATBlanchard@ymail.com to let me know
and I will update this readme.
