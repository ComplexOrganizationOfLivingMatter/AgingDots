function [ nEdgesClusterRandom20mc, nNodesClusterRandom20mc, nEdgesClusterRandom50mc, nNodesClusterRandom50mc ] = checkClusterDistances( distanceMatrix )
%CHECKCLUSTERDISTANCES Summary of this function goes here
%   Detailed explanation goes here
    auxMatrix=triu(distanceMatrix);
    auxMatrix(auxMatrix==0)=[];
    
    threshold20mic=26.4;
    threshold50mic=66;
    
    %20 micras. Edges & nodes
    nEdgesClusterRandom20mc=sum(auxMatrix<threshold20mic);
    [nodesCluster,~]=find((distanceMatrix<threshold20mic) & (distanceMatrix>0));
    nNodesClusterRandom20mc=length(unique(nodesCluster));
    
    %50 micras. Edges & nodes
    nEdgesClusterRandom50mc=sum(auxMatrix<threshold50mic);
    [nodesCluster,~]=find((distanceMatrix<threshold50mic) & (distanceMatrix>0));
    nNodesClusterRandom50mc=length(unique(nodesCluster));
end

