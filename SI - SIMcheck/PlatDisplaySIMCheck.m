clear;close all;clc
addpath('..\bfmatlab')
MCNall=[];
for i=1:18
    if i==18
        i=19;
    end
    MCN{i}=imread(['Plat ' num2str(i) ' MCN.tif']);
    FFT(:,:,i)=imread(['Plat ' num2str(i) ' FFT.tif']);
    Im1{i}=imread(['Plat ' num2str(i) '.tif'],1);
    if i==11
        figure
    end
    
    h1(i)=subplot(3,9,rem(i-1,9)+1);
    imshow(Im1{i},quantile(Im1{i}(:),[.05 .95]))
    colormap(h1(i),'gray')
    hold on
    plot([10 57.76],[10 10],'w','LineWidth',1)
%     caxis([2 12])
    
    h2(i)=subplot(3,9,rem(i-1,9)+10);
    imshow(MCN{i},[])
    colormap(h2(i),'hot')
    hold on
    plot([10 41.76],[10 10],'w','LineWidth',1)
    caxis([2 16])
    
    h3(i)=subplot(3,9,rem(i-1,9)+19);
    imshow(FFT(:,:,i),[])
    colormap(h3(i),'gray')
    axis([128+84*[-1 1 -1 1]])
%     caxis([2 12])

    MCNall=[MCNall;MCN{i}(:)];
    QMCNRplat(i)=quantile(MCN{i}(:),.99);
    
end

figure
subplot(1,3,1)
imshow(mean(FFT,3),[])
axis([128+84*[-1 1 -1 1]])

[F,X]=ecdf(MCNall(:));
subplot(1,3,2)
semilogy(X,1-F)
grid on