clear;close all;clc

QPtFile{1}='QueryPoints.mat';
Folder='D:\SIM Data Backup 2019\Jan 2020 SIM Replicate 3\platelet surface 2';
a=dir([Folder '\*#*.nd2']);
for i=1:length(a)
    SRfile{i}=fullfile(Folder,a(i).name);
    Ind1=find(a(i).name=='_');
    Ind2=find(a(i).name=='.');
    WFfile{i}=fullfile(Folder,a(i).name([1:(Ind1-1) Ind2:end]));
end
SRfile{1}='C:\Files\Research\.SIM MFM\Data\Images for poster\Reconstructed Platelet 10.txt';

ScanDist=6;
Nquery=50;
ScanDist=linspace(-ScanDist,ScanDist,Nquery);

for i=1:length(QPtFile)
    load(QPtFile{i},'xpt','ypt','Imax')
%     xptAll{i}=xpt;
%     yotAll{i}=ypt;

%     pgon=polyshape(xpt,ypt);
%     Cent=centroid(pgon);
    Stats=polygeom(xpt,ypt);
    Cent=Stats(2:3);
    [az,r]=cart2pol(ypt-Cent(2),xpt-Cent(1));
    az(az<0)=az(az<0)+2*pi;
%     az(end)=az(end)+2*pi;
    azr=sortrows([az r]);
    azr=[azr(end,:)-[2*pi 0];azr;azr(1,:)+[2*pi 0]];
    az=azr(:,1);
    r=azr(:,2);
    
    AzNew=linspace(0,2*pi,500);
    rNew=smooth(interp1(az,r,AzNew'),5)';
    [yNew,xNew]=pol2cart(AzNew,rNew);
    dx=[xNew(2:end) xNew(1)]-[xNew(end) xNew(1:(end-1))];
    dy=[yNew(2:end) yNew(1)]-[yNew(end) yNew(1:(end-1))];
    Tngnt=atan2(dy,dx)+pi/2;
    Tngnt(Tngnt<0)=Tngnt(Tngnt<0)+2*pi;
    
    for j=1:length(Tngnt)
        Irad(j,:)=smooth(improfile(Imax,xNew(j)+Cent(1)+ScanDist*cos(Tngnt(j)),...
            yNew(j)+Cent(2)+ScanDist*sin(Tngnt(j))));
    end
    Irad=Irad/mean2(Irad);
    figure(1)
    for j=1:length(Tngnt)
        FO=fit(ScanDist',Irad(j,:)','a*exp(-(x-b)^2/2/c^2)+d',...
              'StartPoint',[1 0 1 1],'Lower',[0 -inf 0 0]);
        Sig(j)=FO.c;
        peakI(j)=FO.a;
        bkrdI(j)=FO.d;
        Loc(j)=FO.b;
        plot(ScanDist,Irad(j,:),'b.');
        hold on
        plot(ScanDist,FO(ScanDist),'k');
        hold off
        [i j]
    end
    
    Imax2=dlmread(SRfile{i});
    for j=1:length(Tngnt)
        Irad2(j,:)=smooth(improfile(Imax2,xNew(j)*2+Cent(1)*2+ScanDist*cos(Tngnt(j))*2,...
            yNew(j)*2+Cent(2)*2+ScanDist*sin(Tngnt(j))))*2;
    end
    Irad2=Irad2/mean2(Irad2);
    for j=1:length(Tngnt)
        FO=fit(ScanDist',Irad2(j,:)','a*exp(-(x-b)^2/2/c^2)+d',...
            'StartPoint',[1 0 1 1],'Lower',[0 -inf 0 0]);
        Sig2(j)=FO.c;
        peakI2(j)=FO.a;
        bkrdI2(j)=FO.d;
        Loc2(j)=FO.b;
        plot(ScanDist*63*2.335,Irad2(j,:),'b.');
        hold on
        plot(ScanDist*63*2.335,FO(ScanDist),'k');
        hold off
        [i j]
    end
    figure
    Keep=(peakI2>.2) & (peakI>.2) & (abs(Loc)<5) & (abs(Loc2)<5);
    histogram(Sig(Keep)*63*2.335,(0:.2:3)*63*2.335)
    hold on
    histogram(Sig2(Keep)*63*2.335,(0:.2:3)*63*2.335)
    xlabel('FWHM')
    ylabel('Counts')
    legend('WF','SIM')
    
    figure
    subplot(1,2,1)
    imshow(Imax,[])
    hold on
    plot(xpt,ypt,'-xy','LineWidth',1)
    subplot(1,2,2)
    imshow(Imax,[])
    hold on
    quiver(xNew(1:10:end)+Cent(1),yNew(1:10:end)+Cent(2),-cos(Tngnt(1:10:end))*6,-sin(Tngnt(1:10:end))*6,'ShowArrowHead','off','AutoScale','off')
    quiver(xNew(1:10:end)+Cent(1),yNew(1:10:end)+Cent(2),cos(Tngnt(1:10:end))*6,sin(Tngnt(1:10:end))*6,'ShowArrowHead','off','AutoScale','off')
    
    Ind=find(keep);
end