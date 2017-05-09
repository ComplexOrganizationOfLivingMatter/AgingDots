function [ distanceMatrix ] = classifyByRegionAndCalculateDistanceMatrix(Centroids,invalidArea,H,W)
 
    distanceMatrices=cell(size(Centroids, 1));
    %find position in comparison with invalid region
    for i = 1:size(Centroids, 1)
        
            mask=zeros(H,W);
            mask(Centroids(i, 2), Centroids(i, 1)) = 1;
            distanceMatrices{i}=round(bwdist(mask));
        
        
            [~,Y]=find(invalidArea(Centroids(i, 2), :)==1);

            if isempty(Y)
                regionLabel(i)=3;
            elseif Y(1) > Centroids(i, 1)
                regionLabel(i)=2;
            elseif Y(1) < Centroids(i, 1)
                regionLabel(i)=1;
            end
    end
    
    %find blue max point as reference to calculate distance.
    [X,Y]=find(invalidArea==1);
    mask=zeros(H,W);
    mask(X(1),Y(1)) = 1;
    distanceMatrixReference=round(bwdist(mask));
    
    distanceMatrixFinal=[];
    for i = 1:size(Centroids, 1)

        distImg=distanceMatrices{i};

        for j = i+1:size(Centroids, 1)

            if (regionLabel(i)==1 && regionLabel(j)==2) || (regionLabel(i)==2 && regionLabel(j)==1)
                distanceMatrixFinal(i,j)=distanceMatrixReference(Centroids(j, 2), Centroids(j, 1))+distanceMatrixReference(Centroids(i, 2), Centroids(i, 1));
                distanceMatrixFinal(j,i)=distanceMatrixReference(Centroids(j, 2), Centroids(j, 1))+distanceMatrixReference(Centroids(i, 2), Centroids(i, 1));
            else
                distanceMatrixFinal(i,j)=distImg(Centroids(j, 2), Centroids(j, 1));
                distanceMatrixFinal(j,i)=distImg(Centroids(j, 2), Centroids(j, 1));
            end

        end
    end
    distanceMatrix = distanceMatrixFinal;

end

