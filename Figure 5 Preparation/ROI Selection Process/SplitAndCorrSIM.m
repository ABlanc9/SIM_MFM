function [Im]=SplitAndCorrSIM(data,CalibIm,Bkrd)

    if ~exist('Bkrd')
        Bkrd=200;
    end
    
    %% CCD and illumination profile background correction
    data=(double(data)-Bkrd)./double(CalibIm);
    
    %% Pull images out 
    for i=1:3
        Row=(1:512)+(i-1)*512;
        for k=1:5
            Col=(1:512)+(k-1)*512;
            Im{i}(:,:,k)=data(Row,Col);
        end
        Im{i}=mean(Im{i},3);
    end
end