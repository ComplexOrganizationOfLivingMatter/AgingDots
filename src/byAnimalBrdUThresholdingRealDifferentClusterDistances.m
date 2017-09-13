clear
close all

%The purpose of this script is the calculation of a percentage of BrdU stem
%cells located in clusters in the global set of stem cells.
addpath('lib')

dirRaw='..\results\distanceMatrix\rawImages\';
dirRawBrdU='..\resultsByAnimal\NSCs BrdU\distanceMatrix\rawImages\3m\';
dirRandomBrdU='..\resultsByAnimal\NSCs BrdU\distanceMatrix\randomDeletionImages\3m\';

nXdistanceCluster=[1,2,5,10];

dirAnimals=dir([dirRawBrdU 'An*']);
nameAnimals={dirAnimals(1).name,dirAnimals(2).name,dirAnimals(3).name,dirAnimals(4).name};

for nBox=1:length(nXdistanceCluster)

    for nAnimal=1:length(nameAnimals)
        %we examinate first raw

        %we examinate random
        dirImages=dir([dirRandomBrdU nameAnimals{nAnimal} '\3-*']);

        %initialize acummulator
        acumNumberOfCells=zeros(size(dirImages,1),1);
        acumPercNodesRawInCluster20mcInImage=zeros(size(dirImages,1),1);
        acumPercNodesRawInCluster50mcInImage=zeros(size(dirImages,1),1);
        acumNumberOfNodesRawInCluster20mcInImage=zeros(size(dirImages,1),1);
        acumNumberOfNodesRawInCluster50mcInImage=zeros(size(dirImages,1),1);
        acumPercNodesRandomInCluster20mcInImage=zeros(size(dirImages,1),1);
        acumPercNodesRandomInCluster50mcInImage=zeros(size(dirImages,1),1);
        acumNumberOfNodesRandomInCluster20mcInImage=zeros(size(dirImages,1),1);
        acumNumberOfNodesRandomInCluster50mcInImage=zeros(size(dirImages,1),1);
        acumStdPercNodesRandomInCluster20mcInImage=zeros(size(dirImages,1),1);
        acumStdPercNodesRandomInCluster50mcInImage=zeros(size(dirImages,1),1);
        acumStdNumberOfNodesRandomInCluster20mcInImage=zeros(size(dirImages,1),1);
        acumStdNumberOfNodesRandomInCluster50mcInImage=zeros(size(dirImages,1),1);

        for nImg=1:size(dirImages,1)

            %%Loading centroids raw BrdU stem cells
            load([dirRawBrdU nameAnimals{nAnimal} '\' dirImages(nImg).name '.mat'],'distanceMatrixNSCsBrdU')

            %get percentage of BrdU stem cells in clusters
            distanceMatrixNSCsBrdU(distanceMatrixNSCsBrdU==0)=inf;
            edgesToStudy=min(distanceMatrixNSCsBrdU,[],2);
            [ ~, nNodesRawBrdUCluster20mc, ~, nNodesRawBrdUCluster50mc ] = checkClusterDistances(edgesToStudy, nXdistanceCluster(nBox));
            percentageNodesBrdUCluster20mc=nNodesRawBrdUCluster20mc/length(edgesToStudy);
            percentageNodesBrdUCluster50mc=nNodesRawBrdUCluster50mc/length(edgesToStudy);

            %directory of random files .mat
            dirDistMatrixRandomBrdU=dir([dirRandomBrdU nameAnimals{nAnimal} '\' dirImages(nImg).name '\*.mat']);

            acumPercEachRandomBrdUCluster20mc=zeros(size(dirDistMatrixRandomBrdU,1),1);
            acumPercEachRandomBrdUCluster50mc=zeros(size(dirDistMatrixRandomBrdU,1),1);
            acumNnodesEachRandomBrdUCluster20mc=zeros(size(dirDistMatrixRandomBrdU,1),1);
            acumNnodesEachRandomBrdUCluster50mc=zeros(size(dirDistMatrixRandomBrdU,1),1);
            for nRandom=1:size(dirDistMatrixRandomBrdU,1)
                %%Loading centroids random BrdU stem cells
                load([dirRandomBrdU nameAnimals{nAnimal} '\' dirImages(nImg).name '\' dirDistMatrixRandomBrdU(nRandom).name],'infoCentroids')
                distanceMatrixNSCsBrdU=infoCentroids.distanceMatrix;

                %get percentage of BrdU stem cells in cluster in Raw image
                distanceMatrixNSCsBrdU(distanceMatrixNSCsBrdU==0)=inf;
                edgesToStudy=min(distanceMatrixNSCsBrdU,[],2);
                [ ~, nNodesRandomBrdUCluster20mc, ~, nNodesRandomBrdUCluster50mc ] = checkClusterDistances( edgesToStudy,nXdistanceCluster(nBox));
                percentageNodesRandomBrdUCluster20mc=nNodesRandomBrdUCluster20mc/length(edgesToStudy);
                percentageNodesRandomBrdUCluster50mc=nNodesRandomBrdUCluster50mc/length(edgesToStudy);

                acumPercEachRandomBrdUCluster20mc(nRandom)=percentageNodesRandomBrdUCluster20mc;
                acumPercEachRandomBrdUCluster50mc(nRandom)=percentageNodesRandomBrdUCluster50mc;
                acumNnodesEachRandomBrdUCluster20mc(nRandom)=nNodesRandomBrdUCluster20mc;
                acumNnodesEachRandomBrdUCluster50mc(nRandom)=nNodesRandomBrdUCluster50mc;
            end      

            %acummulate percentages and number of nodes in cluster for a same animal
            acumNumberOfCells(nImg)=length(edgesToStudy);
            acumPercNodesRawInCluster20mcInImage(nImg)=percentageNodesBrdUCluster20mc;
            acumPercNodesRawInCluster50mcInImage(nImg)=percentageNodesBrdUCluster50mc;
            acumPercNodesRandomInCluster20mcInImage(nImg)=mean(acumPercEachRandomBrdUCluster20mc);
            acumPercNodesRandomInCluster50mcInImage(nImg)=mean(acumPercEachRandomBrdUCluster50mc);
            acumStdPercNodesRandomInCluster20mcInImage(nImg)=std(acumPercEachRandomBrdUCluster20mc);
            acumStdPercNodesRandomInCluster50mcInImage(nImg)=std(acumPercEachRandomBrdUCluster50mc);
            
            acumNumberOfNodesRawInCluster20mcInImage(nImg)=nNodesRawBrdUCluster20mc;
            acumNumberOfNodesRawInCluster50mcInImage(nImg)=nNodesRawBrdUCluster50mc;
            acumNumberOfNodesRandomInCluster20mcInImage(nImg)=mean(acumNnodesEachRandomBrdUCluster20mc);
            acumNumberOfNodesRandomInCluster50mcInImage(nImg)=mean(acumNnodesEachRandomBrdUCluster50mc);
            acumStdNumberOfNodesRandomInCluster20mcInImage(nImg)=mean(acumNnodesEachRandomBrdUCluster20mc);
            acumStdNumberOfNodesRandomInCluster50mcInImage(nImg)=mean(acumNnodesEachRandomBrdUCluster50mc);
        end

        %organize and save extracted date for each animal
        allDataClusterExtracted=[acumNumberOfCells,acumNumberOfNodesRawInCluster20mcInImage,acumNumberOfNodesRawInCluster50mcInImage,...
            acumNumberOfNodesRandomInCluster20mcInImage,acumNumberOfNodesRandomInCluster50mcInImage,...
            acumStdNumberOfNodesRandomInCluster20mcInImage,acumStdNumberOfNodesRandomInCluster50mcInImage...
            acumPercNodesRawInCluster20mcInImage,acumPercNodesRawInCluster50mcInImage,...
            acumPercNodesRandomInCluster20mcInImage,acumPercNodesRandomInCluster50mcInImage,...
            acumStdPercNodesRandomInCluster20mcInImage,acumStdPercNodesRandomInCluster50mcInImage...
            ];
        
        allDataClusterExtracted=sortrows(allDataClusterExtracted);
        
        tableNumberBrdUCellsInCluster = array2table(allDataClusterExtracted(:,1:7),'VariableNames',{'numCells','nSCBrdUClust20mc','nSCBrdUClust50mc',...
            'averageNSCRandomClust20mc','averageNSCRandomClust50mc','stdNSCRandomClust20mc','stdNSCRandomClust50mc'});
        tablePercentageBrdUCellsInCluster = array2table([allDataClusterExtracted(:,1), allDataClusterExtracted(:,8:end)],'VariableNames',{'numCells',...
            'percSCBrdUClust20mc','percSCBrdUClust50mc','averagePercNSCRandomClust20mc','averagePercNSCRandomClust50mc','stdPercNSCRandomClust20mc',...
            'stdPercNSCRandomClust50mc'});
        
        path2save='..\resultsByAnimal\NSCs BrdU\clusterDistance\3m\';
        if ~exist(path2save,'dir')
            mkdir(path2save)
        end
        
        writetable(tableNumberBrdUCellsInCluster,[path2save 'numberOfBrdUCellsInCluster.xlsx'],'sheet',[num2str(nXdistanceCluster(nBox)) 'x'],'range',['B' num2str(2+(length(acumNumberOfCells)+2)*(nAnimal-1)) ':H' num2str(2+(length(acumNumberOfCells)+2)*nAnimal)])
        writetable(tablePercentageBrdUCellsInCluster,[path2save 'percOfBrdUCellsInCluster.xlsx'],'sheet',[num2str(nXdistanceCluster(nBox)) 'x'],'range',['B' num2str(2+(length(acumNumberOfCells)+2)*(nAnimal-1)) ':H' num2str(2+(length(acumNumberOfCells)+2)*nAnimal)]);

        save([path2save nameAnimals{nAnimal} '_percentajeNodesInCluster_' num2str(nXdistanceCluster(nBox)) 'xDistCluster'],'tableNumberBrdUCellsInCluster','tablePercentageBrdUCellsInCluster')
    end
end