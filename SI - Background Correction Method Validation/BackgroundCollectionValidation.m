clear;close all;clc
addpath('..\bfmatlab')
% Points to experiment 4 in replication data
File='D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\100% open surface background.nd2';
data=bfopen(File);

for i=1:size(data{1})
    Im(:,:,i)=imfilter(data{i,1}{1},fspecial('disk',15),'replicate');
end
Im=mean(Im,3);


% Points to experiment 4 in replication data
a=dir('D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Chroma Slide\*561*.nd2');
for i=1:length(a)
    data=bfopen(fullfile(a(i).folder,a(i).name));
    Im2(:,:,i)=imfilter(data{1}{1},fspecial('disk',15),'replicate');
end
Im2=mean(Im2,3);

Ratio=Im./Im2;
Ratio=Ratio./mean2(Ratio);
figure
imshow(Ratio,[0 2])
hold on
for i=1:4
    plot([1 1]*512*i,[0 512*3],'r','LineWidth',1)
end
for i=1:2
    plot([0 512*5],[1 1]*512*i,'r','LineWidth',1)
end

figure
imshow(Im,[])
hold on
for i=1:4
    plot([1 1]*512*i,[0 512*3],'r','LineWidth',1)
end
for i=1:2
    plot([0 512*5],[1 1]*512*i,'r','LineWidth',1)
end
colorbar
print(gcf,'-painters','-depsc','100% open.eps')

figure
imshow(Im2,[])
hold on
for i=1:4
    plot([1 1]*512*i,[0 512*3],'r','LineWidth',1)
end
for i=1:2
    plot([0 512*5],[1 1]*512*i,'r','LineWidth',1)
end
colorbar
print(gcf,'-painters','-depsc','chroma.eps')

figure
imshow(log10(Ratio),[-.5 .5]);
hold on
for i=1:4
    plot([1 1]*512*i,[0 512*3],'r','LineWidth',1)
end
for i=1:2
    plot([0 512*5],[1 1]*512*i,'r','LineWidth',1)
end
colorbar
print(gcf,'-painters','-depsc','Ratio.eps')
