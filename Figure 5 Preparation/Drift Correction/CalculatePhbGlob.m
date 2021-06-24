clear;close all;clc
load('Background Intensity Pre Correction.mat','BkrdI')

    param=fmincon(@(param) PhotobleachCostFnGlobal(param,BkrdI),[2.5 1.05 ...
        1.025 .5 -4.5 BkrdI(:,1)'],[],[],[],[],[0 1 1 0 -6 zeros(1,26)],...
        [inf 1.2 1.1 1 inf inf(1,26)]); 
    

    Ratio=param(1);
    gamma1=param(2);
    gamma2=param(3);
    fb=param(4);
    kbleach=10^param(5);
    
    Iex1=param(6:end);
    Iex2=Iex1*Ratio;
    
    fnb=1-fb;
%     Ib=0;
    for j=1:size(BkrdI,1)
        Ib=0
        for i=1:size(BkrdI,2)
            if sum(i==[1 31])
                gamma=gamma1;
            elseif sum(i==[2 32])
                gamma=gamma2;
            else
                gamma=1;
            end
            Iex=(Iex1(j)+(i>10)*Iex2(j))/gamma;
            Inb=Iex*fnb;
            Ib(i)=Iex*fb*(1 - kbleach*sum(Ib));
            I(j,i)=Inb+Ib(i);
        end
    end
    
for i=1:26
    subplot(4,7,i)
    plot(1:41,BkrdI(i,:),1:41,I(i,:));
end