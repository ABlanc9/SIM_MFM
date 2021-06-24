clear;close all;clc
 %% Load Data and normalize
 addpath('..\bfmatlab')
 File=['..\SampleAcquisition3D.nd2'];
load('..\CalibFile3D.mat')
data=bfopen(File);
data{1}{1}=double(data{1}{1})./CalibIm561;
data{1}{1}=data{1}{1}/mean(data{1}{1}(:));
data{1}{1}=data{1}{1}-quantile(data{1}{1},.5);
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
Im=ImAvg;

%% Create and Display Montage
TargetRow=259:508;
TargetCol=56:305;

for i=1:3
    Im{i}=Im{i}(TargetRow,TargetCol);
end

Thresh=1.6;

cmap=hsv(64);
AzRef=linspace(0,180,64)';

Iavg=(Im{1}+Im{2}+Im{3})/3;
I1=Im{1}-Iavg;
I3=Im{3}-Iavg;
    Az=rad2deg(atan2(I1-I3*cosd(120),I3*sind(120)))/2+90;
    Az(Az<0)=Az(Az<0)+360;
    A=I3./cosd(2*(Az-90));
    c=Im{3}-A.*cosd(Az-90).^2-1;
    Imax=A*2+c;
    Az=Az+13;
    Az(Az<0)=Az(Az<0)+180;
    Az(Az>180)=Az(Az>180)-180;


% Create RGB image
RGB=uint8(zeros(size(Imax,1),size(Imax,2),3));
RGBTemp=uint8(zeros(size(Imax,1),size(Imax,2)));
ImaxAdj=Imax(:)-quantile(Imax(:),.35);
Ilim=quantile([ImaxAdj],.99);
Brightness=ImaxAdj/Ilim*255;
Brightness(Brightness>255)=255;
Brightness(Brightness<0)=0;
RGB(:,:,1)=reshape(interp1(AzRef,cmap(:,1),...
    Az(:)).*Brightness,size(Imax,1),size(Imax,2));
RGB(:,:,2)=reshape(interp1(AzRef,cmap(:,2),...
    Az(:)).*Brightness,size(Imax,1),size(Imax,2));
RGB(:,:,3)=reshape(interp1(AzRef,cmap(:,3),...
    Az(:)).*Brightness,size(Imax,1),size(Imax,2));
Wide=imresize(Imax,2);

figure
subplot(1,2,1)
imshow(RGB,[])

Imax=bfopen(['3D 10_Reconstructed.nd2']);
   Imax=double(Imax{1}{1});
   Imax=Imax((TargetRow(1)*2+3):(TargetRow(end)*2+4),(TargetCol(1)*2+3):(TargetCol(end)*2+4))
% Imax([(1:4) size(Imax,1)+(-3:0)],:)=[];
% Imax(:,[1:4 size(Imax,2)+(-3:0)])=[];
Az=imresize(Az,2,'nearest');

% Create RGB image
RGB=uint8(zeros(size(Imax,1),size(Imax,2),3));
RGBTemp=uint8(zeros(size(Imax,1),size(Imax,2)));
ImaxAdj=Imax(:)-quantile(Imax(:),.35);
Ilim=quantile([ImaxAdj],.99);
Brightness=ImaxAdj/Ilim*255;
Brightness(Brightness>255)=255;
Brightness(Brightness<0)=0;
RGB(:,:,1)=reshape(interp1(AzRef,cmap(:,1),...
    Az(:)).*Brightness,size(Imax,1),size(Imax,2));
RGB(:,:,2)=reshape(interp1(AzRef,cmap(:,2),...
    Az(:)).*Brightness,size(Imax,1),size(Imax,2));
RGB(:,:,3)=reshape(interp1(AzRef,cmap(:,3),...
    Az(:)).*Brightness,size(Imax,1),size(Imax,2));
subplot(1,2,2)
imshow(RGB,[])

Wide=Wide([5:end 1:4],:);
Wide=Wide(:,[5:end 1:4]);

% [xpt,ypt]=getpts;


figure
subplot(1,2,1)
imshow(Wide,[])
subplot(1,2,2)
imshow(Imax,[])
[CX,CY,~]=improfile();
Cwide=improfile(Wide,CX,CY);
Csim=improfile(Imax,CX,CY);
Cwide=(Cwide-min(Cwide))./max(Cwide-min(Cwide));
Csim=(Csim-min(Csim))./max(Csim-min(Csim));
figure;
R=sqrt((CX-CX(1)).^2+(CY-CY(1)).^2);
plot(R*41.7/1000,Cwide,'-o',R*41.7/1000,Csim,'-o','MarkerFaceColor','w','MarkerSize',6);
set(gca,'FontSize',14,'FontName','Arial')
grid on
xlabel('Distance (mm)')
ylabel('Intensity')
legend('Widefield','SIM')