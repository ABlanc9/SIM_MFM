clear;close all;clc
load('Platelet Polarization.mat','Amean','cMean','Abkrd','cBkrd')
load('Tcell Polarization.mat','AmeanT','cMeanT','AbkrdT','cBkrdT')
addpath('..\raacampbell-notBoxPlot-3ce29db\code')

figure
notBoxPlot([(Amean./cMean) (Abkrd./cBkrd) (AmeanT./cMeanT) (AbkrdT./cBkrdT)],[ones(1,15) ones(1,15)*2 ones(1,12)*3 ones(1,12)*4])
set(gca,'XTickLabel',{'Cell','Bkrd','Cell','Bkrd'},'FontSize',14)
ylabel('A/c')
grid on
