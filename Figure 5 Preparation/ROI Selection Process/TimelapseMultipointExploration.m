 clear;close all;clc
 
 %% Load Data and normalize
 addpath('C:\Files\Research\.TJ Focal Adhesion Analysis\Code\bfmatlab\bfmatlab')
 File{1}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 1.nd2'];
 File{2}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 2.nd2'];
 File{3}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 3.nd2'];
load('..\..\..\Data\2020-01-30 SIM MFM replicate 3\Chroma Slide\CalibFile3D.mat')
for k=1:3
    reader=bfGetReader(File{k});
    for i=1:reader.getSeriesCount
        reader.setSeries(i-1);
        for j=1:reader.getImageCount
            data=bfGetPlane(reader,j);
            Im{i}(:,:,j+(k>1))=double(data-200)./CalibIm561;
            [i j k]
        end
        Im{i}=max(Im{i},[],3);
    end
end
data{1}{1}=data{1}{1}/mean(data{1}{1}(:));
data{1}{1}=data{1}{1}-quantile(data{1}{1},.001);
data{1}{1}(data{1}{1}<0)=0;
LowerLim=0.4;
LowerLimDipole=0.6;
UpperLim=0.99;

for i=1:3
    Row=(1:512)+(i-1)*512;
    for k=1:5
        Col=(1:512)+(k-1)*512;
        Im{i}(:,:,k)=data{1}{1}(Row,Col);
        Im{i}(:,:,k)=Im{i}(:,:,k);
    end
    ImAvg{i}=mean(Im{i},3);
end

%% Create and Display Montage
TargetCol=42:310;
TargetRow=259:503;
Thresh=1.6;

for i=1:3
    Im{i}=Im{i}(TargetRow,TargetCol,:);
    ImRow{i}=[];
    for j=1:5
        ImRow{i}=[ImRow{i} Im{i}(:,:,j)];
    end
end
Montage=vertcat(ImRow{:});

figure('OuterPosition',[0.1162    0.3346    1.1288    0.5096]*1000);
subplot(1,5,1:4)
imshow(Montage,[]);

%% Calculate Theta, Phi, and 
Mask=[];
for j=1:3
    Im{j}=mean(Im{j},3);
end
subplot(1,5,5)
imshow(vertcat(Im{:}),[])

alpha0=77;
Iavg=(Im{1}+Im{2}+Im{3})/3;
%     I1=Im{1}-Iavg;
%     I3=Im{3}-Iavg;
%     Az=rad2deg(atan2(I1-I3*cosd(120),I3*sind(120)))/2+90;
%     Az(Az<0)=Az(Az<0)+360;
%     A=I3./cosd(2*(Az-90));
%     c=Im{3}-A.*cosd(Az-90).^2;
%     c=c-A;
%     A=A*2;
%     Imax=A+c;
%     Th=acosd(sqrt((c./Imax-.069)/(1-.069)));
I1=Iavg-Im{1};
I2=Iavg-Im{2};
Az=atan2d((I2-I1*cosd(120)),I1*sind(120))/2+alpha0;
Az(Az<0)=Az(Az<0)+180;
A=2*I1./cosd(2*(alpha0-Az));
c=Im{1}-A.*sind(alpha0-Az).^2;
ccorner=mean(c([1:40 (end-39):end],[1:40 (end-39):end]),'all');
c=c-ccorner;
Imax=A+c;
Imax(Imax<0)=0;
Th=real(acosd(sqrt((c./Imax-.069)/(1-.069))));

%% Create RGB image for Azimuthal Angle
figure('OuterPosition',[0.1162    0.3346    1.1288    0.5096]*1000);
cmap=hsv(64);
AzRef=linspace(0,180,64)';
RGBaz=uint8(zeros(size(Imax,1),size(Imax,2),3));
RGBTemp=uint8(zeros(size(Imax,1),size(Imax,2)));
ImaxAdj=Imax(:)-quantile(Imax(:),LowerLim);
Ilim=quantile([ImaxAdj],UpperLim);
Brightness=ImaxAdj/Ilim*255; b
Brightness(Brightness>255)=255;
Brightness(Brightness<0)=0;
RGBaz(:,:,1)=reshape(interp1(AzRef,cmap(:,1),...
    Az(:)).*Brightness,size(Imax,1),size(Imax,2));
RGBaz(:,:,2)=reshape(interp1(AzRef,cmap(:,2),...
    Az(:)).*Brightness,size(Imax,1),size(Imax,2));
RGBaz(:,:,3)=reshape(interp1(AzRef,cmap(:,3),...
    Az(:)).*Brightness,size(Imax,1),size(Imax,2));
subplot(1,5,2:3)
imshow(RGBaz,[])

