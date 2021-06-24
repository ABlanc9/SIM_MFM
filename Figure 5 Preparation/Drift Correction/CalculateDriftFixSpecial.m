clear;close all;clc

clear;close all;clc

%% Initialize
addpath(genpath('D:\.SIM MFM\Code\AA General Tools'));
 File{1}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 1.nd2'];
 File{2}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 2.nd2'];
 File{3}=['D:\SIM Data Backup 2019\Mar 2020 SIM Replicate 4\Platelets\ND Acquisition 3.nd2'];
load('..\..\..\Data\2020-01-30 SIM MFM replicate 3\Chroma Slide\CalibFile3D.mat','CalibIm561')
for j=1:3
    reader{j}=bfGetReader(File{j});
end
Imcount=[10 20 11];

%% Pull ROIs
load('BkrdROIs.mat','BkrdROI')
[optimizer, metric] = imregconfig('multimodal');
iii=[5 16];
for i=1:2
    i=iii(i);
    
    BkrdROI{i}=BkrdROI{i}{1};
    Timelapse{i}=[];
    TargetRow=1:512;%BkrdROI{i}(3):BkrdROI{i}(4);
    TargetCol=1:512;%BkrdROI{i}(1):BkrdROI{i}(2);
    for j=1:3
        reader{j}.setSeries(i-1);
        for k=1:Imcount(j)
            data=bfGetPlane(reader{j},k);
            ImTemp=SplitAndCorrSIM(data,CalibIm561,200);
            Timelapse{i}{end+1}=ImTemp{1}(TargetRow,TargetCol)+...
                ImTemp{2}(TargetRow,TargetCol)+ImTemp{3}(TargetRow,TargetCol);
            [i j k]
        end
    end
    
    figure(1)
    v=VideoWriter(['Drift Correction Vid Location ' num2str(i) '.avi'],'Motion JPEG AVI');
    v.Quality = 95;
    open(v);
    for j=2:length(Timelapse{i})
        subplot(1,2,1)
        AxLim=quantile(Timelapse{i}{j}(:),[.001 .999]);
        imshow(Timelapse{i}{j},[AxLim])
        title('Pre-Correction')
        if j~=11
            [tform{i}{j-1}] = imregtform(Timelapse{i}{j},Timelapse{i}{j-1},...
                'translation',optimizer,metric);
        else
            tform{i}{j-1}=tform{i}{j-2};
        end
        Timelapse{i}{j} = imwarp(Timelapse{i}{j},tform{i}{j-1},'OutputView',imref2d(size(Timelapse{i}{j})));
        subplot(1,2,2)
        imshow(Timelapse{i}{j},[AxLim])
        title('Corrected')
        frame = getframe(gcf);
        writeVideo(v,frame);
        drawnow
        pause(.1)
    end
    close(v)
end

TformCorr=tform;
load('Registration Tforms.mat','tform')
tform(5)=TformCorr(5);
tform(16)=TformCorr(16);
save('Registration Tforms Fixed.mat','tform')


