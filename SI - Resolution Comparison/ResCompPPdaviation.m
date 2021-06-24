clear;close all;clc
addpath(genpath('..\bfmatlab'))
Folder='D:\SIM Data Backup 2019\Jan 2020 SIM Replicate 3\platelet surface 2';
a=dir([Folder '\*#*.nd2']);
for i=1:length(a)
    SRfile{i}=fullfile(Folder,a(i).name);
    Ind1=find(a(i).name=='_');
    Ind2=find(a(i).name=='.');
    WFfile{i}=fullfile(Folder,a(i).name([1:(Ind1-1) Ind2:end]));
end
% SRfile{1}='C:\Files\Research\.SIM MFM\Data\Images for poster\Reconstructed Platelet 10.txt';

ROI{1}{1}=[   69.0499  213.6870   31.3422  175.9793];
ROI{1}{2}=[  298.4409  457.9539  300.2744  459.7874];
ROI{2}{1}=[  229.0000  406.0000  182.0000  359.0000];
ROI{2}{2}=[  211.0000  362.0000   1  145.5000];
ROI{3}{1}=[  153.0000  359.0000  176.5000  382.5000];
ROI{3}{2}=[  351.0000  499.0000   18.5000  166.5000];
ROI{4}{1}=[  183.0000  351.0000  159.0000  327.0000];
ROI{5}{1}=[  162.5000  340.5000  174.0000  352.0000];
ROI{6}{1}=[  339.0000  483.0000  200.5000  344.5000];
ROI{6}{2}=[   14.0000  194.0000  121.0000  301.0000];
ROI{7}{1}=[  210.0000  344.0000  110.0000  244.0000];
ROI{7}{2}=[  192.6211  342.6211  251.2617  401.2617];
ROI{8}{1}=[  176.5000  331.5000  134.0000  289.0000];
ROI{9}{1}=[  127.8203  315.8203  120.9453  308.9453];
ROI{9}{2}=[  221.0000  391.0000  306.5000  476.5000];
ROI{10}{1}=[  125.0000  311.0000   46.5000  232.5000];
ROI{10}{2}=[  229.0000  392.0000  230.5000  393.5000];
ROI{11}{1}=[  208.0312  391.5203   39.5443  223.0334];
ROI{11}{2}=[  127.6345  287.6585  321.8944  481.9185];
ROI{12}{1}=[  153.5000  279.5000  229.0000  355.0000];
for i=1:length(ROI)
    xptsCum{i}=cell(size(ROI{i}));
    yptsCum{i}=cell(size(ROI{i}));
    WFfile{i}=repmat(WFfile(i),length(ROI{i}),1);
    SRfile{i}=repmat(SRfile(i),length(ROI{i}),1);
end
WFfile=vertcat(WFfile{:});
SRfile=vertcat(SRfile{:});

ROIfolder='C:\Files\Research\.SIM MFM\Code\SI - Resolution Comparison\PtsFld';
a2=dir([ROIfolder '\*.mat']);
for i=1:length(a2)
    load(fullfile(ROIfolder,a2(i).name),'xpt','ypt');
    for j=1:length(xptsCum)
        for k=1:length(xptsCum{j})
            try
           if isempty(xptsCum{j}{k})
               xptsCum{j}{k}=xpt{j}{k};
               yptsCum{j}{k}=ypt{j}{k};
           end
            end
        end
    end
end
xptsCum=horzcat(xptsCum{:})';
yptsCum=horzcat(yptsCum{:})';
ROI=horzcat(ROI{:})';

ScanDist=6;
Nquery=50;
ScanDist=linspace(-ScanDist,ScanDist,Nquery);
load('Multi-cell output.mat','Sig2','Sig','peakI','peakI2','Keep','bkrdI','bkrdI2','Loc','Loc2')
for i=1:length(WFfile)
%     load(QPtFile{i},'xpt','ypt','Imax')


    data=bfopen(WFfile{i});
    for ii=1:3
        Row=(1:512)+(ii-1)*512;
        for k=1:5
            Col=(1:512)+(k-1)*512;
            ImRaw{ii}(:,:,k)=double(data{1}{1}(Row,Col));
            ImRaw{ii}(:,:,k)=(ImRaw{ii}(:,:,k)-200)*4.9/100;
        end
        Im{ii}=sum(ImRaw{ii},3);
    end
    Thresh=1.6;

    cmap=hsv(64);
    AzRef=linspace(0,180,64)';

    Iavg=(Im{1}+Im{2}+Im{3})/3;
    I1=Im{1}-Iavg;
    I3=Im{3}-Iavg;
    Az=rad2deg(atan2(I1-I3*cosd(120),I3*sind(120)))/2+90;
    Az(Az<0)=Az(Az<0)+360;
    Az(Az>180)=Az(Az>180)-180;
    A=I3./cosd(2*(Az-90));
    c=Im{3}-A.*cosd(Az-90).^2-1;
    Imax=A*2+c;
    Az=Az+17;
    Az(Az<0)=Az(Az<0)+360;
    Az(Az>180)=Az(Az>180)-180;

