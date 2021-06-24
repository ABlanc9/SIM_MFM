clear;close all;clc
load('Multi-cell output.mat','Sig2','Sig','peakI','peakI2','Keep',...
    'bkrdI','bkrdI2','Loc','Loc2')
addpath('..\raacampbell-notBoxPlot-3ce29db\code')
figure('OuterPosition',[-0.0018    0.5634    1.5424    0.2748]*1000)
subplot(1,5,1:4)
for i=1:length(Keep)
    Sig{i}=Sig{i}(Keep{i})*63*2.335;
    Sig2{i}=Sig2{i}(Keep{i})*63*2.335;
    Grp{i}=ones(size(Sig{i}))*i;
    violin([Sig{i}' Sig2{i}'],'x',i*3-[1.15 1.85],'facecolor',[0 0 1;0 1 0])
    hold on
%     violin(Sig2{i}','x',i*2-1)
end
set(gca,'XTick',0:3:60,'XTickLabel',repmat({''},1,21),'FontSize',12,'FontName','Arial')
axis([0 60 120 400])
grid on
ylabel('FWHM (nm)')

subplot(1,5,5)
notBoxPlot([cellfun(@median,Sig)' cellfun(@median,Sig2)'],[.7 1.3])
ylabel('Median FWHM (nm)')
set(gca,'XTickLabel',{'WF','SIM'},'FontSize',12,'FontName','Arial')
