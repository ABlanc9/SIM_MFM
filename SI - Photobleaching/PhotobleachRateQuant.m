clear;close all;clc
load('Background Intensity Pre Correction.mat','BkrdI')
addpath('..\raacampbell-notBoxPlot-3ce29db\code')
BkrdI(end,:)=mean(BkrdI,1);
figure
for i=1:size(BkrdI,1)
    FO{i}=fit((1:20)',BkrdI(i,11:30)','a*1000*exp(-x*b)');
    subplot(5,6,i)
    b(i)=FO{i}.b;
    plot((1:20)',BkrdI(i,11:30)','o')
    hold on
    plot(FO{i});
end
figure
subplot(1,3,[1 2])
plot(BkrdI(14,11:30),'o')
hold on
plot(FO{14})
legend('Data','Fit')
subplot(1,3,3)
notBoxPlot(b*100)
axis([0 inf 0 2])