%     xptAll{i}=xpt;
%     yotAll{i}=ypt;
    xpt=xptsCum{i};
    ypt=yptsCum{i};

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
        AzRad(j,:)=(improfile(Az,xNew(j)+Cent(1)+ScanDist*cos(Tngnt(j)),...
            yNew(j)+Cent(2)+ScanDist*sin(Tngnt(j))));
    end
    Tngt=Tngnt;
    Tngt(Tngt>pi)=Tngt(Tngt>pi)-pi;
    DevRad=acosd(abs(cosd((180-AzRad)-rad2deg(repmat(Tngt',1,50)))));
    Irad=Irad/mean2(Irad);
    Weight=Irad./sum(Irad,2);
    figure(1)
    QuivInd=1:100:401;
%     for j=1:length(Tngnt)
%         FO=fit(ScanDist',Irad(j,:)','a*exp(-(x-b)^2/2/c^2)+d',...
%               'StartPoint',[1 0 1 1],'Lower',[0 -inf 0 0]);
%         Sig{i}(j)=FO.c;
%         peakI{i}(j)=FO.a;
%         bkrdI{i}(j)=FO.d;
%         Loc{i}(j)=FO.b;
%         plot(ScanDist,Irad(j,:),'b.');
%         hold on
%         plot(ScanDist,FO(ScanDist),'k');
%         hold off
%         [i j]
%         if sum(j==QuivInd)
%             figure(25)
%             subplot(1,5,(j-1)/100+1)
%             plot(ScanDist*63/1000,Irad(j,:),'b.');
%             hold on
%             plot(ScanDist*63/1000,FO(ScanDist),'b');
%             figure(1)
%         end
%     end
    
    Imax2=bfopen(SRfile{i});
    Imax2=Imax2{1}{1};
    for j=1:length(Tngnt)
        Irad2(j,:)=smooth(improfile(Imax2,xNew(j)*2+Cent(1)*2+ScanDist*cos(Tngnt(j))*2,...
            yNew(j)*2+Cent(2)*2+ScanDist*sin(Tngnt(j))*2));
    end
    Irad2=Irad2/mean2(Irad2);
    Weight2=Irad2./sum(Irad2,2);
    
%     for j=1:length(Tngnt)
%         FO=fit(ScanDist',Irad2(j,:)','a*exp(-(x-b)^2/2/c^2)+d',...
%             'StartPoint',[1 0 1 1],'Lower',[0 -inf 0 0]);
%         Sig2{i}(j)=FO.c;
%         peakI2{i}(j)=FO.a;
%         bkrdI2{i}(j)=FO.d;
%         Loc2{i}(j)=FO.b;
%         plot(ScanDist*63*2.335,Irad2(j,:),'k.');
%         hold on
%         plot(ScanDist*63*2.335,FO(ScanDist),'k');
%         hold off
%         [i j]
%         if sum(j==QuivInd)
%             figure(25)
%             subplot(1,5,(j-1)/100+1)
%             plot(ScanDist*63/1000,Irad2(j,:),'r.');
%             hold on
%             plot(ScanDist*63/1000,FO(ScanDist),'r');
%             set(gca,'FontSize',14);grid on
%             figure(1)
%             
%         end
%     end
    AvgDev{i}=sum(DevRad.*Weight,2);
    AvgDev2{i}=sum(DevRad.*Weight2,2);
    figure
    Keep{i}=(peakI2{i}>.2) & (peakI{i}>.2) & (abs(Loc{i})<5) & (abs(Loc2{i})<5);
    histogram(Sig{i}(Keep{i})*63*2.335,(0:.2:3)*63*2.335)
    hold on
    histogram(Sig2{i}(Keep{i})*63*2.335,(0:.2:3)*63*2.335)
    xlabel('FWHM')
    ylabel('Counts')
    legend('WF','SIM')
    
    figure
    subplot(1,2,1)
    imshow(Imax,[])
    hold on
    plot(xpt,ypt,'-xy','LineWidth',1)
    axis(ROI{i})
    subplot(1,2,2)
    imshow(Imax,[])
    hold on
    quiver(xNew(1:10:end)+Cent(1),yNew(1:10:end)+Cent(2),-cos(Tngnt(1:10:end))*6,-sin(Tngnt(1:10:end))*6,'ShowArrowHead','off','AutoScale','off')
    quiver(xNew(1:10:end)+Cent(1),yNew(1:10:end)+Cent(2),cos(Tngnt(1:10:end))*6,sin(Tngnt(1:10:end))*6,'ShowArrowHead','off','AutoScale','off')
    axis (ROI{i})
    quiver(xNew(QuivInd)+Cent(1),yNew(QuivInd)+Cent(2),-cos(Tngnt(QuivInd))*6,-sin(Tngnt(QuivInd))*6,'ShowArrowHead','off','AutoScale','off','LineWidth',2,'Color','w')
    quiver(xNew(QuivInd)+Cent(1),yNew(QuivInd)+Cent(2),cos(Tngnt(QuivInd))*6,sin(Tngnt(QuivInd))*6,'ShowArrowHead','off','AutoScale','off','LineWidth',2,'Color','w')
    
%     Ind=find(Keep);
end
save('Multi-cell output DevRad.mat','Sig2','Sig','peakI','peakI2','Keep','bkrdI','bkrdI2','Loc','Loc2')