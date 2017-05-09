function [ ] = createDistanceMatrix( )
%CREATEDISTANCEMATRIX Summary of this function goes here
%   Detailed explanation goes here
    addpath('lib')
    dataFiles = getAllFiles('..\data\WithInvalidArea\');
    mkdir('..\results\distanceMatrix');
    for numFile = 1:size(dataFiles,1)
        fullPathFile = dataFiles(numFile);
        fullPathFile = fullPathFile{:};
        diagramNameSplitted = strsplit(fullPathFile, '\');
        imgName = diagramNameSplitted(end);
        imgName = imgName{1};
        rawImg = imread(fullPathFile);
        [H,W,~]=size(rawImg);

        img = rawImg(:, :, 1) - rawImg(:, :, 3);
        invalidArea = rawImg(:, :, 1) == 0 & rawImg(:, :, 3);
        img2 = im2bw(img(:,:,1), 0.8);
        se = strel('disk', 1);
        imgEroded = imerode(img2, se);


        imgRegions = regionprops(imgEroded);

        % imgAreas = vertcat(imgRegions.Area);
        Centroids = round(vertcat(imgRegions.Centroid));

        [ distanceMatrix ] = classifyByRegionAndCalculateDistanceMatrix(Centroids,invalidArea,H,W);
        
        
        
        save(strcat('..\results\distanceMatrix\', imageNameSplitted{1}, '.mat'), 'distanceMatrix', 'Centroids');

        %In case you want to show the image
%         figure;
%         imshow(ImgCentroids)
%         for k=1:size(Centroids, 1)
%             c=Centroids(k,:);
%             text(c(1),c(2),sprintf('%d',k),'HorizontalAlignment','center','VerticalAlignment','middle','Color','Green','FontSize',10);
%         end
    
    end

    

end

