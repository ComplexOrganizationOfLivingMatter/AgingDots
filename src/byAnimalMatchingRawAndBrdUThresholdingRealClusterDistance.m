clear
close all

%The purpose of this script is the calculation of a percentage of NO BrdU stem
%located in cluster, comparing with 
addpath('lib')

dirRaw='..\results\distanceMatrix\rawImages\';
dirRawBrdU='..\resultsByAnimal\NSCs BrdU\distanceMatrix\rawImages\3m\';
dirRandomBrdU='..\resultsByAnimal\NSCs BrdU\distanceMatrix\randomDeletionImages\3m\';

dirAnimals=dir([dirRawBrdU 'An*']);
nameAnimals={dirAnimals(1).name,dirAnimals(2).name,dirAnimals(3).name,dirAnimals(4).name};



for nAnimal=1:length(nameAnimals)
    
    
    
    %we examinate random
    dirImages=dir([dirRandomBrdU nameAnimals{nAnimal} '\3-*']);
    
    %inizialization of variables
    dataNSC20mc=zeros(length(dirImages),5);
    dataNSC50mc=zeros(length(dirImages),5);
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
        indNSCells=1:size(distanceMatrix,1);
        indNSCells(indCentroidsRawBrdUMatching)=[];
        distanceMatrixDismatching=distanceMatrix(indNSCells,:);
        distanceMatrixDismatching(distanceMatrixDismatching==0)=inf;
        edgesToStudy=min(distanceMatrixDismatching,[],2);
        [ ~, nNodesRawBrdUCluster20mc, ~, nNodesRawBrdUCluster50mc ] = checkClusterDistances( edgesToStudy, 1 );
        
        percentageNodesBrdUCluster20mc=nNodesRawBrdUCluster20mc/length(edgesToStudy);
        percentageNodesBrdUCluster50mc=nNodesRawBrdUCluster50mc/length(edgesToStudy);

        dirDistMatrixRandomBrdU=dir([dirRandomBrdU nameAnimals{nAnimal} '\' dirImages(nImg).name '\*.mat']);
        
        %inizialization acum
        acumNRandomBrdUCluster20mc=zeros(size(dirDistMatrixRandomBrdU,1),1);
        acumNRandomBrdUCluster50mc=zeros(size(dirDistMatrixRandomBrdU,1),1);
        acumPercEachRandomBrdUCluster20mc=zeros(size(dirDistMatrixRandomBrdU,1),1);
        acumPercEachRandomBrdUCluster50mc=zeros(size(dirDistMatrixRandomBrdU,1),1);
        for nRandom=1:size(dirDistMatrixRandomBrdU,1)
            %%Loading centroids random BrdU stem cells
            load([dirRandomBrdU nameAnimals{nAnimal} '\' dirImages(nImg).name '\' dirDistMatrixRandomBrdU(nRandom).name],'infoCentroids')
            centroidsRandomBrdU=infoCentroids.centroidsRandom;

            %get centroids matching in raw and random BrdU
            indCentroidsRandomBrdUMatching=cell2mat(arrayfun(@(x,y) find(sum([x==Centroids(:,1),y==Centroids(:,2)],2)==2),centroidsRandomBrdU(:,1),centroidsRandomBrdU(:,2),'UniformOutput',false));
        
            %get percentage of BrdU stem cells in cluster in Raw image
            indNSCells=1:size(distanceMatrix,1);
            indNSCells(indCentroidsRandomBrdUMatching)=[];
            distanceMatrixDismatching=distanceMatrix(indNSCells,:);
            distanceMatrixDismatching(distanceMatrixDismatching==0)=inf;
            edgesToStudy=min(distanceMatrixDismatching,[],2);
            [ ~, nNodesRandomBrdUCluster20mc, ~, nNodesRandomBrdUCluster50mc ] = checkClusterDistances( edgesToStudy,1);
            percentageNodesRandomBrdUCluster20mc=nNodesRandomBrdUCluster20mc/length(edgesToStudy);
            percentageNodesRandomBrdUCluster50mc=nNodesRandomBrdUCluster50mc/length(edgesToStudy);
            
            acumNRandomBrdUCluster20mc(nRandom)=nNodesRandomBrdUCluster20mc;
            acumNRandomBrdUCluster50mc(nRandom)=nNodesRandomBrdUCluster50mc;
            acumPercEachRandomBrdUCluster20mc(nRandom)=percentageNodesRandomBrdUCluster20mc;
            acumPercEachRandomBrdUCluster50mc(nRandom)=percentageNodesRandomBrdUCluster50mc;
        end      
        
        %acummulate num of random  nodes in cluster per image
        averageNodesRandomBrdUCluster20mc=mean(acumNRandomBrdUCluster20mc);
        averageNodesRandomBrdUCluster50mc=mean(acumNRandomBrdUCluster50mc);
        stdNodesRandomBrdUCluster20mc=std(acumNRandomBrdUCluster20mc);
        stdNodesRandomBrdUCluster50mc=std(acumNRandomBrdUCluster50mc);
        
        dataNSC20mc(nImg,1:5)=[size(distanceMatrix,1),length(indNSCells),nNodesRawBrdUCluster20mc,averageNodesRandomBrdUCluster20mc,stdNodesRandomBrdUCluster20mc];
        dataNSC50mc(nImg,1:5)=[size(distanceMatrix,1),length(indNSCells),nNodesRawBrdUCluster50mc,averageNodesRandomBrdUCluster50mc,stdNodesRandomBrdUCluster50mc];
        
        %acummulate percentages for a same animal
        acumPercNodesRawInCluster20mcInImage(nImg)=percentageNodesBrdUCluster20mc;
        acumPercNodesRawInCluster50mcInImage(nImg)=percentageNodesBrdUCluster50mc;
        acumPercNodesRandomInCluster20mcInImage(nImg)=mean(acumPercEachRandomBrdUCluster20mc);
        acumPercNodesRandomInCluster50mcInImage(nImg)=mean(acumPercEachRandomBrdUCluster50mc);
    end
    
    
    
    %calculate and save the average (and std) percentages for animal
    percNodesRawBrdUInCluster.average20mc=mean(acumPercNodesRawInCluster20mcInImage);
    percNodesRawBrdUInCluster.average50mc=mean(acumPercNodesRawInCluster50mcInImage);
    percNodesRawBrdUInCluster.std20mc=std(acumPercNodesRawInCluster20mcInImage);
    percNodesRawBrdUInCluster.std50mc=std(acumPercNodesRawInCluster50mcInImage);
    
    percNodesRandomBrdUInCluster.average20mc=mean(acumPercNodesRandomInCluster20mcInImage);
    percNodesRandomBrdUInCluster.average50mc=mean(acumPercNodesRandomInCluster50mcInImage);
    percNodesRandomBrdUInCluster.std20mc=std(acumPercNodesRandomInCluster20mcInImage);
    percNodesRandomBrdUInCluster.std50mc=std(acumPercNodesRandomInCluster50mcInImage);
    
    %array 2 table
    
    dataNSC20mc = array2table(dataNSC20mc,'VariableNames',{'numberOfTotalStemCells','numberOfNoBrdUStemCells','numberOfRawNoBrdUStemCellsInCluster','averageNumberOfRandomNoBrdUStemCellsInCluster','stdNumberOfRandomNoBrdUStemCellsInCluster'});
    dataNSC50mc = array2table(dataNSC50mc,'VariableNames',{'numberOfTotalStemCells','numberOfNoBrdUStemCells','numberOfRawNoBrdUStemCellsInCluster','averageNumberOfRandomNoBrdUStemCellsInCluster','stdNumberOfRandomNoBrdUStemCellsInCluster'});

    path2save=['..\resultsByAnimal\NSCs BrdU\clusterDistance\3m\'];
    if ~exist(path2save,'dir')
        mkdir(path2save)
    end
    save([path2save nameAnimals{nAnimal} '_percentajeNodesInCluster'],'percNodesRawBrdUInCluster','percNodesRandomBrdUInCluster','dataNSC20mc','dataNSC50mc')
end

clear