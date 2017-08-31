function [  ] = calculateDistanceMatrixNSCsBrdU(  )
    %Developed by Pedro Gomez-Galvez and Pablo Vicente-Munuera

    addpath('lib\')

    %load all paths (former raw images distanceMatrices and new images alpha & omega)
    centroidPathFiles = '..\results\distanceMatrix\rawImages\';
    oldPointsFiles = getAllFiles(centroidPathFiles);
    newPointsFiles = getAllFiles('..\data\sortedByAnimal\NSCs BrdU\');
    splittedPath = cellfun(@(x) strsplit(x, '\'), newPointsFiles, 'UniformOutput', false);
    for nFile = 1:length(newPointsFiles)
        %load raw image NSCs BrdU
        fullPathFile = newPointsFiles{nFile};
        fileNameSplitted = strsplit(fullPathFile, '\');
        imgName = fileNameSplitted{end};
        imgName = imgName(1:end-4);
        rawImg = imread(fullPathFile);
        [H,W,~]=size(rawImg);
        imshow(rawImg)
        %find stem cells NSCs BrdU
        Img = rawImg(:, :, 2);
        BW=im2bw(Img,0.5);
        BWerode=imerode(BW,[1,1,1;1,1,1;1,1,1]);
        BWerode=bwareaopen(BWerode,4);
        BWdilate=imdilate(BWerode,[1,1,1;1,1,1;1,1,1]);
        figure;imshow(BWdilate)

        %load invalid area from Img
        if strcmp(imgName(1),'1')
            invAreaImg=imread(['..\data\WithInvalidArea\' imgName(1:2) 'm\' imgName  '.bmp']);
            month=[imgName(1:2) 'm'];
        else
            invAreaImg=imread(['..\data\WithInvalidArea\3m\' imgName '.bmp']);
            month='3m';
        end
        invalidArea = invAreaImg(:, :, 1) == 0 & invAreaImg(:, :, 3);

        close all

        %centroids
        centroidsNSCsBrdU=regionprops(BWdilate,'Centroid');
        centroidsNSCsBrdU=cat(1,centroidsNSCsBrdU.Centroid);
        
        imgNameAndExt = strcat(imgName, '.mat');
        
        oldPointsFile = oldPointsFiles{cellfun(@(x) isempty(strfind(x, imgNameAndExt)) == 0, oldPointsFiles)};
        oldPointsInfo = importdata(oldPointsFile);
        
        distanceToOldCentroids = pdist2(centroidsNSCsBrdU, oldPointsInfo.Centroids);
        
        %Calculate distance Matrix from centroids and invalid area
        distanceMatrixNSCsBrdU = classifyByRegionAndCalculateDistanceMatrix(centroidsNSCsBrdU,invalidArea,H,W);

        thisSplittedPath=splittedPath{nFile};


        if ~isdir(['..\resultsByAnimal\NSCs BrdU\distanceMatrix\' month '\' thisSplittedPath{6} '\'])
            mkdir(['..\resultsByAnimal\NSCs BrdU\distanceMatrix\' month '\' thisSplittedPath{6} '\']);
        end
        save(['..\resultsByAnimal\NSCs BrdU\distanceMatrix\'  month '\' thisSplittedPath{6} '\' imgName '.mat'],'distanceMatrixNSCsBrdU','CentroidsNSCsBrdU')
    end

end

