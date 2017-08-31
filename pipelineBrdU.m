function [ ] = pipelineBrdU( )
%PIPELINE Summary of this function goes here
%   Detailed explanation goes here
    addpath(genpath('src'))
    
    calculateDistanceMatrixNSCsBrdU
    %% Calculated only for 3 months
    randomPickBrdU
    
    resultsPath = 'resultsByAnimal\NSCs BrdU\randomElection\';
    dirAnimals = dir(resultsPath);
    for numAnimal = 3:size(dirAnimals, 1)
        animalDir = strcat(resultsPath, dirAnimals(numAnimal).name);
        dirImages = dir(animalDir);
        for numImage = 3:size(dirImages, 1)
            randomFiles = getAllFiles(strcat(animalDir, '\', dirImages(numImage).name));
            [ meanNNodesClusterRandom20mc, stdNNodesClusterRandom20mc, meanNNodesClusterRandom50mc, stdNNodesClusterRandom50mc] = calculateNodesInCluster(randomFiles);
        end
    end
end

