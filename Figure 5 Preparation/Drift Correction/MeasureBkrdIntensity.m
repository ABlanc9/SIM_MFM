clear;close all;clc

clear;close all;clc

%% Initialize
addpath(genpath('D:\.SIM MFM\Code\AA General Tools'));
 File{1}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 1.nd2'];
 File{2}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 2.nd2'];
 File{3}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 3.nd2'];
load('..\..\..\Data\2020-01-30 SIM MFM replicate 3\Chroma Slide\CalibFile3D.mat','CalibIm561')
for j=1:3
    reader{j}=bfGetReader(File{j});
end
Imcount=[10 20 11];

%% Pull ROIs
load('BkrdROIs.mat','BkrdROI')
[optimizer, metric] = imregconfig('multimodal');
for i=1:length(BkrdROI)
    BkrdROI{i}=BkrdROI{i}{1};
    TargetRow=BkrdROI{i}(3):BkrdROI{i}(4);
    TargetCol=BkrdROI{i}(1):BkrdROI{i}(2);
    for j=1:3
        reader{j}.setSeries(i-1);
        for k=1:Imcount(j)
            data=bfGetPlane(reader{j},k);
            ImTemp=SplitAndCorrSIM(data,CalibIm561,200);
            I(i,k+(j==2)*10+(j==3)*30)=mean2(ImTemp{1}(TargetRow,TargetCol)+...
                ImTemp{2}(TargetRow,TargetCol)+ImTemp{3}(TargetRow,TargetCol));
            [i j k]
        end
    end
end