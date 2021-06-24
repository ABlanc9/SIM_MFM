clear;close all;clc

addpath(genpath('..\raacampbell-notBoxPlot-3ce29db'))

T1=table2array(readtable('SIMcheck Summary Statistics.xlsx','Sheet',2));
T2=table2array(readtable('SIMcheck Summary Statistics.xlsx','Sheet',3));

subplot(1,3,1)
notBoxPlot(T1(:,1),ones(size(T1,1),1))
hold on
notBoxPlot(T2(:,1),ones(size(T2,1),1)*2)
notBoxPlot(T2(:,3),ones(size(T2,1),1)*3)
hold on
plot([0 4],[50 50],'k--')
axis([0 4 0 60])
axis square
grid on

subplot(1,3,2)
notBoxPlot(T1(:,2),ones(size(T1,1),1))
hold on
notBoxPlot(T2(:,2),ones(size(T2,1),1)*2)
notBoxPlot(T2(:,4),ones(size(T2,1),1)*3)
hold on
plot([0 4],[4 4],'k--')
axis([0 4 3 6])
axis square
grid on

load('MCNR Top 1% Fibs.mat','QMCNRfib561','QMCNRfib488')
load('MCNR Top 1% Plat.mat','QMCNRplat')

subplot(1,3,3)
notBoxPlot(QMCNRplat,ones(size(QMCNRplat,1),1))
hold on
notBoxPlot(QMCNRfib488,ones(size(QMCNRfib488,1),1)*2)
notBoxPlot(QMCNRfib561,ones(size(QMCNRfib488,1),1)*3)
hold on
plot([0 4],[4 4],'k--')
plot([0 4],[4 4]+4,'k--')
axis([0 4 3 10])
axis square
grid on