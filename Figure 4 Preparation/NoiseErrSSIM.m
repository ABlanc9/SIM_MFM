clear;close all;clc

%% Initialize Parameters
ImaxAll=[100 300 1000 3000 10000];
load('TurboMap.mat','turbomap')
Nsamp=1000;

%% Initialize orientations
% For simulation
E{1}=[cosd(60) sind(60) 0]; 
E{2}=[cosd(120) sind(120) 0];
E{3}=[cosd(0) sind(0) 0];

Is1=randn(10^5,1);
Is2=randn(10^5,1);
Is3=randn(10^5,1);
UnStackFrac=0.1;
AdjFactor=1/(1-1/3*UnStackFrac);



% For display

%% Run MC simulations
for kk=1:length(ImaxAll)
    Imax=ImaxAll(kk);
    
    FhatAll=SpiralSampleSphere(Nsamp*pi/deg2rad(60)*8);
    [Faz,Fel]=cart2sph(FhatAll(:,1),FhatAll(:,2),FhatAll(:,3));
    DiscInd=(Fel<0) | (Faz<0) | (Faz>(deg2rad(60)/2));
    FhatAll(DiscInd,:)=[];
    FelAdd=linspace(0,pi/2,round(Nsamp/20));
    [FxAdd1,FyAdd1,FzAdd1]=sph2cart(zeros(size(FelAdd(2:end))),FelAdd(2:end),ones(size(FelAdd(2:end))));
    [FxAdd2,FyAdd2,FzAdd2]=sph2cart(zeros(size(FelAdd))+(deg2rad(60)/2),...
        FelAdd,ones(size(FelAdd)));
    FhatAll=[FhatAll;[FxAdd1' FyAdd1' FzAdd1'];[FxAdd2' FyAdd2' FzAdd2']];
    FazAdd=linspace(0,deg2rad(60)/2,round(Nsamp/20));
    FxAdd3=cos(FazAdd);
    FyAdd3=sin(FazAdd);
    FzAdd3=zeros(size(FazAdd));
    FhatAll=[FhatAll;[FxAdd3' FyAdd3' FzAdd3']];
    [FazAll,FelAll]=cart2sph(FhatAll(:,1),FhatAll(:,2),FhatAll(:,3));
    FazAll=rad2deg(FazAll);
    FelAll=rad2deg(FelAll);

    for i=1:size(FhatAll,1)
        Imean(1)=Imax*AdjFactor*(norm(cross(E{1},FhatAll(i,:)))^2*(1-UnStackFrac) + 2/3*UnStackFrac);
        Imean(2)=Imax*AdjFactor*(norm(cross(E{2},FhatAll(i,:)))^2*(1-UnStackFrac) + 2/3*UnStackFrac);
        Imean(3)=Imax*AdjFactor*(norm(cross(E{3},FhatAll(i,:)))^2*(1-UnStackFrac) + 2/3*UnStackFrac);
        Istd=sqrt(Imean+200);
        I1=Is1*Istd(1)+Imean(1);I1(I1<0)=0;
        I2=Is2*Istd(2)+Imean(2);I2(I2<0)=0;
        I3=Is3*Istd(3)+Imean(3);I3(I3<0)=0;

        Iavg=(I1+I2+I3)/3;
        y1=I1-Iavg;
        y3=I3-Iavg;

        Az=rad2deg(atan2(y1-y3*cosd(120),y3*sind(120)))/2+90;
%         Az(Az>(FazAll(i)+90))=Az(Az>(FazAll(i)+90))-180;
        
        A=2*y3./cosd(2*(Az-90));
        c=I3-A.*cosd(Az-90).^2;
        ImaxPred=A+c;
        Th=rad2deg(acos(sqrt((c./ImaxPred-.069)/(1-.069))));
        
        AzErr=Az-FazAll(i);
        AzErr(AzErr<-90)=AzErr(AzErr<-90)+180;
        AzErr(AzErr>90)=AzErr(AzErr>90)-180;
        AvgAzErr(i)=mean(AzErr);
        AvgAbsAzErr(i)=mean(abs(AzErr));
        
        ThErr=real(Th-(90-FelAll(i)));
        AvgThErr(i)=mean(ThErr);
        AvgAbsThErr(i)=mean(abs(ThErr));

        ImaxRelErr(i)=mean(abs(ImaxPred-Imax)/Imax);
        
        i/size(FhatAll,1)
    end
    
    %% Display
    [x,y,z]=sphere(60);
    x=x(31:end,:);
    y=y(31:end,:);
    z=z(31:end,:);
    [azGrid,elGrid]=cart2sph(x,y,z);
    AngSpace=deg2rad(60);
    FazAll=deg2rad(FazAll);
    FelAll=deg2rad(FelAll);

    azGrid2=abs(mod(azGrid,AngSpace)-AngSpace/2);
    FazAll(FazAll==0)=-0.000001;
    FelAll(FelAll==0)=-0.000001;
    FelAll(FelAll>(pi/2-10^-10))=pi/2+0.000001;
    FazAll(FazAll>(deg2rad(30)-10^-10))=deg2rad(30)+0.00001;
    azEquator=linspace(0,2*pi,300);
    figure(1)
    subplot(1,5,kk)
    AvgAbsAzErrGrid=knnimpute(griddata(FazAll,FelAll,AvgAbsAzErr,azGrid2,elGrid));
    surf(x,y,z,log10(AvgAbsAzErrGrid),'EdgeColor','none')
    view([180-45   30.0000])
    axis equal
    hold on
    plot(cos(azEquator),sin(azEquator),'k','LineWidth',2)
    scatter3([1 0 0],[0 1 0],[0 0 1],'ko','LineWidth',2,'MarkerFaceColor','flat')
    axis off
    h=colorbar('southoutside');
    caxis(log10([.2 45]))
    colormap(turbomap)
    set(h,'Ticks',log10([0.3 1 3 10 30 45]),'TickLabels',{'0.3','1','3','10','30','45'})
    ylabel(h,'Error')
    
    
    figure(2)
    subplot(1,5,kk)
    AvgAzErrGrid=knnimpute(griddata(FazAll,FelAll,AvgAzErr,azGrid2,elGrid));
    surf(x,y,z,AvgAzErrGrid,'EdgeColor','none')
    view([180-45   30.0000])
    axis equal
    hold on
    plot(cos(azEquator),sin(azEquator),'k','LineWidth',2)
    scatter3([1 0 0],[0 1 0],[0 0 1],'ko','LineWidth',2,'MarkerFaceColor','flat')
    axis off
    h=colorbar('southoutside');
    caxis([-1 1]/2)
    colormap(turbomap)
    set(h,'Ticks',[-0.4:.2:.4],'TickLabels',{'-0.4','-0.2','0','.2','.4','.5'})
    ylabel(h,'Error')
    
    
    figure(3)
    subplot(1,5,kk)
    AvgAbsThErrGrid=knnimpute(griddata(FazAll,FelAll,AvgAbsThErr,azGrid2,elGrid));
    surf(x,y,z,log10(AvgAbsThErrGrid),'EdgeColor','none')
    view([180-45   30.0000])
    axis equal
    hold on
    plot(cos(azEquator),sin(azEquator),'k','LineWidth',2)
    scatter3([1 0 0],[0 1 0],[0 0 1],'ko','LineWidth',2,'MarkerFaceColor','flat')
    axis off
    h=colorbar('southoutside');
    caxis(log10([.3 15]))
    colormap(turbomap)
    set(h,'Ticks',log10([0.3 1 3 10 30 45]),'TickLabels',{'0.3','1','3','10','30','45'})
    ylabel(h,'Error')
    
    
    figure(4)
    subplot(1,5,kk)
    AvgThErrGrid=knnimpute(griddata(FazAll,FelAll,AvgThErr,azGrid2,elGrid));
    surf(x,y,z,AvgThErrGrid,'EdgeColor','none')
    view([180-45   30.0000])
    axis equal
    hold on
    plot(cos(azEquator),sin(azEquator),'k','LineWidth',2)
    scatter3([1 0 0],[0 1 0],[0 0 1],'ko','LineWidth',2,'MarkerFaceColor','flat')
    axis off
    h=colorbar('southoutside');
    caxis([-5 10])
    colormap(turbomap)
%     set(h,'Ticks',[-0.4:.2:.4],'TickLabels',{'-0.4','-0.2','0','.2','.4','.5'})
    ylabel(h,'Error')
    
    figure(5)
    subplot(2,4,1)
    Ind=find(z==0);Ind=Ind(2:(end-1));
    plot(180/pi*azGrid(Ind),AvgAbsAzErrGrid(Ind))
    hold on
    Rg(kk,1)=range(AvgAbsAzErrGrid(Ind));
    axis square
    grid on
    axis([-180 180 0 7.5])
    xlabel('f')
    ylabel('Abs Az Err')
    set(gca,'XTick',[-180:90:180])
    
    subplot(2,4,2)
    plot(180/pi*azGrid(Ind),AvgAbsThErrGrid(Ind))
    hold on
    Rg(kk,2)=range(AvgAbsThErrGrid(Ind));
    Rg(kk,4)=range(AvgThErrGrid(Ind));
    Rg(kk,3)=range(AvgAzErrGrid(Ind));
    axis square
    grid on
    axis([-180 180 0 10])
    xlabel('f')
    ylabel('Abs Az Err')
    set(gca,'XTick',[-180:90:180])
    
    
    Avg(kk,1)=mean(AvgAbsAzErrGrid(Ind));
    Avg(kk,2)=mean(AvgAbsThErrGrid(Ind));
    Avg(kk,4)=mean(AvgThErrGrid(Ind));
    Avg(kk,3)=mean(AvgAzErrGrid(Ind));
%     axis square
    
    subplot(2,4,3)
    plot(180/pi*azGrid(Ind),AvgThErrGrid(Ind))
    hold on
    grid on
    axis([-180 180 -10 0])
    xlabel('f')
    ylabel('Abs Az Err')
    set(gca,'XTick',[-180:90:180])
    
    subplot(2,4,4)
    plot(180/pi*azGrid(Ind),AvgAzErrGrid(Ind))
    hold on
    grid on
    axis([-180 180 -.08 .06])
    xlabel('f')
    ylabel('Abs Az Err')
    set(gca,'XTick',[-180:90:180])
    
    
    subplot(2,4,5)
    Ind=find(y==0);Ind=Ind(2:(end-1));
    [Sorted]=sortrows([elGrid(Ind),Ind]);
    Ind=Sorted(:,2);
    Ind([0;diff(Sorted(:,1))]==0)=[];
    plot(180/pi*(pi/2-elGrid(Ind)),AvgThErrGrid(Ind)+180/pi*(pi/2-elGrid(Ind)))
    hold on
    axis square
    grid on
    axis([0 90 0 90])
    xlabel('f')
    ylabel('Abs Az Err')
    set(gca,'XTick',[0 30 60 90],'YTick',[0 30 60 90])
    if kk==5;plot([0 90],[0 90],'k');end
end
subplot(2,12,[16 17 18 19])
semilogx(ImaxAll,Rg,'o-')
xlabel('Imax')
grid on
ylabel('rE')

subplot(2,12,[21 22 23 24])
semilogx(ImaxAll,Avg,'o-')
xlabel('Imax')
grid on
ylabel('AE')