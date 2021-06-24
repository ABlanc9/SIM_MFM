clear;close all;clc
load('Plat 14 Polygon.mat','xPoly','yPoly','Az','Th','Imax','RGB')

%% Plot borders
figure
plot(xPoly,yPoly,'o')
hold on
plot(xPoly(1:27),yPoly(1:27))
plot(xPoly(28:(end-1)),yPoly(28:(end-1)))
figure
imshow(RGB,[])
hold on
plot([5 29+24]+5,[5 5]*2,'w','LineWidth',2)

%% Create and Masks
figure
[m,n]=size(Imax);
FullMask=poly2mask(xPoly(1:27),yPoly(1:27),m,n);
InnerMask=poly2mask(xPoly(28:(end-1)),yPoly(28:(end-1)),m,n);
EdgeMask=poly2mask(xPoly,yPoly,m,n);
% figure
subplot(2,3,1)
imshow(FullMask)
subplot(2,3,4)
imshow(uint8(FullMask).*RGB)
subplot(2,3,2)
imshow(EdgeMask)
subplot(2,3,5)
imshow(uint8(EdgeMask).*RGB)
subplot(2,3,3)
imshow(InnerMask)
subplot(2,3,6)
imshow(uint8(InnerMask).*RGB)

%% Show scatterplots
AzInner=InnerMask.*Az;
AzOuter=EdgeMask.*Az;
AzFull=FullMask.*Az;
figure
subplot(2,3,4)
scatter(AzFull(FullMask),Imax(FullMask))
subplot(2,3,5)
scatter(AzOuter(EdgeMask),Imax(EdgeMask))
subplot(2,3,6)
scatter(AzInner(InnerMask),Imax(InnerMask))

%% Calculate Radial Angle
props = regionprops(FullMask, 'Centroid');
Cent = vertcat(props.Centroid);
[xPix,yPix]=meshgrid(1:size(Imax,2),1:size(Imax,1));
dX=xPix-Cent(1);
dY=yPix-Cent(2);
Mag=sqrt(dX.^2+dY.^2);
dX=dX./Mag;dY=dY./Mag;
xF=cosd(Az);
yF=-sind(Az);
RadAng=acosd(abs(dX.*xF+dY.*yF));

%% Calculate Average radial angle
wEdge=Imax(EdgeMask);wEdge=wEdge./sum(wEdge);
wInner=Imax(InnerMask);wInner=wInner./sum(wInner);
wFull=Imax(FullMask);wFull=wFull./sum(wFull);
RadAngInner=sum(RadAng(InnerMask).*wInner);
RadAngEdge=sum(RadAng(EdgeMask).*wEdge);
StdInner=sqrt(var(RadAng(InnerMask),wInner));
StdEdge=sqrt(var(RadAng(EdgeMask),wEdge));

%% 
figure
subplot(1,3,3)
errorbar([1 2],[RadAngInner RadAngEdge],[StdInner StdEdge],'.k')
hold on
bar([RadAngInner RadAngEdge])
set(gca,'FontSize',14,'FontName','Arial','XTick',[1 2],'XTickLabel',{'Inner','Edge'})
ylabel('Deviation Angle')
axis([.5 2.5 0 60])

subplot(1,3,[2 3]-1)
histogram(RadAng(InnerMask),'Normalization','probability')
hold on
histogram(RadAng(EdgeMask),'Normalization','probability')
legend('Interior','Edge')
xlabel('Deviation Angle (\degree)')
ylabel('Probability')
set(gca,'FontSize',14,'FontName','Arial')