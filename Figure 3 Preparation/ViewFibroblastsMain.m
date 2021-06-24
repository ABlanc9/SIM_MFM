clear;close all;clc

load('MainIm.mat','Im')
i=1;

figure('OuterPosition',[-0.0054    0.0346    1.5488    0.8368]*1000)
for j=1:4
    subplot(3,4,j)
    imshow(Im{i,j},[])
    subplot(3,4,j+4)
    imshow(Im{i,j},[])
    subplot(3,4,j+8)
    imshow(Im{i,j},[])
end

subplot(3,4,1)
h1=drawrectangle;
h2=drawrectangle;

while 1
    for j=1:4
        subplot(3,4,j+4)
        s=rem(j+1,2);
        axis((s+1)*[h1.Position(1) sum(h1.Position([1 3])) h1.Position(2) sum(h1.Position([2 4]))]);
        subplot(3,4,j+8)
        axis((s+1)*[h2.Position(1) sum(h2.Position([1 3])) h2.Position(2) sum(h2.Position([2 4]))]);
    end
    pause
end

%% Save if good
load('ROI Save File.mat')
AX1(i,:)=[h1.Position(1) sum(h1.Position([1 3])) h1.Position(2) sum(h1.Position([2 4]))];
AX2(i,:)=[h2.Position(1) sum(h2.Position([1 3])) h2.Position(2) sum(h2.Position([2 4]))];
AX1=AX1(1,:);AX2=AX2(1,:);
save('ROI Save File MIN2.mat','AX1','AX2')