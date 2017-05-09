function [  ] = calculateDistanceMatrixAlphaOmega(  )
    %Developed by Pedro Gomez-Galvez and Pablo Vicente-Munuera

    addpath('lib\')

    %Detecting alpha and omega points

    %load all paths (former raw images distanceMatrices and new images alpha & omega)
    centroidPathFiles = ['..\results\distanceMatrix\rawImages\'];
    newPointsFiles = getAllFiles('..\data\sortedByAnimal\AlphaDotOmegaCrossNSCs\');
    splittedPath = cellfun(@(x) strsplit(x, '\'), newPointsFiles, 'UniformOutput', false);
    newPointsFilesOnlyFileName = cellfun(@(x) x{end}, splittedPath, 'UniformOutput', false);
    newPointsFilesOnlyFileName = cellfun(@(x) x(1:end-4), newPointsFilesOnlyFileName, 'UniformOutput', false);
    for nFile = 1:length(newPointsFiles)
        %load raw image Alpha Omega
        fullPathFile = newPointsFiles{nFile};
        fileNameSplitted = strsplit(fullPathFile, '\');
        imgName = fileNameSplitted{end};
        imgName = imgName(1:end-4);
        rawImg = imread(fullPathFile);
        [H,W,~]=size(rawImg);
%         imshow(rawImg)
        %find Omega stem cells
        ImgOmega = rawImg(:, :, 1) - rawImg(:, :, 3);
        BWomega=im2bw(ImgOmega,0.5);
        BWdilateOmega=imdilate(BWomega,[1,1,1;1,1,1;1,1,1]);
%         figure;imshow(BWdilateOmega)

        %load invalid area from Img
        if strcmp(imgName(1),'1')
            invAreaImg=imread(['..\data\WithInvalidArea\' imgName(1:2) 'm\' imgName  '.bmp']);
            month=[imgName(1:2) 'm'];
        else
            invAreaImg=imread(['..\data\WithInvalidArea\3m\' imgName '.bmp']);
            month='3m';
        end
        invalidArea = invAreaImg(:, :, 1) == 0 & invAreaImg(:, :, 3);

        %load all centroids of raw image
        load([centroidPathFiles imgName '.mat'],'Centroids');
        maskCentroids=zeros(H,W);
        for j=1:size(Centroids,1)
           maskCentroids(Centroids(j,2),Centroids(j,1))=1; 
        end

        %intersect centroids Omega and take the rest as Alpha centroids
        maskOmegaCells=BWdilateOmega.*maskCentroids;
        [a,b]=find(maskOmegaCells==1);
        CentroidsOmega = [b,a];
        imageAlphaCells=maskCentroids-maskOmegaCells;
        [a,b]=find(imageAlphaCells==1);
        CentroidsAlpha = [b,a];
%         figure;imshow(imdilate(imageAlphaCells,[1,1,1;1,1,1;1,1,1]));

        %Checking by command window
        if (size(CentroidsAlpha,1)+size(CentroidsOmega,1))~=size(Centroids,1)
            [imgName ': ' num2str(size(CentroidsAlpha,1)) ' alpha cells, ' num2str(size(CentroidsOmega,1)) ' omega cells. ' num2str(size(Centroids,1)) ' stem cells']
        end

%         close all

        %Calculate distance Matrix from centroids and invalid area
        distanceMatrixOmega=classifyByRegionAndCalculateDistanceMatrix(CentroidsOmega,invalidArea,H,W);
        distanceMatrixAlpha=classifyByRegionAndCalculateDistanceMatrix(CentroidsAlpha,invalidArea,H,W);

        thisSplittedPath=splittedPath{nFile};


        if ~isdir(['..\resultsByAnimal\AlphaOmega\distanceMatrix\' month '\' thisSplittedPath{6} '\'])
            mkdir(['..\resultsByAnimal\AlphaOmega\distanceMatrix\' month '\' thisSplittedPath{6} '\']);
        end
        save(['..\resultsByAnimal\AlphaOmega\distanceMatrix\'  month '\' thisSplittedPath{6} '\' imgName '.mat'],'distanceMatrixOmega','distanceMatrixAlpha','CentroidsOmega','CentroidsAlpha')
    end

end

