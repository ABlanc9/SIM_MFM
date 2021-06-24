clear;close all;clc
addpath('..\bfmatlab')
File='F:\2019-04-05 Bead SIM experiment\4-19-19.nd2';
% File='F:\2019-04-05 Bead SIM experiment\04052019\Bodipy\Captured 2D SIM 561 2.nd2';

%% Extract Data
data=bfopen(File);
data=double(data{1}{1});

for i=1:3
    
    Row=(1:512)+(i-1)*512;
    for k=1:3
        Col=(1:512)+(k-1)*512;
        Im{i}(:,:,k)=data(Row,Col);
        Im{i}(:,:,k)=Im{i}(:,:,k)/mean2(Im{i}(:,:,k));
    end
    ImAvg{i}=mean(Im{i},3);
end

%% Display Raw Data
figure
subplot(1,2,1)
imshow(data/mean2(data),[])
c=colorbar('southoutside');
ylabel(c,'I (a.u.)')
hold on;
plot([0 1536],[512 512;1024 1024]','w','LineWidth',1)
plot([512 512],[0 1536],'w',[1024 1024],[0 1536],'w','LineWidth',1)
set(gca,'FontSize',14,'FontName','Cambria Math')

%% Display Averaged Data
subplot(1,4,3)
imshow(vertcat(ImAvg{:}),[]);
hold on
plot([0 512],[512 512],'w',[0 512],[1024 1024],'w','LineWidth',1)
c=colorbar('southoutside');
ylabel(c,'I (a.u.)')
set(gca,'FontSize',14,'FontName','Cambria Math')

%% Run image-wide calculations
Iavg=(ImAvg{1}+ImAvg{2}+ImAvg{3})/3;
I1=ImAvg{1}-Iavg;
I3=ImAvg{3}-Iavg;
Az=rad2deg(atan2(I1-I3*cosd(120),I3*sind(120)))/2+90;
Az(Az<0)=Az(Az<0)+360;
A=I3./cosd(2*(Az-90));
c=ImAvg{3}-A.*cosd(Az-90).^2;
Imax=A+c;
Pol=Imax./c;

%% Display image-wide calculations
subplot(3,4,4)
imshow(Imax,[]);
c=colorbar;
ylabel(c,'Imax (a.u.)')
set(gca,'FontSize',14,'FontName','Cambria Math')

subplot(3,4,8)
imshow(Az,[]);
c=colorbar;
ylabel(c,'phi (a.u.)')
colormap(gca,'hsv')
set(gca,'FontSize',14,'FontName','Cambria Math')

subplot(3,4,12)
imshow(Pol,[])
c=colorbar;
ylabel(c,'Polarization Factor (a.u.)')
colormap(gca,'parula')
set(gca,'FontSize',14,'FontName','Cambria Math')

%% Run Calculations on Beads
[cC,cR] = imfindcircles(Iavg,[50 150]/2);
[x,y]=meshgrid(1:512,1:512);
ThRef=linspace(-pi,pi,50);
dTh=diff(ThRef(1:2));
for i=1:3
    f{i}=figure;
end

Mark={'o','d'};
for i=1:2
    % Identify region of interest
    dx=x-cC(i,1);
    dy=y-cC(i,2);
    r=sqrt(dx.^2+dy.^2);
    Th=atan2(dy,dx);
    InRange=find(abs(r-cR(i))<2.5);
    
    Th=Th(InRange);
    I0=ImAvg{3}(InRange);
    I60=ImAvg{1}(InRange);
    I120=ImAvg{2}(InRange);
    
%     figure(f{4})
%     subplot(1,2,i)
%     plot(rad2deg(Th),[I0 I60 I120],'.') 
    
    % Run calculations within region of interest
    Cx=cosd(Az(InRange)*2);
    Sy=sind(Az(InRange)*2);
    for j=1:(length(ThRef)-1)
        Ind=(Th>ThRef(j)) & (Th<ThRef(j+1));
        Ind2=InRange(Ind);
        AvgImax(j)=mean(Imax(Ind2));
        AvgAz(j)=atan2(mean(Sy(Ind)),mean(Cx(Ind)))/2;
        AvgPol(j)=mean(Pol(Ind2));
        
        AvgI(j,1)=mean(I0((Th>ThRef(j)) & (Th<ThRef(j+1))));
        AvgI(j,2)=mean(I60((Th>ThRef(j)) & (Th<ThRef(j+1))));
        AvgI(j,3)=mean(I120((Th>ThRef(j)) & (Th<ThRef(j+1))));
    end
    
    %% Display radial analysis
    figure(f{1})
    subplot(2,4,2+(i-1)*4)
    plot(rad2deg(ThRef(1:(end-1))+dTh),AvgI(:,1),'.','MarkerSize',17,'LineWidth',1)
    FO{1+(i-1)*3}=fit(rad2deg(ThRef(1:(end-1))+dTh)',AvgI(:,1),'A*cosd(x-alpah)^2+c');
    hold on
    plot(rad2deg(ThRef(1:(end-1))+dTh),FO{1+(i-1)*3}(rad2deg(ThRef(1:(end-1))+dTh)),'k','LineWidth',1)
    axis([-180 180 3 12])
    grid on;set(gca,'XTick',-180:90:180,'FontSize',14,'FontName','Arial')
    
    subplot(2,4,3+(i-1)*4)
    plot(rad2deg(ThRef(1:(end-1))+dTh),AvgI(:,2),'.','MarkerSize',17,'LineWidth',1)
    FO{2+(i-1)*3}=fit(rad2deg(ThRef(1:(end-1))+dTh)',AvgI(:,2),'A*cosd(x-alpah)^2+c');
    hold on
    plot(rad2deg(ThRef(1:(end-1))+dTh),FO{2+(i-1)*3}(rad2deg(ThRef(1:(end-1))+dTh)),'k','LineWidth',1)
    axis([-180 180 3 12])
    grid on;set(gca,'XTick',-180:90:180,'FontSize',14,'FontName','Arial')
    
    subplot(2,4,4+(i-1)*4)
    plot(rad2deg(ThRef(1:(end-1))+dTh),AvgI(:,3),'.','MarkerSize',17,'LineWidth',1)
    FO{3+(i-1)*3}=fit(rad2deg(ThRef(1:(end-1))+dTh)',AvgI(:,3),'A*cosd(x-alpah)^2+c');
    hold on
    plot(rad2deg(ThRef(1:(end-1))+dTh),FO{3+(i-1)*3}(rad2deg(ThRef(1:(end-1))+dTh)),'k','LineWidth',1)
    axis([-180 180 3 12])
    grid on;set(gca,'XTick',-180:90:180,'FontSize',14,'FontName','Arial')
    
    subplot(2,4,1)
    imshow(Imax,[])
    hold on;
    viscircles(cC,cR,'EdgeColor','r');
    plot(cC(:,1),cC(:,2),'rx','LineWidth',1)
    axis([240 420 20 200])
    
    subplot(2,4,5)
    Disp=(abs(r-cR(i))<2.5).*Az;
    Disp(Disp==0)=NaN;
    surf(Disp,'EdgeColor','none')
    set(gca,'YDir','reverse')
    colormap(gca,'hsv')
    axis([240 420 20 200])
    set(gca,'Color','black','XTick',[],'YTick',[])
    
    figure(f{2})
    subplot(1,3,1)
    plot(rad2deg(ThRef(1:(end-1))+dTh),AvgImax,Mark{i},'MarkerSize',7,'LineWidth',1)
    hold on
    if i==2
        plot([-180 180],[1 1]*mean(AvgImax),'k','LineWidth',1)
    end
    axis([-180 180 5 13])
    grid on;set(gca,'XTick',-180:90:180,'FontSize',14,'FontName','Arial')
    axis square
    
    subplot(1,3,2)
    plot(rad2deg(ThRef(1:(end-1))+dTh),rad2deg(AvgAz),Mark{i},'MarkerSize',7,'LineWidth',1)
    hold on
    axis([-180 180 -90 90])
    if i==2
        plot([-180 -90],[0 -90],'k',[-90 90],[90 -90],'k',[90 180],[90 0],'k','LineWidth',1)
    end
    grid on;set(gca,'XTick',-180:90:180,'FontSize',14,'FontName','Arial')
    axis square
    
    subplot(1,3,3)
    plot(rad2deg(ThRef(1:(end-1))+dTh),AvgPol,Mark{i},'MarkerSize',7,'LineWidth',1)
    hold on
    if i==2
        plot([-180 180],[1 1]*mean(AvgPol),'k','LineWidth',1)
    end
    axis([-180 180 1 2])
    grid on;set(gca,'XTick',-180:90:180,'FontSize',14,'FontName','Arial')
    axis square
    
end