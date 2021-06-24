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
load('ROIs.mat','ROI')

for ii=1:length(ROI)
    for i=1:length(ROI{ii})
        Timelapse{ii}{i}=[];
        ROI{ii}{i}(ROI{ii}{i}>512)=512;
        ROI{ii}{i}(ROI{ii}{i}<1)=1;
        TargetRow=ROI{ii}{i}(3):ROI{ii}{i}(4);
        TargetCol=ROI{ii}{i}(1):ROI{ii}{i}(2);
        for j=1:3
            reader{j}.setSeries(ii-1);
            for k=1:Imcount(j)
                data=bfGetPlane(reader{j},k);
                ImTemp=SplitAndCorrSIM(data,CalibIm561,200);
                Timelapse{ii}{i}{end+1}{1}=ImTemp{1}(TargetRow,TargetCol);
                Timelapse{ii}{i}{end}{2}=ImTemp{2}(TargetRow,TargetCol);
                Timelapse{ii}{i}{end}{3}=ImTemp{3}(TargetRow,TargetCol);
                [ii i j k]
            end
        end
    end
end

for i=1:length(ROI)
    Ind{i}=num2cell(ones(size(ROI{i}))*i);
end

ROI=horzcat(ROI{:});
ImageNumber=horzcat(Ind{:});
Timelapse=[horzcat(Timelapse{:});ImageNumber;ROI]';

