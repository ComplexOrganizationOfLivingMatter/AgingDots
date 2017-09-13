clear
close all

%The purpose of this script is the calculation of a percentage of BrdU stem
%cells located in clusters in the global set of stem cells.
addpath('lib')

dirRaw='..\results\distanceMatrix\rawImages\';
dirRawBrdU='..\resultsByAnimal\NSCs BrdU\distanceMatrix\rawImages\3m\';
dirRandomBrdU='..\resultsByAnimal\NSCs BrdU\distanceMatrix\randomDeletionImages\3m\';

dirAnimals=dir([dirRawBrdU 'An*']);
nameAnimals={dirAnimals(1).name,dirAnimals(2).name,dirAnimals(3).name,dirAnimals(4).name};

for nAnimal=1:length(nameAnimals)
    %we examinate first raw

    %we examinate random
    dirImages=dir([dirRandomBrdU nameAnimals{nAnimal} '\3-*']);
    
    
    acumPercNodesRawInCluster20mcInImage=zeros(size(dirImages,1),1);
    acumPercNodesRawInCluster50mcInImage=zeros(size(dirImages,1),1);
    acumPercNodesRandomInCluster20mcInImage=zeros(size(dirImages,1),1);
    acumPercNodesRandomInCluster50mcInImage=zeros(size(dirImages,1),1);
    
    for nImg=1:size(dirImages,1)
        
        %%Loading distance matrix and centroids raw
        load([dirRaw dirImages(nImg).name '.mat'],'Centroids','distanceMatrix')
        %%Loading centroids raw BrdU stem cells
        load([dirRawBrdU nameAnimals{nAnimal} '\' dirImages(nImg).name '.mat'],'centroidsNSCsBrdU')
        
        %get centroids matching in raw and BrdU
        indCentroidsRawBrdUMatching=cell2mat(arrayfun(@(x,y) find(sum([x==Centroids(:,1),y==Centroids(:,2)],2)==2),centroidsNSCsBrdU(:,1),centroidsNSCsBrdU(:,2),'UniformOutput',false));
        
        %get percentage of BrdU stem cells in cluster in Raw image
        distanceMatrixMatching=distanceMatrix(indCentroidsRawBrdUMatching,:);
        distanceMatrixMatching(distanceMatrixMatching==0)=inf;
        edgesToStudy=min(distanceMatrixMatching,[],2);
        [ ~, nNodesRawBrdUCluster20mc, ~, nNodesRawBrdUCluster50mc ] = checkClusterDistances( edgesToStudy, 1 );
        
        percentageNodesBrdUCluster20mc=nNodesRawBrdUCluster20mc/length(edgesToStudy);
        percentageNodesBrdUCluster50mc=nNodesRawBrdUCluster50mc/length(edgesToStudy);

%       distanceMatrixFilteredByRawBrdUStemCells=;
        
        dirDistMatrixRandomBrdU=dir([dirRandomBrdU nameAnimals{nAnimal} '\' dirImages(nImg).name '\*.mat']);
        
        acumPercEachRandomBrdUCluster20mc=zeros(size(dirDistMatrixRandomBrdU,1),1);
        acumPercEachRandomBrdUCluster50mc=zeros(size(dirDistMatrixRandomBrdU,1),1);
        for nRandom=1:size(dirDistMatrixRandomBrdU,1)
            %%Loading centroids random BrdU stem cells
            load([dirRandomBrdU nameAnimals{nAnimal} '\' dirImages(nImg).name '\' dirDistMatrixRandomBrdU(nRandom).name],'infoCentroids')
            centroidsRandomBrdU=infoCentroids.centroidsRandom;

            %get centroids matching in raw and random BrdU
            indCentroidsRandomBrdUMatching=cell2mat(arrayfun(@(x,y) find(sum([x==Centroids(:,1),y==Centroids(:,2)],2)==2),centroidsRandomBrdU(:,1),centroidsRandomBrdU(:,2),'UniformOutput',false));
        
            %get percentage of BrdU stem cells in cluster in Raw image
            distanceMatrixMatching=distanceMatrix(indCentroidsRandomBrdUMatching,:);
            distanceMatrixMatching(distanceMatrixMatching==0)=inf;
            edgesToStudy=min(distanceMatrixMatching,[],2);
            [ ~, nNodesRandomBrdUCluster20mc, ~, nNodesRandomBrdUCluster50mc ] = checkClusterDistances( edgesToStudy,1);
            percentageNodesRandomBrdUCluster20mc=nNodesRandomBrdUCluster20mc/length(edgesToStudy);
            percentageNodesRandomBrdUCluster50mc=nNodesRandomBrdUCluster50mc/length(edgesToStudy);
            
            acumPercEachRandomBrdUCluster20mc(nRandom)=percentageNodesRandomBrdUCluster20mc;
            acumPercEachRandomBrdUCluster50mc(nRandom)=percentageNodesRandomBrdUCluster50mc;
        end      
        
        %acummulate percentages for a same animal
        acumPercNodesRawInCluster20mcInImage(nImg)=percentageNodesBrdUCluster20mc;
        acumPercNodesRawInCluster50mcInImage(nImg)=percentageNodesBrdUCluster50mc;
        acumPercNodesRandomInCluster20mcInImage(nImg)=mean(acumPercEachRandomBrdUCluster20mc);
        acumPercNodesRandomInCluster50mcInImage(nImg)=mean(acumPercEachRandomBrdUCluster50mc);
    end
    
    %calculate and save the average (and std) percentages for animal
    nodesRawBrdUInCluster.average20mc=mean(acumPercNodesRawInCluster20mcInImage);
    nodesRawBrdUInCluster.average50mc=mean(acumPercNodesRawInCluster50mcInImage);
    nodesRawBrdUInCluster.std20mc=std(acumPercNodesRawInCluster20mcInImage);
    nodesRawBrdUInCluster.std50mc=std(acumPercNodesRawInCluster50mcInImage);
    
    nodesRandomBrdUInCluster.average20mc=mean(acumPercNodesRandomInCluster20mcInImage);
    nodesRandomBrdUInCluster.average50mc=mean(acumPercNodesRandomInCluster50mcInImage);
    nodesRandomBrdUInCluster.std20mc=std(acumPercNodesRandomInCluster20mcInImage);
    nodesRandomBrdUInCluster.std50mc=std(acumPercNodesRandomInCluster50mcInImage);
    
    path2save=['..\resultsByAnimal\NSCs BrdU\clusterDistance\3m\'];
    if ~exist(path2save,'dir')
        mkdir(path2save)
    end
    save([path2save nameAnimals{nAnimal} '_percentajeNodesInCluster'],'nodesRawBrdUInCluster','nodesRandomBrdUInCluster')
end