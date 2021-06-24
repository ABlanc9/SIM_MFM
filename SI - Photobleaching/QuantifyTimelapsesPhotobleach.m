clear;close all;clc
load('Selected Point.mat','SelectedPoint');
load('..\Figure 5 Preparation\Drift Correction\Background Intensity.mat','I')
load('..\Figure 5 Preparation\Timelapses.mat','Timelapse')
load('..\Figure 5 Preparation\ROI Selection Process\ROIs.mat','ROI')

Icorr=I;

clear I
t=[(0:9)*2 (11:41)*2];
hybridopts = optimoptions('fmincon','Display','off');
opt=optimoptions('simulannealbnd','HybridFcn',{'fmincon',hybridopts},...
    'MaxFunctionEvaluations',500000,...
          'ReannealInterval',100,'InitialTemperature',700,...
          'MaxIterations',500000,'HybridInterval',5001);
%     'PlotFcns',{@saplotbestx,@saplotbestf,@saplotx,@saplotf},...

ROIind=[];
AllA=[];AllR=[];
for i=1:length(ROI)
    ROIind=[ROIind ones(size(ROI{i}))*i];
end

LowerLim=.6;
UpperLim=.9;
alpha0=77;
azCum=[];
ImaxCum=[];
FO=[];
GoodInd=[];
parCV=[];
parA=[];

IndOfInterest=[2 4 8 9 14 18 19 21 22 24 27 32 34 43 44 51 55 61 63 74 75 78 81];
for iiii=3:length(IndOfInterest)
    i=IndOfInterest(iiii);
% i=8
    figure('OuterPosition',1000*[0.0622    0.3962    1.3804    0.4412])
    tExp=1-exp(-((1:41)-1)/40)
    for j=1:41
        Exp=exp(-(j-1)/40);
        if j==1
            Timelapse{i,1}{SelectedPoint(i)}{1}=Timelapse{i,1}{SelectedPoint(i)}{1}*587.8037/542.2585;
            Timelapse{i,1}{SelectedPoint(i)}{3}=Timelapse{i,1}{SelectedPoint(i)}{3}*587.8037/621.5431;
        end
        ImAvg{j}=(Timelapse{i,1}{SelectedPoint(i)}{1}+...
            Timelapse{i,1}{SelectedPoint(i)}{2}+Timelapse{i,1}{SelectedPoint(i)}{3})/3*Exp;
        ImAvg{j}=ImAvg{j}/Icorr(ROIind(i),SelectedPoint(i));
        Isum(i,j)=mean(ImAvg{j},'all');
        Mask=bwareaopen(ImAvg{j}>.5,20);
        Area(i,j)=sum(Mask(:));
