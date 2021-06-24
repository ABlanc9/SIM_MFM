clear;close all;clc
addpath('..\bfmatlab')

%% Load Data
% Points to experiment 2 in the replication data
Folder='D:\SIM Data Backup 2019\December2019 SIM MFM replicate\Fibroblasts 4pN';
a=dir(Folder);a=a(3:end);

subdirinfo = cell(length(a));
for K = 1 : length(a)
  thisdir = a(K).name;
  suba{K} = dir(fullfile(Folder,thisdir, 'Nikon Recon*.nd2'));
end
AllIms=vertcat(suba{:});

for i=1:length(AllIms)
    data=bfopen(fullfile(AllIms(i).folder,AllIms(i).name));
    if i==5
        data{1}=data{1}([2 1],:);
    end
    Im{i,2}=data{1}{2,1};
    Im{i,4}=data{1}{1,1};
    Im488=dir([AllIms(i).folder,'\*488*']);
    Im561=dir([AllIms(i).folder,'\*561*']);
    if i==1
        Im561=Im561(3);
    elseif i==4
        Im488=Im488(1);
    elseif i==6
        Im561=Im561(2);
        Im488=Im488(2);
    end
    
    if (length(Im561)*length(Im488))~=1
        keyboard
    else
        data561(i,:)=bfopen(fullfile(Im561(1).folder,Im561(1).name));
        data488(i,:)=bfopen(fullfile(Im488(1).folder,Im488(1).name));
    end
end

%% Create Azimuth map and reformat WF images
for j=1:length(AllIms)
    % 488
    for i=1:3
        Row=(1:512)+(i-1)*512;
        for k=1:5
            Col=(1:512)+(k-1)*512;
            ImLoad488{i}(:,:,k)=double(data488{j,1}{1}(Row,Col))-200;
            ImLoad561{i}(:,:,k)=double(data561{j,1}{1}(Row,Col))-200;
        end
        ImAvg488{i}(:,:,j)=sum(ImLoad488{i},3);
        ImAvg561{i}(:,:,j)=sum(ImLoad561{i},3);
    end
    Im{j,3}=(ImAvg488{1}(:,:,j)+ImAvg488{2}(:,:,j)+ImAvg488{3}(:,:,j))/3;

    Thresh=1.6;

    cmap=hsv(64);
    AzRef=linspace(0,180,64)';
    
    ImaxAllSR{j}=Im{j,2};

    Iavg=(ImAvg561{1}(:,:,j)+ImAvg561{2}(:,:,j)+ImAvg561{3}(:,:,j))/3;
    I1=ImAvg561{1}(:,:,j)-Iavg;
    I3=ImAvg561{3}(:,:,j)-Iavg;
    Az=rad2deg(atan2(I1-I3*cosd(120),I3*sind(120)))/2+90;
    Az(Az<0)=Az(Az<0)+360;
    A=I3./cosd(2*(Az-90));
    c=ImAvg561{3}(:,:,j)-A.*cosd(Az-90).^2-1;
    Imax=A*2+c;
    Az=Az-13;
    Az(Az<0)=Az(Az<0)+180;

    % Create RGB image WF
    RGB=uint8(zeros(size(Imax,1),size(Imax,2),3));
    ImaxAdj=Imax(:)-quantile(Imax(:),.35);
    Ilim=quantile([ImaxAdj],.995);
    Brightness=ImaxAdj/Ilim*255;
    Brightness(Brightness>255)=255;
    Brightness(Brightness<0)=0;
    RGB(:,:,1)=reshape(interp1(AzRef,cmap(:,1),...
        Az(:)).*Brightness,size(Imax,1),size(Imax,2));
    RGB(:,:,2)=reshape(interp1(AzRef,cmap(:,2),...
        Az(:)).*Brightness,size(Imax,1),size(Imax,2));
    RGB(:,:,3)=reshape(interp1(AzRef,cmap(:,3),...
        Az(:)).*Brightness,size(Imax,1),size(Imax,2));
    Im{j,1}=RGB;
    
    
    % Create RGB image SR
    RGB2=uint8(zeros(size(Im{j,2},1),size(Im{j,2},2),3));
    ImaxAdj=double(Im{j,2}(:))-double(quantile(Im{j,2}(:),.35));
    Ilim=quantile([ImaxAdj],.995);
    Brightness=ImaxAdj/Ilim*255;
    Brightness(Brightness>255)=255;
    Brightness(Brightness<0)=0;
    Az2=imresize(Az,2,'nearest');
    RGB2(:,:,1)=reshape(interp1(AzRef,cmap(:,1),...
        Az2(:)).*Brightness,size(Imax,1)*2,size(Imax,2)*2);
    RGB2(:,:,2)=reshape(interp1(AzRef,cmap(:,2),...
        Az2(:)).*Brightness,size(Imax,1)*2,size(Imax,2)*2);
    RGB2(:,:,3)=reshape(interp1(AzRef,cmap(:,3),...
        Az2(:)).*Brightness,size(Imax,1)*2,size(Imax,2)*2);
    Im{j,2}=RGB2;
    
    Im{j,3}=Im{j,3}-quantile(Im{j,3}(:),.01);
    Im{j,4}=Im{j,4}-quantile(Im{j,4}(:),.01);
    
    Im{j,3}=uint8(double(Im{j,3})/quantile(double(Im{j,3}(:)),.999)*255);
    Im{j,3}(:,:,2)=Im{j,3}(:,:,1);
    Im{j,3}(:,:,1)=zeros(size(Im{j,3}(:,:,1)));
    Im{j,3}(:,:,3)=zeros(size(Im{j,3}(:,:,1)));
    Im{j,4}=uint8(double(Im{j,4})/quantile(double(Im{j,4}(:)),.999)*255);
    Im{j,4}(:,:,2)=Im{j,4}(:,:,1);
    Im{j,4}(:,:,1)=zeros(size(Im{j,4}(:,:,1)));
    Im{j,4}(:,:,3)=zeros(size(Im{j,4}(:,:,1)));
    ImaxAll{j}=Imax;
end

%% Display
for i=1:10
    figure('OuterPosition',[    0.0006    0.3806    1.5340    0.3944]*1000)
    for j=1:4
        subplot(2,4,j)
        imshow(Im{i,j},[])
    end
    
end

save('All Images.mat','Im','ImaxAll','ImaxSR')