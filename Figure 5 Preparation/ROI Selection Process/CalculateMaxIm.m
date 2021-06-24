 clear;close all;clc
 
 %% Load Data and normalize
 addpath('C:\Files\Research\.TJ Focal Adhesion Analysis\Code\bfmatlab\bfmatlab')
 File{1}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 1.nd2'];
 File{2}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 2.nd2'];
 File{3}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 3.nd2'];
load('..\..\Data\2020-01-30 SIM MFM replicate 3\Chroma Slide\CalibFile3D.mat')
for k=1:3
    reader=bfGetReader(File{k});
    for i=1:reader.getSeriesCount
        reader.setSeries(i-1);
        for j=1:reader.getImageCount
            data=bfGetPlane(reader,j);
            Im{i}(:,:,j+(k>1))=double(data-200)./CalibIm561;
            [i j k]
        end
        [Im{i},MaxTime]=max(Im{i},[],3);
    end
end
MaxIm=Im;
Im=[];
save('MaxIms.mat','MaxIm')