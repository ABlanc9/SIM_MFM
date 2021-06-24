clear;close all;clc

load('Timelapse Fit Results Fixed.mat','parA','parCV','t')
IndGood=(parA(:,6)>0) & ((parA(:,6)+parA(:,4))<max(t));
Aall=parA(:,1);
addpath(genpath(cd))
figure
subplot(2,3,1)
scatter(parA(:,6),parA(:,4)+parA(:,6),'.b')
hold on
plot([0 82 82 0 0],[0 0 82 82 0],'k')
axis square
axis([-3 90 0 110])
xlabel('tattach')
ylabel('tattach+tdetatch')
set(gca,'FontName','Arial','FontSize',14)
grid on

subplot(2,3,2)
parA=parA(IndGood,:);
parCV=parCV(IndGood,:);
parCV(parCV(:,1)>1,1)=1;
parCV(parCV(:,1)<-1,1)=-1;
scatter(parCV(:,1),parCV(:,2),'.b')
hold on
plot([0 1 1 0 0],[0 0 19 19 0],'k')
axis square
xlabel('Rmax-R0')
ylabel('talign')
set(gca,'FontName','Arial','FontSize',14)
grid on

IndGood=(parCV(:,1)>0) & (parCV(:,2)<19);
parCVbad=parCV(~IndGood,:);
parAbad=parA(~IndGood,:);
parCV=parCV(IndGood,:);
parA=parA(IndGood,:);
parAbad([4 13 15],:)=[];
parCVbad([4 13 15],:)=[];

subplot(2,3,[4 5])
notBoxPlot([parCV(:,2);1;parA(:,2);parAbad(:,2);1;parA(:,5);parAbad(:,5)],[ones(28,1)*1;2;ones(28,1)*3;ones(22,1)*4;5;ones(28,1)*6;ones(22,1)*7],'markMedian',true,'jitter',.8)
% axis square
set(gca,'XTick',[1 3.5 6.5])
axis([0 8 0 30])
% xlabel('Rmax-R0')
ylabel('Time constant')
set(gca,'FontName','Arial','FontSize',14)
grid on

subplot(2,3,3)
notBoxPlot([parA(:,1);parAbad(:,1)],[ones(28,1);ones(22,1)*2],'markMedian',true,'jitter',.8)
axis square
axis([0 3 0 45])
% xlabel('Rmax-R0')
ylabel('Time constant')
set(gca,'FontName','Arial','FontSize',14)
grid on

subplot(2,3,6)
notBoxPlot([parA(:,4);parAbad(:,4)],[ones(28,1);ones(22,1)*2],'markMedian',true,'jitter',.8)
axis square
grid on
axis([0 3 0 45])
% xlabel('Rmax-R0')
ylabel('Time constant')
set(gca,'FontName','Arial','FontSize',14)