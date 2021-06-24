clear;close all;clc

QPtFile{1}='QueryPoints.mat';
Folder='D:\SIM Data Backup 2019\Jan 2020 SIM Replicate 3\platelet surface 2';
a=dir([Folder '\*#*.nd2']);
for i=1:length(a)
    SRfile{i}=fullfile(Folder,a(i).name);
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

for ii=11:length(SRfile)
    data=bfopen(WFfile{ii});
    for i=1:3
        Row=(1:512)+(i-1)*512;
        for k=1:5
            Col=(1:512)+(k-1)*512;
            ImRaw{i}(:,:,k)=double(data{1}{1}(Row,Col));
            ImRaw{i}(:,:,k)=(ImRaw{i}(:,:,k)-200)*4.9/100;
        end
        Im{i}=sum(ImRaw{i},3);
    end
    Thresh=1.6;

    cmap=hsv(64);
    AzRef=linspace(0,180,64)';

    Iavg=(Im{1}+Im{2}+Im{3})/3;
    I1=Im{1}-Iavg;
    I3=Im{3}-Iavg;
    Az=rad2deg(atan2(I1-I3*cosd(120),I3*sind(120)))/2+90;
    Az(Az<0)=Az(Az<0)+360;
    A=I3./cosd(2*(Az-90));
    c=Im{3}-A.*cosd(Az-90).^2-1;
    Imax=A*2+c;
%     figure
    imshow(Imax,[])
    
    for iii=1:length(ROI{ii})
        if (iii==1)  & (ii==11);continue;end
        axis(ROI{ii}{iii})
        [xpt{ii}{iii},ypt{ii}{iii}]=getpts;
        save([cd '\PtsFld\Pts' num2str(ii) '-' num2str(iii)],'xpt','ypt')
    end
end
