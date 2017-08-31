function [ meanNNodesClusterRandom20mc, stdNNodesClusterRandom20mc, meanNNodesClusterRandom50mc, stdNNodesClusterRandom50mc] = calculateNodesInCluster( directoryRandomFiles )
%CALCULATENODESINCLUSTER Summary of this function goes here
%   Detailed explanation goes here
    listNEdgesClusterRandom20mc=zeros(length(directoryRandomFiles),1);
    listNNodesClusterRandom20mc=zeros(length(directoryRandomFiles),1);
    listNEdgesClusterRandom50mc=zeros(length(directoryRandomFiles),1);
    listNNodesClusterRandom50mc=zeros(length(directoryRandomFiles),1);
    
    threshold20mic=26.4;
    threshold50mic=66;
    
    for numFile=1:length(directoryRandomFiles)
        fileName=directoryRandomFiles{numFile};
            
        load(fileName)
        distanceMatrix = infoCentroids.distanceMatrix;
        
        auxMatrix=triu(distanceMatrix);
        auxMatrix(auxMatrix==0)=[];
        
        %20 micras. Edges & nodes
        nEdgesClusterRandom20mc=sum(auxMatrix<threshold20mic);
        [nodesCluster,~]=find((distanceMatrix<threshold20mic) & (distanceMatrix>0));
        nNodesClusterRandom20mc=length(unique(nodesCluster));
        
        listNEdgesClusterRandom20mc(numFile)=nEdgesClusterRandom20mc;      
        listNNodesClusterRandom20mc(numFile)=nNodesClusterRandom20mc;
        
        %50 micras. Edges & nodes
        nEdgesClusterRandom50mc=sum(auxMatrix<threshold50mic);
        [nodesCluster,~]=find((distanceMatrix<threshold50mic) & (distanceMatrix>0));
        nNodesClusterRandom50mc=length(unique(nodesCluster));
        
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

end

