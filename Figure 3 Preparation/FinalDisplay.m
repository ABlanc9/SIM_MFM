clear;close all;clc
JJ=2;
for i=1
    
    if JJ==1
    load('MainIM.mat','Im','ImaxAll','ImaxAllSR')
    load('ROI Save File MIN2.mat','AX1','AX2')
    load('Linescan Save File Main2.mat','POS1','POS2')
    else
    load('MainIM.mat','Im','ImaxAll','ImaxAllSR')
    load('ROI Save File MIN.mat','AX1','AX2')
    load('Linescan Save File Main.mat','POS1','POS2')
    end
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
    plot([20 99.36]*2,[40 40]*2,'w','LineWidth',2)
    plot(AX1(i,[1 2 2 1 1]),AX1(i,[3 3 4 4 3]),'w','LineWidth',1)
    text(mean(AX1(i,1:2)),mean(AX1(i,3:4)),'1','Color','w')
    plot(AX2(i,[1 2 2 1 1]),AX2(i,[3 3 4 4 3]),'w','LineWidth',1)
    text(mean(AX2(i,1:2)),mean(AX2(i,3:4)),'2','Color','w')

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
    plot([10 25.8730]*2,[10 10]*2,'w','LineWidth',2)

    subplot(2,3,5)
    imshow(ImROI2,[])
    hold on
    plot(size(ImROI2,2)/2*[1 1],[1 size(ImROI2,1)],'w--')
    plot([1 size(ImROI2,2)],size(ImROI2,1)/2*[1 1],'w--')
    plot([10 25.8730]*2,[10 10]*2,'w','LineWidth',2)



    subplot(2,3,2)
    plot(POS1(i,[1 2]),POS1(i,[1 2]+2),'w')
    subplot(2,3,5)
    plot(POS2(i,[1 2]),POS2(i,[1 2]+2),'w')

    xpts1=POS1(i,1:2);
    ypts1=POS1(i,3:4);
    xpts2=POS2(i,1:2);
    ypts2=POS2(i,3:4);
    
    Dist1=sqrt((xpts1-xpts1(1)).^2+(ypts1-ypts1(1)).^2)*.063;
    Dist1=linspace(Dist1(1),Dist1(2),100);
    Dist2=sqrt((xpts2-xpts2(1)).^2+(ypts2-ypts2(1)).^2)*.063;
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
    
    LinGFP1=LinGFP1-min(LinGFP1);LinGFP1=LinGFP1/max(LinGFP1);
    LinGFP2=LinGFP2-min(LinGFP2);LinGFP2=LinGFP2/max(LinGFP2);
    LinGFP1SR=LinGFP1SR-min(LinGFP1SR);LinGFP1SR=LinGFP1SR/max(LinGFP1SR);
    LinGFP2SR=LinGFP2SR-min(LinGFP2SR);LinGFP2SR=LinGFP2SR/max(LinGFP2SR);
    
    subplot(2,6,5)
    plot(Dist1,smooth(LinGFP1),Dist1,smooth(LinGFP1SR))
    subplot(2,6,6)
    plot(Dist1,smooth(LinMFM1),Dist1,smooth(LinMFM1SR))
    subplot(2,6,11)
    plot(Dist2,smooth(LinGFP2),Dist2,smooth(LinGFP2SR))
    subplot(2,6,12)
    plot(Dist2,smooth(LinMFM2),Dist2,smooth(LinMFM2SR))
    INND=[5 6 11 12];
    for j=1:4
        subplot(2,6,INND(j))
        grid on
        axis([0 inf 0 1.05])
        set(gca,'FontSize',14,'FontName','Arial','YTick',0:.5:1,'XTick',0:2:8)
        axis square
    end
    
    clearvars -except i
%     print(gcf,'-painters','-depsc',['Fibroblast Display ' num2str(i) '.eps'])
end
% 
% %% Save if good
% load('Linescan Save File.mat','POS1','POS2')
% % xmin xmax ymin ymax
% POS1(i,:)=[xpts1 ypts1];
% POS2(i,:)=[xpts2 ypts2];
% save('Linescan Save File.mat','POS1','POS2')