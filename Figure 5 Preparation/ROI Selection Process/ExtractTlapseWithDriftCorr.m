clear;close all;clc

%% Initialize
% Points to timelapse files in experiment 4 from replication data
addpath('..\..\bfmatlab')
 File{1}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 1.nd2'];
 File{2}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 2.nd2'];
 File{3}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 3.nd2'];
load('..\..\CalibFile3D.mat','CalibIm561')
for j=1:3
    reader{j}=bfGetReader(File{j});
end
Imcount=[10 20 11];

%% Pull ROIs
load('ROIs.mat','ROI')
load('..\Drift Correction\Registration Tforms Fixed.mat','tform');

for ii=1:length(ROI)
    xDrift=0;
    yDrift=0;
    for i=1:length(ROI{ii})
        Timelapse{ii}{i}=[];
    end
    for j=1:3
        reader{j}.setSeries(ii-1);
        for k=1:Imcount(j)
            data=bfGetPlane(reader{j},k);
            ImTemp=SplitAndCorrSIM(data,CalibIm561,200);
            
            if (j*k)~=1
%                 xDrift=xDrift+tform{ii}{k-1+10*(j==2)+30*(j==3)}.T(3,1);
%                 yDrift=yDrift+tform{ii}{k-1+10*(j==2)+30*(j==3)}.T(3,2);
                
%                 tform{ii}{k-1+10*(j==2)+30*(j==3)}.T(3,1:2)=[xDrift yDrift];
                for i=1:length(ImTemp)
                    dXY=tform{ii}{k-1+10*(j==2)+30*(j==3)}.T(3,1:2);
                    D(:,:,1)=-ones(size(ImTemp{i}))*dXY(1);
                    D(:,:,2)=-ones(size(ImTemp{i}))*dXY(2);
                    ImTemp{i}=imwarp(ImTemp{i},D);
                end
            end
            
            for i=1:length(ROI{ii})
                ROI{ii}{i}(ROI{ii}{i}>512)=512;
                ROI{ii}{i}(ROI{ii}{i}<1)=1;
                TargetRow=ROI{ii}{i}(3):ROI{ii}{i}(4);
                TargetCol=ROI{ii}{i}(1):ROI{ii}{i}(2);
%                 if sum(sum(ImTemp{1}(TargetRow,:),2)==0)% | sum(sum(ImTemp{1}(:,TargetCol),1)==0)
%                     keyboard
%                 end
%                 TargetRow(sum(ImTemp{1}(TargetRow,:),2)==0)=[];
%                 TargetCol(sum(ImTemp{1}(:,TargetCol),1)==0)=[];
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
save('Timelapses.mat','Timelapse','File','CalibIm561');
