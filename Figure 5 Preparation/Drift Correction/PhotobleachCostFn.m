function cost=PhotobleachCostFn(param,Icomp)
    
    Iex1=param(1);
    Iex2=param(2);
    gamma1=param(3);
    gamma2=param(4);
    fb=param(5);
    kbleach=10^param(6);
    
    fnb=1-fb;
    Ib=0;
    for i=1:length(Icomp)
        if sum(i==[1 11 31])
            gamma=gamma1;
        elseif sum(i==[2 12 32])
            gamma=gamma2;
        else
            gamma=1;
        end
        Iex=(Iex1+(i>10)*Iex2)/gamma;
        Inb=Iex*fnb;
        Ib(i)=Iex*fb*(1 - kbleach*sum(Ib));
        I(i)=Inb+Ib(i);
    end
    
    cost=sum((I-Icomp).^2);
end