%         subplot(2,2,1)
%         imshow(ImAvg{j},[]);
%         subplot(2,2,3)
%         imshow(Mask)
%         title(['ROI' num2str(i) 'T' num2str(j)])
%         drawnow


        I1=ImAvg{j}-Timelapse{i,1}{SelectedPoint(i)}{1}/Icorr(ROIind(i),SelectedPoint(i))*Exp;
        I2=ImAvg{j}-Timelapse{i,1}{SelectedPoint(i)}{2}/Icorr(ROIind(i),SelectedPoint(i))*Exp;
        Az{j}=atan2d((I2-I1*cosd(120)),I1*sind(120))/2+alpha0;
        Az{j}(Az{j}<0)=Az{j}(Az{j}<0)+180;
        
    end 

    cmap=hsv(64);
    AzRef=linspace(0,180,64)';
    ImAvgTile{i}=imtile(ImAvg(2:end),'BorderSize',1,'GridSize',[6,7]);
    AzTile{i}=imtile(Az(2:end),'BorderSize',1,'GridSize',[6 7]);
    RGBaz{i}=uint8(zeros(size(ImAvgTile{i},1),size(ImAvgTile{i},2),3));
    RGBTemp=uint8(zeros(size(ImAvgTile{i},1),size(ImAvgTile{i},2)));
    IavgMin=quantile(ImAvgTile{i}(:),LowerLim);
    ImaxAdj=ImAvgTile{i}(:)-IavgMin;
    Ilim=quantile([ImaxAdj],UpperLim);
    Brightness=ImaxAdj/Ilim*255;
    Brightness(Brightness>255)=255;
    Brightness(Brightness<0)=0;
    RGBaz{i}(:,:,1)=reshape(interp1(AzRef,cmap(:,1),...
        AzTile{i}(:)).*Brightness,size(ImAvgTile{i},1),size(ImAvgTile{i},2));
    RGBaz{i}(:,:,2)=reshape(interp1(AzRef,cmap(:,2),...
        AzTile{i}(:)).*Brightness,size(ImAvgTile{i},1),size(ImAvgTile{i},2));
    RGBaz{i}(:,:,3)=reshape(interp1(AzRef,cmap(:,3),...
    AzTile{i}(:)).*Brightness,size(ImAvgTile{i},1),size(ImAvgTile{i},2));

    for j=1:41
        w=ImAvg{j};
        w(w<1)=0;
        w=w-1;
        w(w<0)=0;
        w=w.^2;
        w=w/sum(w(:));
        Cx=sum(cosd(Az{j}*2).*w,'all');
        Sy=sum(sind(Az{j}*2).*w,'all');
        CircVar(i,j)=1-sqrt(Cx^2+Sy^2);
    end
    subplot(1,2,1)
    imshow(RGBaz{i},[])
    hold on
    xPosLine=linspace(.5,size(RGBaz{i},2)-.5,8);
    yPosLine=linspace(.5,size(RGBaz{i},1)-.5,7);
    [yTs,xTs]=meshgrid(yPosLine(1:(end-1)),xPosLine(1:(end-1)));
    for j=1:length(xPosLine)
        plot(xPosLine(j)*[1 1],[min(yPosLine) max(yPosLine)],'w')
    end
    for j=1:length(yPosLine)
        plot([min(xPosLine) max(xPosLine)],yPosLine(j)*[1 1],'w')
    end
    for j=1:(numel(xTs)-1)
        text(xTs(j),yTs(j),[' ' num2str(round(tExp(j)*100),'%2.f') '%'],'Color','w','FontWeight','Bold',...
            'VerticalAlignment','top')
    end
    plot([3 3+24],(yTs(1,2)-10)*[1 1],'w','LineWidth',1)
    
    subplot(1,2,2)
    colororder({'k','b'})
    yyaxis left
    plot(tExp,Area(i,:)*.0417^2,'ok')
    hold on
    ylabel('Area of Tension (mm2)')
    xlabel('Time min')
    set(gca,'FontSize',14,'FontName','Arial')
    grid on
    axis([0 max(tExp) 0 inf])
    axis square
    
    yyaxis right
    tLim=[find((Area(i,:)*.0417^2)>5,1),find((Area(i,:)*.0417^2)>5,1,'last')];
    CVlim=[0 max(CircVar(i,:))*1.1];
    if ~isempty(tLim)
%         patch(t(tLim([1 2 2 1])),[.5 .5 1 1],[254 254 225]/255,'FaceAlpha',.5)
        hold on
        Ind=(tLim(1)-1):tLim(2);
        Ind(Ind==0)=[];
        [rhoCV(i),pCV(i)]=corr(t(Ind)',CircVar(i,Ind)');
        [rhoA(i),pA(i)]=corr(t(Ind)',Area(i,Ind)');
        tFit=t(Ind)-t(Ind(1));
        try
            yyaxis right
            parCV(end+1,:)=simulannealbnd(@(par) CostCV(par,tFit',CircVar(i,Ind)'),...
                [0 .2 5],[-inf 0 0],[inf 20 inf],opt);
            plot(tFit+t(Ind(1)),1-(parCV(end,1)*exp(-(tFit)/parCV(end,2))+parCV(end,3)),'b');
            parA(end+1,:)=simulannealbnd(@(par) CostA(par,t',Area(i,:)'*.0417^2),...
                [0 1 5 15 5 t(Ind(1))],[0 0 0 0 0 -3],[inf 10 inf 60 100 100],opt);
%             subplot(1,2,2)
            yyaxis left
            hold on
%             plot(t,parA(end,1)*heaviside(t-parA(end,6)).*(1-exp(-(t-parA(end,6))/parA(end,2)) - ...
%                                 1./(1+exp(-(t-parA(end,6)-parA(end,4))/parA(end,5))))+parA(end,3),'-k');
            GoodInd=[GoodInd i];
            
        catch e
            keyboard
        end
    end
    yyaxis right
    plot(tExp,1-CircVar(i,:),'sb')
    ylabel('Alignment parameter')
    xlabel('Time min')
    set(gca,'FontSize',14,'FontName','Arial')
    grid on
    axis([0 .5 0 1])
    axis square
%     drawnow
    azCum=[azCum;AzTile{i}(:)];
    ImaxCum=[ImaxCum;ImAvgTile{i}(:)];
%     pause(1.5)
%     print(gcf,'-painters','-depsc',['Timelapse' num2str(i) '.eps'])
i
    figure(120)
    plot(Area(i,:)*.0417^2,CircVar(i,:),'ok');hold on
    AllA=[AllA Area(i,:)];
    AllR=[AllR 1-CircVar(i,:)];
end

IndGood=find((parA(:,6)>0) & ((parA(:,6)+parA(:,4))<max(t)) & (parCV(:,2)<19) & (parCV(:,1)>0));