%% Create RGB image for Theta
cmap=jet(64);
ThRef=linspace(0,90,64)';
RGBth=uint8(zeros(size(Imax,1),size(Imax,2),3));

RGBth(:,:,1)=reshape(interp1(ThRef,cmap(:,1),...
    Th(:)).*Brightness,size(Imax,1),size(Imax,2));
RGBth(:,:,2)=reshape(interp1(ThRef,cmap(:,2),...
    Th(:)).*Brightness,size(Imax,1),size(Imax,2));
RGBth(:,:,3)=reshape(interp1(ThRef,cmap(:,3),...
    Th(:)).*Brightness,size(Imax,1),size(Imax,2));
subplot(2,5,6)
imshow(RGBth,[])

%% Display Imax
subplot(2,5,1)
imshow(reshape(Brightness,size(Imax,1),size(Imax,2)),[])

%% Display Dipole Map
subplot(1,5,4:5)

cmap=hot(24);
ThInt=round(Th/90*24);
Scale=4;
Ax{1}=round([77.6951  107.6951  170.1452  200.1452]);
Ax{2}=round([189.8004  219.8004   95.4446  125.4446]);
Ax{3}=round([144.5698  174.5698    8.4693   38.4693]);
Ax{4}=round([138.4029  168.4029  118.9655  148.9655]);
for i=1:size(cmap,1)
    [yLoc,xLoc]=find(reshape((Imax(:)>quantile(Imax(:),LowerLimDipole)) & (i==ThInt(:)),size(Imax,1),size(Imax,2)));
    Ind=find((Imax(:)>quantile(Imax(:),LowerLimDipole)) & (i==ThInt(:)));
    Len=double(Imax(Ind))/Ilim*Scale;
    quiver(xLoc,yLoc,Len.*cosd(Az(Ind)),-Len.*sind(Az(Ind)),'Color',...
        cmap(i,:),'ShowArrowHead','off','AutoScale','off','LineWidth',1)
    hold on
    quiver(xLoc,yLoc,-Len.*cosd(Az(Ind)),Len.*sind(Az(Ind)),'Color',...
        cmap(i,:),'ShowArrowHead','off','AutoScale','off','LineWidth',1)
end

for i=1:4
    plot(Ax{i}([1 2 2 1 1]),Ax{i}([3 3 4 4 3]),'w','LineWidth',1)
end

axis equal
axis([0 269 0 245])

set(gca,'Color',[1 1 1]*.5,'YDir','reverse');
box off
figure
for j=1:4
    subplot(2,2,j)
    
    for i=1:size(cmap,1)
        [yLoc,xLoc]=find(reshape((Imax(:)>quantile(Imax(:),LowerLimDipole)) & (i==ThInt(:)),size(Imax,1),size(Imax,2)));
        Ind=find((Imax(:)>quantile(Imax(:),LowerLimDipole)) & (i==ThInt(:)));
        Len=double(Imax(Ind))/Ilim*Scale;
        quiver(xLoc,yLoc,Len.*cosd(Az(Ind)),-Len.*sind(Az(Ind)),'Color',...
            cmap(i,:),'ShowArrowHead','off','AutoScale','off','LineWidth',1)
        hold on
        quiver(xLoc,yLoc,-Len.*cosd(Az(Ind)),Len.*sind(Az(Ind)),'Color',...
            cmap(i,:),'ShowArrowHead','off','AutoScale','off','LineWidth',1)
    end
    axis(Ax{j});
    axis square
    set(gca,'Color',[1 1 1]*.5,'YDir','reverse');
    box off
end

figure
subplot(1,2,1)
imshow(reshape(Brightness,size(Imax,1),size(Imax,2)),[])
Quant=[.97 .92 .755];
for i=1:3
    [~,ImaxInd(i)]=min(abs(Imax(:)-quantile(Imax(:),Quant(i))));
    
end
ImaxInd(3)=52027;
[ImaxRow,ImaxCol]=ind2sub(size(Imax),ImaxInd);
hold on
plot(ImaxCol,ImaxRow,'oy')

subplot(1,2,2)
Colr={'r','g','b'};
for i=1:3
    plot(77+(-60:60:60),A(ImaxInd(i))*sind(77+(-60:60:60)-Az(ImaxInd(i))).^2+c(ImaxInd(i)),[Colr{i} 'o'])
    hold on
    plot(0:180,A(ImaxInd(i))*sind((0:180)-Az(ImaxInd(i))).^2+c(ImaxInd(i)),[Colr{i} '-'])
end
axis([0 180 0 2.2])
xlabel('\phi excitation')
ylabel('Intensity (a.u.)')
grid on
set(gca,'FontSize',14,'FontName','Arial')
