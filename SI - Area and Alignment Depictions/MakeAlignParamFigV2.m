clear;close all;clc
rng(2)
%% Create image and mask
[xPix,yPix]=meshgrid(1:11);
rPix=sqrt((xPix-6).^2+(yPix-6).^2);
I=exp(-((rPix-1.75)/2).^2)*2;
Mask=I>.5;
figure
subplot(1,2,1)
imshow(I,[])
colorbar
subplot(1,2,2)
imshow(Mask)

%% Create orientation layer for isotropic
Frac=[0 0 .4 1];
Len=[1.75 1.75 .7 .5];
for j=1:4
    figure
    Az=atan((yPix-6)./(xPix-6))+randn(11,11)*.2;
    Az(Az<0)=Az(Az<0)+pi;
    
    for i=1:numel(Az)
        AzDist=Az(i)-deg2rad(35);
        Az(i)=Az(i)-AzDist*Frac(j)+randn(1)*.25/j;
    end
    % subplot(3,4,3)
    % imshow(Az,[])

    cmap=hsv(64);
    AzRef=linspace(0,pi,64)';
        IavgMin=.5;
        ImaxAdj=2;
        Brightness=(I-IavgMin)/(ImaxAdj-IavgMin)*255;
        Brightness(Brightness>255)=255;
        Brightness(Brightness<0)=0;


    RGB=zeros(11,11,3);
        RGB(:,:,1)=reshape(interp1(AzRef,cmap(:,1),...
            Az(:)).*Brightness(:),11,11);
        RGB(:,:,2)=reshape(interp1(AzRef,cmap(:,2),...
            Az(:)).*Brightness(:),11,11);
        RGB(:,:,3)=reshape(interp1(AzRef,cmap(:,3),...
            Az(:)).*Brightness(:),11,11);

    subplot(2,3,1)
    imshow(RGB/255,[])
    Ind=find(Mask);
    Inorm=I(Ind)/sum(I(Ind));
    xComp=cos(Az(Ind)).*Inorm*2;
    yComp=sin(Az(Ind)).*Inorm*2;

    subplot(2,3,3)
    quiver(zeros(size(xComp)),zeros(size(xComp)),xComp,yComp)
    axis square
    axis([-1 1 -1 1]*.028*2)


    xCompDbl=cos(Az(Ind)*2).*Inorm*2;
    yCompDbl=sin(Az(Ind)*2).*Inorm*2;
    
    subplot(2,3,4)
    quiver(zeros(size(xComp)),zeros(size(xComp)),xCompDbl,yCompDbl)
    axis square
    axis([-1 1 -1 1]*.028*2)

    subplot(2,3,2)
    quiver(xPix(Ind),yPix(Ind),cos(Az(Ind))/2,sin(Az(Ind))/2,'k','ShowArrowhead','off')
    hold on
    quiver(xPix(Ind),yPix(Ind),-cos(Az(Ind))/2,-sin(Az(Ind))/2,'k','ShowArrowhead','off')
    axis equal
    axis square

    subplot(2,3,5)
    FullLen=[sum(xCompDbl,'omitnan') sum(yCompDbl,'omitnan')];
    Orientation=atan(FullLen(2)/FullLen(1));
    FullLength(j)=sqrt(sum(FullLen.^2));
    if Orientation<0;Orientation=Orientation+pi;end
    Orientation=Orientation/2;
%     quiver(0,0,FullLen(1)/2,FullLen(2)/2,'k','LineWidth',1)
%     hold on
    quiver(cumsum([0;xCompDbl(1:(end-1))]),cumsum([0;yCompDbl(1:(end-1))]),xCompDbl,yCompDbl,'AutoScaleFactor',Len(j),'ShowArrowHead','off')
    axis equal
    
    
    subplot(2,3,6)
    quiver(xPix(Ind),yPix(Ind),cos(Az(Ind))/2,sin(Az(Ind))/2,'k','ShowArrowhead','off')
    hold on
    quiver(xPix(Ind),yPix(Ind),-cos(Az(Ind))/2,-sin(Az(Ind))/2,'k','ShowArrowhead','off')
    quiver([6 6],[6 6],[1 -1]*cos(Orientation)*FullLength(j)*5,[1 -1]*sin(Orientation)*FullLength(j)*5)
    axis equal
    axis square
end
