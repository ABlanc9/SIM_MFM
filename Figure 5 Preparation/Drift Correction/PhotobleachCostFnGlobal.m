function cost=PhotobleachCostFnGlobal(param,Icomp)
    
    Ratio=param(1);
    gamma1=param(2);
    gamma2=param(3);
    fb=param(4);
    kbleach=10^param(5);
    
    Iex1=param(6:end);
    Iex2=Iex1*Ratio;
    
    fnb=1-fb;
    for j=1:size(Icomp,1)
        Ib=0;
        for i=1:size(Icomp,2)
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
    
    cost=sum((I-Icomp).^2,'all');
end