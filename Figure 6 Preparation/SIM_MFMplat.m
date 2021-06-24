 clear;close all;clc
addpath('..\bfmatlab')

%% Assemble list of files
a=dir('D:\SIM Data Backup 2019\Jan 2020 SIM Replicate 3\platelet surface 2\*.nd2')
Disc=[];
for i=1:length(a)
    if sum(a(i).name=='_')
        Disc=[Disc i]
    end
end
a(Disc)=[];

%% Create Background correction images
dataBkrd2D=bfopen('D:\SIM Data Backup 2019\T-cell MFM May 14 2019\Fifth Surface\Multipoint 2D Background.nd2');
for i=1:size(dataBkrd2D,1)
    ImBkrd2D(:,:,i)=double(dataBkrd2D{i,1}{1})/median(double(dataBkrd2D{i,1}{1}),'all');
end
ImBkrd2D=imfilter(median(ImBkrd2D,3),fspecial('disk',15),'replicate');

dataBkrd3D=bfopen('D:\SIM Data Backup 2019\T-cell MFM May 14 2019\Fifth Surface\Multipoint 3D Background.nd2');
for i=1:size(dataBkrd3D,1)
    ImBkrd3D(:,:,i)=double(dataBkrd3D{i,1}{1})/median(double(dataBkrd3D{i,1}{1}),'all');
end
ImBkrd3D=imfilter(median(ImBkrd3D,3),fspecial('disk',15),'replicate');

PolDir=[60 120 0];

for j=1:length(a)
    %% Load File and background correct
    File=fullfile(a(j).folder,a(j).name);
    data=bfopen(File);
    if size(data{1}{1},1)==size(data{1}{1},2)
        data{1}{1}=double(data{1}{1})./ImBkrd2D;
        NumIM=3;
    else
        data{1}{1}=double(data{1}{1})./ImBkrd3D;
        NumIM=5;
    end
        
    for i=1:3
        Row=(1:512)+(i-1)*512;
        for k=1:NumIM
            Col=(1:512)+(k-1)*512;
            Im{i}(:,:,k)=double(data{1}{1}(Row,Col));
            Im{i}(:,:,k)=Im{i}(:,:,k)/mean2(Im{i}(:,:,k));
        end
        ImAvg{i}(:,:,j)=mean(Im{i},3);
    end
    
end

Thresh=1.6;

%% Show Images
cmap=hsv(64);
AzRef=linspace(0,180,64)';
alpha0=77;
figure
AzCum=[];ThCum=[];ImaxCum=[];
for i=1:length(a)
%     figure('OuterPosition',[0.1162    0.3346    1.1288    0.5096]*1000);
    TargetRow{i}=1:512;
    TargetCol{i}=1:512;
    Mask=[];
    for j=1:3
%         ImBkrd{j}=1;
        ImThis=double(ImAvg{j}(:,:,i));
        Im{j}=ImThis(TargetRow{i},TargetCol{i});
    end
    Iavg=(Im{1}+Im{2}+Im{3})/3;
    I1=Iavg-Im{1};
    I2=Iavg-Im{2};
    Az=atan2d((I2-I1*cosd(120)),I1*sind(120))/2+alpha0;
    Az(Az<0)=Az(Az<0)+180;
    A=2*I1./cosd(2*(alpha0-Az));
    c=Im{1}-A.*sind(alpha0-Az).^2-1;
    Imax=A+c;
    Imax(Imax<0)=0;
    Th=real(acosd(sqrt((c./Imax-.069)/(1-.069))));
    w=double(Imax);
    w(w<1)=0;
    w=w-1;
    w=w/sum(w(:));
    AvgTh(i)=sum(w(:).*Th(:));
    
    
    % Create RGB image
    RGB=uint8(zeros(size(Imax,1),size(Imax,2),3));
    RGBTemp=uint8(zeros(size(Imax,1),size(Imax,2)));
    ImaxAdj=Imax(:)-quantile(Imax(:),.25);
    Ilim=quantile([ImaxAdj],.96);
    Brightness=ImaxAdj/Ilim*255;
    Brightness(Brightness>255)=255;
    Brightness(Brightness<0)=0;
    RGB(:,:,1)=reshape(interp1(AzRef,cmap(:,1),...
        Az(:)).*Brightness,size(Imax,1),size(Imax,2));
    RGB(:,:,2)=reshape(interp1(AzRef,cmap(:,2),...
        Az(:)).*Brightness,size(Imax,1),size(Imax,2));
    RGB(:,:,3)=reshape(interp1(AzRef,cmap(:,3),...
        Az(:)).*Brightness,size(Imax,1),size(Imax,2));
    i/17
    figure(1)
    
    subplot(6,12,i+36)
    imshow(RGB)
        Mask=bwareafilt(imdilate(bwareaopen(Imax>.2,50),fspecial('disk',2)),1);
    BkrdMask=~imdilate(Mask,strel('disk',17)).*imdilate(Mask,strel('disk',21));
    [Y,X]=find(BkrdMask);
    AX=[max(min(X-5),1) min(max(X+5),512) max(min(Y-5),1) min(max(Y+5),512)];
    hold on
    axis(AX)
    axis off
    
    subplot(6,12,i)
    imshow(Imax,[0 1])
    hold on
    plot([5 29+24]+max(min(X-5),1),[10 10]+max(min(Y-5),1),'w','LineWidth',2)
    axis(AX)
    axis off
    
    subplot(6,12,i+48)
    imshow(Mask)
    axis(AX)
    axis off
    
    subplot(6,12,i+60)
    imshow(BkrdMask);
    axis(AX)
    axis off
    
    subplot(6,12,i+12)
    imshow(A,[0 1]);
    axis(AX)
    axis off
    
    subplot(6,12,i+24)
    imshow(c,[0 1]);
    axis(AX)
    axis off
    
%     imshow(
    
    Amean(i)=mean2(Mask.*A);
    cMean(i)=mean2(Mask.*(c+1));
    Abkrd(i)=mean2(BkrdMask.*A);
    cBkrd(i)=mean2(BkrdMask.*(c+1));
end
