clear;close all;clc

load('All Images.mat','Im','ImaxAll','ImaxAllSR')
load('ROI Save File.mat','AX1','AX2')
i=10;

figure('OuterPosition',[ -0.0154    0.0938    1.5252    0.6608]*1000)

Im{i,1}=imresize(Im{i,1},2);
Im{i,3}=imresize(Im{i,3},2);
ImaxAll{i}=imresize(ImaxAll{i},2);

subplot(1,3,1)
ImFull=[Im{i,1} Im{i,2};Im{i,3} Im{i,4}];
imshow(ImFull,[])
AX1=round(AX1)*2;
AX2=round(AX2)*2;
hold on
plot(size(ImFull,1)/2*[1 1],[1 size(ImFull,2)],'w--')
plot([1 size(ImFull,2)],size(ImFull,1)/2*[1 1],'w--')
plot([20 99.36],[40 40],'w','LineWidth',2)

Row1=AX1(i,3):AX1(i,4);
Row2=AX2(i,3):AX2(i,4);
Col1=AX1(i,1):AX1(i,2);
Col2=AX2(i,1):AX2(i,2);

subplot(2,3,2)
ImROI1=[Im{i,1}(Row1,Col1,:) Im{i,2}(Row1,Col1,:);Im{i,3}(Row1,Col1,:) Im{i,4}(Row1,Col1,:)];
ImROI2=[Im{i,1}(Row2,Col2,:) Im{i,2}(Row2,Col2,:);Im{i,3}(Row2,Col2,:) Im{i,4}(Row2,Col2,:)];


ImaxROI1=[ImaxAll{i}(Row1,Col1,:)];
ImaxROI2=[ImaxAll{i}(Row2,Col2,:)];
ImaxROI1SR=[ImaxAllSR{i}(Row1,Col1,:)];
ImaxROI2SR=[ImaxAllSR{i}(Row2,Col2,:)];
IGFP1=Im{i,3}(Row1,Col1,2);
IGFP2=Im{i,3}(Row2,Col2,2);
IGFP1SR=Im{i,4}(Row1,Col1,2);
IGFP2SR=Im{i,4}(Row2,Col2,2);

imshow(ImROI1,[])
hold on
plot(size(ImROI1,2)/2*[1 1],[1 size(ImROI1,1)],'w--')
plot([1 size(ImROI1,2)],size(ImROI1,1)/2*[1 1],'w--')
plot([10 25.8730],[10 10],'w','LineWidth',2)

subplot(2,3,5)
imshow(ImROI2,[])
hold on
plot(size(ImROI2,2)/2*[1 1],[1 size(ImROI2,1)],'w--')
plot([1 size(ImROI2,2)],size(ImROI2,1)/2*[1 1],'w--')
plot([10 25.8730],[10 10],'w','LineWidth',2)



subplot(2,3,2)
h1=drawline;
subplot(2,3,5)
h2=drawline;

while 1
    xpts1=[h1.Position(1,1),h1.Position(2,1)];
    ypts1=[h1.Position(1,2),h1.Position(2,2)];
    xpts2=[h2.Position(1,1),h2.Position(2,1)];
    ypts2=[h2.Position(1,2),h2.Position(2,2)];
    
    Dist1=sqrt((xpts1-xpts1(1)).^2+(ypts1-ypts1(1)).^2)*63;
    Dist1=linspace(Dist1(1),Dist1(2),100);
    Dist2=sqrt((xpts2-xpts2(1)).^2+(ypts2-ypts2(1)).^2)*63;
    Dist2=linspace(Dist2(1),Dist2(2),100);
    
    LinGFP1=improfile(IGFP1,xpts1,ypts1,100);
    LinGFP2=improfile(IGFP2,xpts2,ypts2,100);
    LinGFP1SR=improfile(IGFP1SR,xpts1,ypts1,100);
    LinGFP2SR=improfile(IGFP2SR,xpts2,ypts2,100);
    
    LinMFM1=improfile(ImaxROI1,xpts1,ypts1,100);
    LinMFM2=improfile(ImaxROI2,xpts2,ypts2,100);
    LinMFM1SR=improfile(ImaxROI1SR,xpts1,ypts1,100);
    LinMFM2SR=improfile(ImaxROI2SR,xpts2,ypts2,100);
    
    LinMFM1=LinMFM1-min(LinMFM1);LinMFM1=LinMFM1/max(LinMFM1);
    LinMFM2=LinMFM2-min(LinMFM2);LinMFM2=LinMFM2/max(LinMFM2);
    LinMFM1SR=LinMFM1SR-min(LinMFM1SR);LinMFM1SR=LinMFM1SR/max(LinMFM1SR);
    LinMFM2SR=LinMFM2SR-min(LinMFM2SR);LinMFM2SR=LinMFM2SR/max(LinMFM2SR);
    
    subplot(2,6,5)
    plot(Dist1,LinGFP1,Dist1,LinGFP1SR)
    subplot(2,6,6)
    plot(Dist1,LinMFM1,Dist1,LinMFM1SR)
    subplot(2,6,11)
    plot(Dist2,LinGFP2,Dist2,LinGFP2SR)
    subplot(2,6,12)
    plot(Dist2,LinMFM2,Dist2,LinMFM2SR)
    
    
%     s=rem(j+1,2);
%     axis((s+1)*[h1.Position(1) sum(h1.Position([1 3])) h1.Position(2) sum(h1.Position([2 4]))]);
%     subplot(3,4,j+8)
%     axis((s+1)*[h2.Position(1) sum(h2.Position([1 3])) h2.Position(2) sum(h2.Position([2 4]))]);
    pause
end

%% Save if good
load('Linescan Save File.mat','POS1','POS2')
% xmin xmax ymin ymax
POS1(i,:)=[xpts1 ypts1];
POS2(i,:)=[xpts2 ypts2];
save('Linescan Save File.mat','POS1','POS2')