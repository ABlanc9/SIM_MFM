clear;close all;clc

load('Timelapse Fit Results.mat','parA','parCV','t')
IndGood=(parA(:,6)>0) & ((parA(:,6)+parA(:,4))<max(t)) & (parCV(:,1)>0) & (parCV(:,2)<19);
IndHigh=find((parA(:,6)>0) & ((parA(:,6)+parA(:,4))<max(t)) & (parCV(:,1)>0) & (parCV(:,2)<1));
IndLow=find((parA(:,6)>0) & ((parA(:,6)+parA(:,4))<max(t)) & (parCV(:,1)>0) & (parCV(:,2)>19));
RmaxGood=sum(parCV(IndGood,[1 3]),2);
Rmaxbad=[sum(parCV(IndLow,[1 3]),2);sum(parCV(IndHigh,3),2)];

figure;plot([parA(IndGood & parA(:,2)>parCV(:,2),2)';parCV(IndGood & parA(:,2)>parCV(:,2),2)'],'-or','LineWidth',1)
hold on;plot([parA(IndGood & parA(:,2)<parCV(:,2),2)';parCV(IndGood & parA(:,2)<parCV(:,2),2)'],'-ob','LineWidth',1)
axis([.7 2.3 0 inf])
ranksum(parA(IndGood,2)',parCV(IndGood,2)')
set(gca,'FontSize',14,'FontName','Arial')
grid on
ylabel('Time Constant (min)')

%% Ensemble calc area
parA=parA(IndGood,[1 2 4 5]);
Lower=quantile(parA,.25);
Upper=quantile(parA,.75);
Mid=quantile(parA,.5);
par=[Lower;Mid;Upper];
t=(0:.1:50)';
for i=1:(3^4)
    Str=dec2base(i,3,4);
    for j=1:4
        p(j)=par(str2num(Str(j))+1,j);
    end
    Curve(i,:)=p(1)*(1-exp(-t/p(2))-1./(1+exp(-(t-p(3))/p(4))));
end
MedCurve=Mid(1)*(1-exp(-t/Mid(2))-1./(1+exp(-(t-Mid(3))/Mid(4))));
MinCurve=smooth(min(Curve),15);
MaxCurve=smooth(max(Curve),15);
figure('OuterPosition',1000*[0.0622    0.1790    1.3324    0.6584])
subplot(2,1,1)
patch([t;flipud(t)],[MinCurve;flipud(MaxCurve)],[.8 .8 1])
hold on
plot(t,MedCurve)
xlabel('Alignment parameter')
ylabel('Area of tension (mm)')
axis([0 36 0 22])
grid on
axis square
plot([Mid(2) Mid(2)],[0 5])
plot([Mid(3) Mid(3)],[0 5])

%% Ensemble calc Circular Variance
parCV=parCV(IndGood,[1 2]);
Lower=quantile(parCV,.25);
Upper=quantile(parCV,.75);
Mid=quantile(parCV,.5);
par=[Lower;Mid;Upper];
t=(0:.1:50)';
p=[];Curve=[];
for i=1:(3^2)
    Str=dec2base(i,3,2);
    for j=1:2
        p(j)=par(str2num(Str(j))+1,j);
    end
    Curve(i,:)=p(1)*exp(-t/p(2));
end
MedCurve=Mid(1)*exp(-t/Mid(2));
MinCurve=smooth(min(Curve),15);
MaxCurve=smooth(max(Curve),15);
subplot(2,1,2)
patch([t;flipud(t)],1-[MinCurve;flipud(MaxCurve)],[.8 .8 1])
hold on
plot(t,1-MedCurve)
xlabel('Time After Adhesion (min)')
ylabel('Area of tension (mm)')
axis([0 36 .65 1])
plot([Mid(2) Mid(2)],[.65 .75])
grid on
axis square