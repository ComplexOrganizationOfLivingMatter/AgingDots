function [ nEdgesClusterRandom20mc, nNodesClusterRandom20mc, nEdgesClusterRandom50mc, nNodesClusterRandom50mc ] = checkClusterDistances( distanceMatrix, nThreshold )
%CHECKCLUSTERDISTANCES Summary of this function goes here
%   Detailed explanation goes here

    threshold20mic=nThreshold*26.4;
    threshold50mic=nThreshold*66;

    if size(distanceMatrix,1)==size(distanceMatrix,2) && size(distanceMatrix,1)>1
        auxMatrix=triu(distanceMatrix);
        auxMatrix(auxMatrix==0)=[];
    else
        auxMatrix=distanceMatrix;
    end
    
    

    %20 micras. Edges & nodes
    nEdgesClusterRandom20mc=sum(auxMatrix<threshold20mic);
    [nodesCluster,~]=find((distanceMatrix<threshold20mic) & (distanceMatrix>0));
    nNodesClusterRandom20mc=length(unique(nodesCluster));

    %50 micras. Edges & nodes
    nEdgesClusterRandom50mc=sum(auxMatrix<threshold50mic);
    [nodesCluster,~]=find((distanceMatrix<threshold50mic) & (distanceMatrix>0));
    nNodesClusterRandom50mc=length(unique(nodesCluster));
    
end

