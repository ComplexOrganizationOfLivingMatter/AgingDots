clear
close all

%Create histogram with minimum raw & random distances, normalized by equidistance
%edges per image.
path2save='..\resultsByAnimal\NSCs BrdU\histogramsFigures\equidistancedEdgesNormalization';
distMatrixRawPath='..\resultsByAnimal\NSCs BrdU\distanceMatrix\rawImages\3m\';
if ~exist(path2save,'dir')
    mkdir(path2save);
end
dirAnimals=dir([distMatrixRawPath 'Animal*']);
totalPaths={dir([distMatrixRawPath dirAnimals(1).name '\*.mat']),dir([distMatrixRawPath dirAnimals(2).name '\*.mat']),dir([distMatrixRawPath dirAnimals(3).name '\*.mat']),dir([distMatrixRawPath dirAnimals(4).name '\*.mat'])};
numImages={size(totalPaths{1},1),size(totalPaths{2},1),size(totalPaths{3},1),size(totalPaths{4},1)};

titles={dirAnimals(1).name,dirAnimals(2).name,dirAnimals(3).name,dirAnimals(4).name};

for numAnimal=1:length(titles)
    distPaths=totalPaths{numAnimal};
    
    totalSetOfLogNormDistRaw=[];
    totalSetOfLogNormDistWithCornersRaw=[];
    for numImage=1:numImages{numAnimal}
        %normalize for each image
        pathDistanceMatrixRaw=[distMatrixRawPath titles{numAnimal} '\' distPaths(numImage).name];
        load(pathDistanceMatrixRaw,'distanceMatrixNSCsBrdU','distanceMatrixWithCornersNSCsBrdU');
        distanceMatrixWithCornersNSCsBrdU=unique(distanceMatrixWithCornersNSCsBrdU,'rows','stable');
        distanceMatrixWithCornersNSCsBrdU=unique(distanceMatrixWithCornersNSCsBrdU','rows','stable')';

        %get shortest edges between stem cells and normalize them by
        %equidistance. Edges are accumulated
        [ totalSetOfLogNormDistRaw ] = calculationOfNormalizedEdgesByEquidistance( totalSetOfLogNormDistRaw,distanceMatrixNSCsBrdU);
        [ totalSetOfLogNormDistWithCornersRaw ] = calculationOfNormalizedEdgesByEquidistance( totalSetOfLogNormDistWithCornersRaw,distanceMatrixWithCornersNSCsBrdU);
    end
    
    %represent all normalizations together
    name2saveHist=[path2save '\' titles{numAnimal} ' raw'];
    titleHist=[titles{numAnimal} ' raw']; 
    saveHistogramEdgesNormalized( totalSetOfLogNormDistRaw,name2saveHist,titleHist);
    saveHistogramEdgesNormalized( totalSetOfLogNormDistWithCornersRaw,[name2saveHist ' with corners'],[titleHist ' with corners']);

end
 
deletationPath='..\resultsByAnimal\NSCs BrdU\distanceMatrix\randomDeletionImages\3m\';
distMatRandomPaths={[deletationPath titles{1} '\'],[deletationPath titles{2} '\'],[deletationPath titles{3} '\'],[deletationPath titles{4} '\']};


for numAnimal=1:length(titles)
   numAnimal
   foldersOfRandomizationsOfAnimal=dir([distMatRandomPaths{numAnimal} '3-*']);
   listNDotsAnalized=1;
   
   totalSetOfLogNormDistRandom=[];
   totalSetOfLogNormDistRandomWithCorners=[];
   for numImage=1:size(foldersOfRandomizationsOfAnimal,1) 
       numImage
       distRandFiles=dir([distMatRandomPaths{numAnimal} '\' foldersOfRandomizationsOfAnimal(numImage).name '\*.mat']);
       for numRandom=1:size(distRandFiles,1)
            pathDistanceMatrixRandom=[distMatRandomPaths{numAnimal} foldersOfRandomizationsOfAnimal(numImage).name '\' distRandFiles(numRandom).name];            
            load(pathDistanceMatrixRandom,'infoCentroids','infoCentroidsWithCorners');
            distanceMatrixRandom=infoCentroids.distanceMatrix;
            distanceMatrixWithCornersRandom=unique(infoCentroidsWithCorners.distanceMatrix,'rows','stable');
            distanceMatrixWithCornersRandom=unique(distanceMatrixWithCornersRandom','rows','stable')';
            
            %don't repeat random with same number of point
            if numRandom==1 && sum(size(distanceMatrixRandom,1)==listNDotsAnalized)==1
                break
            end
           
            [ totalSetOfLogNormDistRandom ] = calculationOfNormalizedEdgesByEquidistance( totalSetOfLogNormDistRandom,distanceMatrixRandom);
            [ totalSetOfLogNormDistRandomWithCorners ] = calculationOfNormalizedEdgesByEquidistance( totalSetOfLogNormDistRandomWithCorners,distanceMatrixWithCornersRandom);
            
       end
       listNDotsAnalized=unique([listNDotsAnalized,size(distanceMatrixRandom,1)]);
   end

   %represent all ramdon normalizations together
    name2saveHist=[path2save '\' titles{numAnimal} ' random'];
    titleHist=[titles{numAnimal} ' random']; 
    saveHistogramEdgesNormalized( totalSetOfLogNormDistRandom,name2saveHist,titleHist);
    saveHistogramEdgesNormalized( totalSetOfLogNormDistRandomWithCorners,[name2saveHist ' with corners'],[titleHist ' with corners']);

   
   
end