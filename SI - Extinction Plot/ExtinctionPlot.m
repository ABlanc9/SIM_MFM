clear;close all;clc
Data=[0	-3	2	6
20	-1	14	24
40	25	34	38
60	49	60	71
80	75	72	101
100	57	88	92
120	36	56	55
140	4	26	31
160	-10	-6	2
180	-23	-15	-5];

Ang=Data(:,1);
Avg=mean(Data(:,2:4),2);
figure
plot(Ang,Data(:,2),'or','LineWidth',2);
hold on
plot(Ang,Data(:,3),'dg','LineWidth',2);
plot(Ang,Data(:,4),'sb','LineWidth',2);
plot(Ang,Avg,'kx','LineWidth',2)
FO=fit(Ang,Avg,'A/2*sind((x-c)*2)+A/2','StartPoint',[30 90]);
plot(0:180,FO(0:180),'LineWidth',2)
axis([-inf inf -inf inf])
xlabel('Polarizer Angle (\circ)')
ylabel('Normalized Optical (mW)')
grid on
set(gca,'FontName','Arial','FontSize',14)
h=legend('1','2','3');
title(h,'Rep #')

