 clear;close all;clc

addpath('..\bfmatlab')
% Refers to experiment 1
Folder='D:\SIM Data Backup 2019\Initial MTFM Test\4 pN human platelets no ADP 10 minutes after addition';
a=dir([Folder '\3D*.nd2']);

a=a([1:8 13 15:end]);
a(3)=[];

% BeadFile='E:\2019-05-01 SIM MFM\4-19-19.nd2';
PolDir=[60 120 0];

for j=1:length(a)
    File=fullfile(Folder,a(j).name);
    data=bfopen(File);
    for i=1:3
        Row=(1:512)+(i-1)*512;
        for k=1:5
            Col=(1:512)+(k-1)*512;
            Im{i}(:,:,k)=double(data{1}{1}(Row,Col));
            Im{i}(:,:,k)=Im{i}(:,:,k)/mean2(Im{i}(:,:,k));
        end
        ImAvg{i}(:,:,j)=mean(Im{i},3);
    end
    
end

figure
for i=1:3
    ImBkrd{i}=imfilter(median(ImAvg{i},3),fspecial('disk',71),'replicate');
    subplot(1,3,i)
    imshow(ImBkrd{i},[])
end
% 
% TargetRow={195:393,260:506};
% TargetCol={148:346,59:301};
% Thresh=[1.6 1.6 1.6 1.6 1.8 1.8 1.6 1.8 1.8 1.8 1.6;
% load('Checkpoint.mat')
load('TargetRowCol.mat','TargetRow','TargetCol')
Thresh=1.6;

cmap=hsv(64);
AzRef=linspace(0,180,64)';
alpha0=77;
figure
AzCum=[];ThCum=[];ImaxCum=[];
for i=1:17
%     figure('OuterPosition',[0.1162    0.3346    1.1288    0.5096]*1000);
    Mask=[];
    for j=1:3
        ImThis=double(ImAvg{j}(:,:,i))./double(ImBkrd{j});
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
    ImaxAdj=Imax(:)-quantile(Imax(:),.35);
    Ilim=quantile([ImaxAdj],.95);
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
    subplot(3,6,i)
    imshow(RGB)
    hold on
    plot([5 29+24]+5,[5 5]*2,'w','LineWidth',2)
    AzCum=[AzCum;Az(:)];
    ImaxCum=[ImaxCum;Imax(:)];
    ThCum=[ThCum;Th(:)];
end

Sorted=sortrows([AzCum ThCum ImaxCum]);
Npt=1500;
Avg1=imfilter(Sorted(Sorted(:,3)>1,2),ones(Npt,1)/Npt,'circular');
Avg2=imfilter(Sorted(Sorted(:,3)>2,2),ones(Npt,1)/Npt,'circular');
AvgHalf=imfilter(Sorted(Sorted(:,3)>.5,2),ones(Npt,1)/Npt,'circular');
MaxAvg=[max(AvgHalf) max(Avg1) max(Avg2)];
MinAvg=[min(AvgHalf) min(Avg1) min(Avg2)];


figure
subplot(1,2,1)
plot(imfilter(Sorted(Sorted(:,3)>.5,1),ones(Npt,1)/Npt,'replicate'),AvgHalf)
hold on;plot(imfilter(Sorted(Sorted(:,3)>1,1),ones(Npt,1)/Npt,'replicate'),Avg1)
hold on;plot(imfilter(Sorted(Sorted(:,3)>2,1),ones(Npt,1)/Npt,'replicate'),Avg2)
legend('67.1%','84%','96.9%')
axis([0 inf 0 90])
grid on
xlabel('p')
ylabel('t')
set(gca,'FontName','Arial','FontSize',14,'XTick',[0:45:180])

subplot(1,2,2)
plot(imfilter(Sorted(Sorted(:,3)>.5,1),ones(Npt,1)/Npt,'replicate'),AvgHalf)
hold on;plot(imfilter(Sorted(Sorted(:,3)>1,1),ones(Npt,1)/Npt,'replicate'),Avg1)
hold on;plot(imfilter(Sorted(Sorted(:,3)>2,1),ones(Npt,1)/Npt,'replicate'),Avg2)
axis([0 inf 40 53])
grid on
xlabel('p')
ylabel('t')
set(gca,'FontName','Arial','FontSize',14,'XTick',[0:45:180])
% save('Output Fast with 2D colormap.mat','Az','c','A','RGB')
