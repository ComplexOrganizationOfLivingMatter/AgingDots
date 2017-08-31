function [ meanNNodesClusterRandom20mc, stdNNodesClusterRandom20mc, meanNNodesClusterRandom50mc, stdNNodesClusterRandom50mc] = calculateNodesInCluster( directoryRandomFiles )
%CALCULATENODESINCLUSTER Summary of this function goes here
%   Detailed explanation goes here
    listNEdgesClusterRandom20mc=zeros(length(directoryRandomFiles),1);
    listNNodesClusterRandom20mc=zeros(length(directoryRandomFiles),1);
    listNEdgesClusterRandom50mc=zeros(length(directoryRandomFiles),1);
    listNNodesClusterRandom50mc=zeros(length(directoryRandomFiles),1);
    
    for numFile=1:length(directoryRandomFiles)
        fileName=directoryRandomFiles{numFile};
            
        load(fileName)
        distanceMatrix = infoCentroids.distanceMatrix;
        %%Add corners!!!
        [ nEdgesClusterRandom20mc, nNodesClusterRandom20mc, nEdgesClusterRandom50mc, nNodesClusterRandom50mc ] = checkClusterDistances( distanceMatrix );
        
        listNEdgesClusterRandom20mc(numFile)=nEdgesClusterRandom20mc;      
        listNNodesClusterRandom20mc(numFile)=nNodesClusterRandom20mc;
        
        listNEdgesClusterRandom50mc(numFile)=nEdgesClusterRandom50mc;
        listNNodesClusterRandom50mc(numFile)=nNodesClusterRandom50mc;
    end
    
    %nodes
    meanNNodesClusterRandom20mc=mean(listNNodesClusterRandom20mc);
    stdNNodesClusterRandom20mc=std(listNNodesClusterRandom20mc);
    
    meanNNodesClusterRandom50mc=mean(listNNodesClusterRandom50mc);
    stdNNodesClusterRandom50mc=std(listNNodesClusterRandom50mc);
    
    %edges
    meanNEdgesClusterRandom20mc=mean(listNEdgesClusterRandom20mc);
    stdNEdgesClusterRandom20mc=std(listNEdgesClusterRandom20mc);
    
    meanNEdgesClusterRandom50mc=mean(listNEdgesClusterRandom50mc);
    stdNEdgesClusterRandom50mc=std(listNEdgesClusterRandom50mc);
    
    rawFiles = getAllFiles('resultsByAnimal\NSCs BrdU\distanceMatrix\3m');
    fileNameSplitted = strsplit(fileName, '\');
    rawFileName = strcat(fileNameSplitted{end-1}, '.mat');
    rawFile = rawFiles{cellfun(@(x) isempty(strfind(x, rawFileName)) == 0, rawFiles)}; 
    load(rawFile);
    [ nEdgesClusterRandom20mc, nNodesClusterRandom20mc, nEdgesClusterRandom50mc, nNodesClusterRandom50mc ] = checkClusterDistances( distanceMatrixNSCsBrdU );
end

