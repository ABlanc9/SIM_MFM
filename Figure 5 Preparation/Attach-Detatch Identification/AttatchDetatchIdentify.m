clear;close all;clc

load('..\ROI Selection Process\TimelapseDriftCorr.mat','Timelapse')

figure('OuterPosition',[-0.0054    0.0346    1.5488    0.8368]*1000);
load('AppDispChkpt.mat','Timepoint')
for i=22:length(Timelapse)
    for j=1:41
        subplot(6,7,j)
        imshow(Timelapse{i,1}{j}{1}+Timelapse{i,1}{j}{2}+Timelapse{i,1}{j}{3},[])
        title(num2str(j))
    end
    Timepoint(i,1)=input('Appearance Timepoint?');
    Timepoint(i,2)=input('Disappearance Timepoint?');
%     Timepoint(i,3)=input('Disappearance Timepoint?');
end

save('Timepoints.mat','Timepoint')