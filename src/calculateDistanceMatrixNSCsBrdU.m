function [  ] = calculateDistanceMatrixNSCsBrdU(  )
    %Developed by Pedro Gomez-Galvez and Pablo Vicente-Munuera
    %load all paths (former raw images distanceMatrices and new images alpha & omega)
    centroidPathFiles = 'results\distanceMatrix\rawImages\';
    oldPointsFiles = getAllFiles(centroidPathFiles);
    oldImagesPath = 'data\sortedByAnimal\total NSCs\3m';
    oldImagesFiles = getAllFiles(oldImagesPath);
    newPointsFiles = getAllFiles('data\sortedByAnimal\NSCs BrdU\3m NSCs BrdU');
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
        figure('visible', 'off');
        imshow(BWdilate)

        %load invalid area from Img
        if strcmp(imgName(1),'1')
            invAreaImg=imread(['data\WithInvalidArea\' imgName(1:2) 'm\' imgName  '.bmp']);
            month=[imgName(1:2) 'm'];
        else
            invAreaImg=imread(['data\WithInvalidArea\3m\' imgName '.bmp']);
            month='3m';
        end
        invalidArea = invAreaImg(:, :, 1) == 0 & invAreaImg(:, :, 3);

        close all

        %centroids
        centroidsNSCsBrdU=regionprops(BWdilate,'Centroid');
        centroidsNSCsBrdU=cat(1,centroidsNSCsBrdU.Centroid);
        
        thisSplittedPath=splittedPath{nFile};
        outputFile = ['resultsByAnimal\NSCs BrdU\distanceMatrix\'  month '\' thisSplittedPath{end-1} '\' imgName '.mat'];
        
        if isempty(centroidsNSCsBrdU) == 0 && exist(outputFile, 'file') ~= 2
            imgNameAndExt = strcat(imgName, '.bmp');
            oldImgFile = oldImagesFiles{cellfun(@(x) isempty(strfind(x, imgNameAndExt)) == 0, oldImagesFiles)};
            
            imgNameAndExt = strcat(imgName, '.mat');
            oldPointsFile = oldPointsFiles{cellfun(@(x) isempty(strfind(x, imgNameAndExt)) == 0, oldPointsFiles)};
            oldPointsInfo = importdata(oldPointsFile);

            for numNewCentroid = 1:size(centroidsNSCsBrdU, 1)
                oldImg = imread(oldImgFile);
                oldImg(:, :, 1) = 0;
                rawImg(:, :, 2) = 0;
                imgToShow = rawImg + oldImg;
                h = figure; imshow(imgToShow)
                hold on;
                plot(centroidsNSCsBrdU(numNewCentroid, 1), centroidsNSCsBrdU(numNewCentroid, 2), 'o');
                [x, y] = getpts(h);
                
                centroidsNSCsBrdU(numNewCentroid, :) = [x y];
                close all
            end
            
            distanceToOldCentroids = pdist2(centroidsNSCsBrdU, oldPointsInfo.Centroids);
            [~, indices] = min(distanceToOldCentroids, [], 2);

            centroidsNSCsBrdU = oldPointsInfo.Centroids(indices, :);
            
%             figure; imshow(oldImgFile)
%             hold on;
%             for numNewCentroid = 1:size(centroidsNSCsBrdU, 1)
%                 plot(centroidsNSCsBrdU(numNewCentroid, 1), centroidsNSCsBrdU(numNewCentroid, 2), 'o');
%             end
            
            %Calculate distance Matrix from centroids and invalid area
            distanceMatrixNSCsBrdU = classifyByRegionAndCalculateDistanceMatrix(centroidsNSCsBrdU,invalidArea,H,W);
            
            [maxDist, indicesRow] = max(oldPointsInfo.distanceMatrix, [], 2);
            
            [~, indicesCol] = max(maxDist);
            
%             %Check if the extreme points are the good ones
%             figure; plot(oldPointsInfo.Centroids(:, 1), oldPointsInfo.Centroids(:, 2), '*')
%             hold on;plot(oldPointsInfo.Centroids(indicesCol, 1), oldPointsInfo.Centroids(indicesCol, 2), 'o')
%             hold on;plot(oldPointsInfo.Centroids(indicesRow(indicesCol), 1), oldPointsInfo.Centroids(indicesRow(indicesCol), 2), 'o')
            cornerCentroidsIndices = [indicesCol indicesRow(indicesCol)];
            centroidsBrdUWithCorners = unique(vertcat(centroidsNSCsBrdU, oldPointsInfo.Centroids([indicesCol indicesRow(indicesCol)], :)), 'rows');
            
            distanceMatrixWithCornersNSCsBrdU = classifyByRegionAndCalculateDistanceMatrix(centroidsBrdUWithCorners, invalidArea, H, W);
            
            if ~isdir(['resultsByAnimal\NSCs BrdU\distanceMatrix\' month '\' thisSplittedPath{end-1} '\'])
                mkdir(['resultsByAnimal\NSCs BrdU\distanceMatrix\' month '\' thisSplittedPath{end-1} '\']);
            end
            save(outputFile, 'distanceMatrixNSCsBrdU', 'distanceMatrixWithCornersNSCsBrdU','centroidsNSCsBrdU', 'centroidsBrdUWithCorners', 'cornerCentroidsIndices')
        end
    end

end

