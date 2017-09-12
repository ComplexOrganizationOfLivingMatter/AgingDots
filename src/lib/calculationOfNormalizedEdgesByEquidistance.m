function [ totalSetOfLogNormDist ] = calculationOfNormalizedEdgesByEquidistance(totalSetOfLogNormDist,distanceMatrix)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
            
        maxDist=max(max(distanceMatrix));
        equidistThreshold=maxDist/(size(distanceMatrix,1)-1);

        if size(distanceMatrix,1)>9
            minDist=distanceMatrix;
            minDist(minDist==0)=inf;
            %get minimun distance edge per node
            minDist=min(minDist,[],1);
            %get maximum distance between nodes, dividing them per nodes - 1,
            %to adquire an imaginary equidistance nodes configuration
            normDist=minDist/equidistThreshold;
            logNormDist=log(normDist);
            totalSetOfLogNormDist=[totalSetOfLogNormDist,logNormDist];
        else
            %hamiltonian
            if size(distanceMatrix,1)>1
                [Source,Destination]=find(distanceMatrix==max(max(distanceMatrix)));
                hamPath=hamiltonian(sparse(distanceMatrix), Source(1), Destination(1));
                indDistMat=[hamPath(1:end-1)',hamPath(2:end)'];
                distancesEdges=arrayfun(@(x,y) distanceMatrix(x,y),indDistMat(:,1),indDistMat(:,2),'UniformOutput',false);
                normDist=cell2mat(distancesEdges)/equidistThreshold;
                logNormDist=log(normDist);
                totalSetOfLogNormDist=[totalSetOfLogNormDist,logNormDist'];
            end           
        end



end

