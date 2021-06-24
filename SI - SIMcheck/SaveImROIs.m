clear;close all;clc
addpath(genpath('..\bfmatlab'))
% "D:\SIM Data Backup 2019\Jan 2020 SIM Replicate 3" refers to 
% "experiment 3" in the replication data
Folder='D:\SIM Data Backup 2019\Jan 2020 SIM Replicate 3\platelet surface 2';
a=dir([Folder '\*#*.nd2']);
for i=1:length(a)
    Ind1=find(a(i).name=='_');
    Ind2=find(a(i).name=='.');
    WFfile{i}=fullfile(Folder,a(i).name([1:(Ind1-1) Ind2:end]));
end
% SRfile{1}='C:\Files\Research\.SIM MFM\Data\Images for poster\Reconstructed Platelet 10.txt';

ROI{1}{1}=[   69.0499  213.6870   31.3422  175.9793];
ROI{1}{2}=[  298.4409  457.9539  300.2744  459.7874];
ROI{2}{1}=[  229.0000  406.0000  182.0000  359.0000];
ROI{2}{2}=[  211.0000  362.0000   1  145.5000];
ROI{3}{1}=[  153.0000  359.0000  176.5000  382.5000];
ROI{3}{2}=[  351.0000  499.0000   18.5000  166.5000];
ROI{4}{1}=[  183.0000  351.0000  159.0000  327.0000];
ROI{5}{1}=[  162.5000  340.5000  174.0000  352.0000];
ROI{6}{1}=[  339.0000  483.0000  200.5000  344.5000];
ROI{6}{2}=[   14.0000  194.0000  121.0000  301.0000];
ROI{7}{1}=[  210.0000  344.0000  110.0000  244.0000];
ROI{7}{2}=[  192.6211  342.6211  251.2617  401.2617];
ROI{8}{1}=[  176.5000  331.5000  134.0000  289.0000];
ROI{9}{1}=[  127.8203  315.8203  120.9453  308.9453];
ROI{9}{2}=[  221.0000  391.0000  306.5000  476.5000];
ROI{10}{1}=[  125.0000  311.0000   46.5000  232.5000];
ROI{10}{2}=[  229.0000  392.0000  230.5000  393.5000];
ROI{11}{1}=[  208.0312  391.5203   39.5443  223.0334];
ROI{11}{2}=[  127.6345  287.6585  321.8944  481.9185];
ROI{12}{1}=[  153.5000  279.5000  229.0000  355.0000];
for i=1:length(ROI)
    WFfile{i}=repmat(WFfile(i),length(ROI{i}),1);
end
WFfile=vertcat(WFfile{:});

ROI=horzcat(ROI{:})';

for i=3:length(WFfile)
    Im=uint16([]);
    data=bfopen(WFfile{i});
    for ii=1:3
        Row=(1:512)+(ii-1)*512;
        for k=1:5
            Col=(1:512)+(k-1)*512;
            Im(:,:,end+1)=data{1}{1}(Row,Col);
        end
    end
    ROI{i}=round(ROI{i});
    Row=ROI{i}(3):ROI{i}(4);
    Col=ROI{i}(1):ROI{i}(2);
    Im=Im(Row,Col,2:end);
    for j=1:size(Im,3)
          if j == 1 
              imwrite(Im(:,:,1),['Plat ' num2str(i) '.tif']); 
          else 
              imwrite(Im(:,:,j),['Plat ' num2str(i) '.tif'],'WriteMode','append'); 
          end 
    end
end