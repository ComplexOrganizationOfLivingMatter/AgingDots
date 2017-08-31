function [  ] = calculateDistanceMatrixNSCsBrdU(  )
    %Developed by Pedro Gomez-Galvez and Pablo Vicente-Munuera
    %load all paths (former raw images distanceMatrices and new images alpha & omega)
    centroidPathFiles = 'results\distanceMatrix\rawImages\';
    oldPointsFiles = getAllFiles(centroidPathFiles);
    newPointsFiles = getAllFiles('data\sortedByAnimal\NSCs BrdU\');
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
        
        if isempty(centroidsNSCsBrdU) == 0
            imgNameAndExt = strcat(imgName, '.mat');

            oldPointsFile = oldPointsFiles{cellfun(@(x) isempty(strfind(x, imgNameAndExt)) == 0, oldPointsFiles)};
            oldPointsInfo = importdata(oldPointsFile);

            distanceToOldCentroids = pdist2(centroidsNSCsBrdU, oldPointsInfo.Centroids);

            [~, indices] = min(distanceToOldCentroids, [], 2);

            centroidsNSCsBrdU = oldPointsInfo.Centroids(indices, :);
            %Calculate distance Matrix from centroids and invalid area
            distanceMatrixNSCsBrdU = classifyByRegionAndCalculateDistanceMatrix(centroidsNSCsBrdU,invalidArea,H,W);
            
            [maxDist, indicesRow] = max(oldPointsInfo.distanceMatrix);
            
            [~, indicesCol] = max(maxDist);
            
%             %Check if the extreme points are the good ones
%             plot(oldPointsInfo.Centroids(:, 1), oldPointsInfo.Centroids(:, 2), '*')
%             hold on;plot(oldPointsInfo.Centroids(indicesCol, 1), oldPointsInfo.Centroids(indicesCol, 2), 'o')
%             hold on;plot(oldPointsInfo.Centroids(indicesRow(indicesCol), 1), oldPointsInfo.Centroids(indicesRow(indicesCol), 2), 'o')
            cornerCentroidsIndices = [indicesCol indicesRow(indicesCol)];
            centroidsBrdUWithCorners = vertcat(centroidsNSCsBrdU, oldPointsInfo.Centroids([indicesCol indicesRow(indicesCol)], :));
            distanceMatrixWithCornersNSCsBrdU = classifyByRegionAndCalculateDistanceMatrix(centroidsBrdUWithCorners, invalidArea, H, W);
            thisSplittedPath=splittedPath{nFile};


            if ~isdir(['resultsByAnimal\NSCs BrdU\distanceMatrix\' month '\' thisSplittedPath{end-1} '\'])
                mkdir(['resultsByAnimal\NSCs BrdU\distanceMatrix\' month '\' thisSplittedPath{end-1} '\']);
            end
            save(['resultsByAnimal\NSCs BrdU\distanceMatrix\'  month '\' thisSplittedPath{end-1} '\' imgName '.mat'], 'distanceMatrixNSCsBrdU', 'distanceMatrixWithCornersNSCsBrdU','centroidsNSCsBrdU', 'centroidsBrdUWithCorners', 'cornerCentroidsIndices')
        end
    end

end

