clear;close all;clc
load('Background Intensity Pre Correction.mat','BkrdI')

for i=1:size(BkrdI,1)
    subplot(4,7,i)
    plot(1:41,BkrdI(i,:))
    params(i,:)=fmincon(@(param) PhotobleachCostFn(param,BkrdI(i,:)),[1500 2500 1.01 ...
        1.005 .5 -5],[],[],[],[],[0 0 1 1 0 -inf],[inf inf 1.1 1.1 1 inf]); 
    
    param=params(i,:);
    Icomp=BkrdI(i,:);
    Iex1=param(1);
    Iex2=param(2);
    gamma1=param(3);
    gamma2=param(4);
    fb=param(5);
    kbleach=10^param(6);
    
    fnb=1-fb;
    Ib=0;
    for j=1:length(Icomp)
        if sum(j==[1 11 31])
            gamma=gamma1;
        elseif sum(j==[2 12 32])
            gamma=gamma2;
        else
            gamma=1;
        end
        Iex=(Iex1+(j>10)*Iex2)/gamma;
        Inb=Iex*fnb;
        Ib(j)=Iex*fb*(1 - kbleach*sum(Ib));
        I(j)=Inb+Ib(j);
    end
    hold on
    plot(I)
end