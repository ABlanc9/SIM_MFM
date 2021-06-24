clear;close all;clc

load('MaxIms.mat','MaxIm')

ROI{1}{1}=[1 95 97 245];
ROI{1}{2}=[51 210 186 344];

ROI{2}{1}=[21 191 113 283];
ROI{2}{2}=[8 130 277 399];
ROI{2}{3}=[216 356 270 429];
ROI{2}{4}=[304 420 237 353];

ROI{3}{1}=[156 295 233 372];
ROI{3}{2}=[171 305 1 123];
ROI{3}{3}=[338 467 185 314];
ROI{3}{4}=[416 546 127 257];

ROI{4}{1}=[1 108 374 512];
ROI{4}{2}=[265 373 195 349];
ROI{4}{3}=[359 498 159 298];

ROI{5}{1}=[57 199 152 293];
ROI{5}{2}=[178 336 152 310];
ROI{5}{3}=[122 295 1 154];
ROI{5}{4}=[394 512 168 290];


for j=1:length(MaxIm)
    for i=1:3
        Row=(1:512)+(i-1)*512;
        for k=1:5
            Col=(1:512)+(k-1)*512;
            Im{i}(:,:,k)=MaxIm{j}(Row,Col);
        end
        Im{i}=mean(Im{i},3);
    end
    ImAvg{j}=Im{1}+Im{2}+Im{3};
    imshow(ImAvg{j},[])
    count=1;
    keyboard
end