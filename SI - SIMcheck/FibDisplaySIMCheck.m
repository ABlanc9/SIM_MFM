clear;close all;clc

% "D:\SIM Data Backup 2019\December2019 SIM MFM replicate\" refers to the
% fibroblast data in "experiment 2" in the replication data
addpath('..\bfmatlab')

MCN561all=[];
MCN488all=[];
Lbl=[22 26 37:40];
for i=1:length(Lbl)
    if i==1
    NDfile561=['D:\SIM Data Backup 2019\December2019 SIM MFM replicate\' ...
            'Fibroblasts 4pN\cell' num2str(Lbl(i)) '\Captured 3D SIM 561 3.nd2'];
    else
    NDfile561=['D:\SIM Data Backup 2019\December2019 SIM MFM replicate\' ...
            'Fibroblasts 4pN\cell' num2str(Lbl(i)) '\Captured 3D SIM 561.nd2'];
    end
    data=bfopen(NDfile561);
    Im561=data{1}{1}(1:512,1:512);
    NDfile488=['D:\SIM Data Backup 2019\December2019 SIM MFM replicate\' ...
            'Fibroblasts 4pN\cell' num2str(Lbl(i)) '\Captured 3D SIM 488.nd2'];
    data=bfopen(NDfile488);
    Im488=data{1}{1}(1:512,1:512);
    
    figure
    subplot(2,3,4)
    imshow(Im488,quantile(Im488(:),[.05 .99]))
    subplot(2,3,1)
    imshow(Im561,quantile(Im561(:),[.05 .99]))
    
    MCN561{i}=imread([cd '\Fibroblasts\Cell ' num2str(Lbl(i)) ' 561 MCN.tif']);
    h(i,1)=subplot(2,3,2);
    imshow(MCN561{i},[])
    colormap(h(i,1),'hot')
    caxis([2 16])
    
    MCN488{i}=imread([cd '\Fibroblasts\Cell ' num2str(Lbl(i)) ' 488 MCN.tif']);
    h(i,2)=subplot(2,3,5);
    imshow(MCN488{i},[])
    colormap(h(i,2),'hot')
    caxis([2 16])
    
    FFT561(:,:,i)=imread(['Fibroblasts\Cell ' num2str(Lbl(i)) ' 561 FFT.tif']);
    h(i,3)=subplot(2,3,3);
    imshow(FFT561(:,:,i),[])
    colormap(h(i,3),'gray')
    axis([256+170*[-1 1 -1 1]])
    
    FFT488(:,:,i)=imread(['Fibroblasts\Cell ' num2str(Lbl(i)) ' 488 FFT.tif']);
    h(i,4)=subplot(2,3,6);
    imshow(FFT488(:,:,i),[])
    colormap(h(i,3),'gray')
    axis([256+170*[-1 1 -1 1]])

    MCN561all=[MCN561all;MCN561{i}(:)];
    MCN488all=[MCN488all;MCN488{i}(:)];
    
    QMCNRfib488(i)=quantile(MCN488{i}(:),.99);
    QMCNRfib561(i)=quantile(MCN561{i}(:),.99);
%     if i
    
end
figure
%%
[F,X]=ecdf(MCN561all(:));
% subplot(1,3,2)
semilogy(X,100-F*100)
grid on
hold on
[F,X]=ecdf(MCN488all(:));
% subplot(1,3,2)
semilogy(X,100-F*100)
grid on
load('Plat ECDF.mat','X','F')
plot(X,100-F*100)
legend('Fib 561','Fib 488','Plat 561')
