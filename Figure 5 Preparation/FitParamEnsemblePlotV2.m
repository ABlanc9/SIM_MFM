clear;close all;clc

load('Timelapse Fit Results Fixed.mat','parA','parCV','t')
IndGood=find((parA(:,6)>0) & ((parA(:,6)+parA(:,4))<max(t)) & (parCV(:,2)<19) & (parCV(:,1)>0));

%% Ensemble calc area
parA=parA(IndGood,[1 2 4 5]);
Mid=quantile(parA,.5);
t=(0:.1:50)';

Bnd=bootci(10000,@(param) AreaBtsrp(param,t),parA);

MedCurve=Mid(1)*(1-exp(-t/Mid(2))-1./(1+exp(-(t-Mid(3))/Mid(4))));
MinCurve=smooth(Bnd(1,:)',15);
MaxCurve=smooth(Bnd(2,:)',15);
figure('OuterPosition',1000*[0.0622    0.1790    1.3324    0.6584])
subplot(2,1,1)
patch([t;flipud(t)],[MinCurve;flipud(MaxCurve)],[.8 .8 1])
hold on
plot(t,MedCurve)
xlabel('Alignment parameter')
ylabel('Area of tension (mm)')
axis([0 26 0 22])
grid on
axis square
plot([Mid(2) Mid(2)],[0 5])
plot([Mid(3) Mid(3)],[0 5])
set(gca,'XTick',0:5:35)

%% Ensemble calc Circular Variance
parCV=parCV(IndGood,[1 2]);
Mid=quantile(parCV,.5);
t=(0:.1:50)';

Bnd=bootci(10000,@(param) CVBtsrp(param,t),parCV);

MedCurve=Mid(1)*(1-exp(-t/Mid(2)));
MinCurve=smooth(Bnd(1,:)',15);
MaxCurve=smooth(Bnd(2,:)',15);
subplot(2,1,2)
patch([t;flipud(t)],[MinCurve;flipud(MaxCurve)],[.8 .8 1])
hold on
plot(t,MedCurve)
xlabel('Time After Adhesion (min)')
ylabel('Area of tension (mm)')
axis([0 26 0 .5])
set(gca,'XTick',0:5:35)
plot([Mid(2) Mid(2)],[0 1])
grid on
axis square