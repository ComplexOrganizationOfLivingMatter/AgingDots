clear
close all

%Create histogram with minimum raw & random distances, normalized by equidistance
%edges per image.
path2save='..\results\histogramsFigures\shortestEdgesPerStemCellEquidistanceNormalization (Only raw)';
distMatrixRawPath='..\results\distanceMatrix\rawImages\';
totalPaths={dir([distMatrixRawPath '3-*.mat']),dir([distMatrixRawPath '12-*.mat']),dir([distMatrixRawPath '18-*.mat'])};
numImages={size(totalPaths{1},1),size(totalPaths{2},1),size(totalPaths{3},1)};
titles={'3','12','18'};

for n=1:length(titles)
    distPaths=totalPaths{n};
    
    totalSetOfLogNormDist=[];
    for i=1:numImages{n}
        %normalize for each image
        pathDistanceMatrixRaw=[distMatrixRawPath distPaths(i).name];
        load(pathDistanceMatrixRaw,'distanceMatrix');
        %get shortest edges between stem cells and normalize them by
        %equidistance. Edges are accumulated
        [ totalSetOfLogNormDist ] = calculationOfNormalizedEdgesByEquidistance( totalSetOfLogNormDist,distanceMatrix);

    end
    
    %represent all normalizations together
    name2saveHist=[path2save '\' titles{n} ' months raw'];
    titleHist=[titles{n} ' months raw']; 
    saveHistogramEdgesNormalized( totalSetOfLogNormDist,name2saveHist,titleHist);

end
 
deletationPath='..\results\distanceMatrix\randomDeletionImages\';
distMatRandomPaths={[deletationPath '12 months'],[deletationPath '18 months']};
folderM={dir([distMatRandomPaths{1} '\12_*']),dir([distMatRandomPaths{2} '\18_*'])};
titles={'12','18'};

for n=1:length(titles)
   n
   folders=folderM{n};
    
   listNDotsAnalized=1;
   totalSetOfLogNormDist=[];
   for i=1:size(folderM{n}) 
       i
       distRandFiles=dir([distMatRandomPaths{n} '\' folders(i).name '\*.mat']);
       for j=1:size(distRandFiles,1)
            pathDistanceMatrixRandom=[distMatRandomPaths{n} '\' folders(i).name '\' distRandFiles(j).name];
            load(pathDistanceMatrixRandom,'distanceMatrix');
            %don't repeat random with same number of point
            if j==1 && sum(size(distanceMatrix,1)==listNDotsAnalized)==1
                break
            end
            [ totalSetOfLogNormDist ] = calculationOfNormalizedEdgesByEquidistance( totalSetOfLogNormDist,distanceMatrix);
       end
       listNDotsAnalized=unique([listNDotsAnalized,size(distanceMatrix,1)]);
   end
   
   %represent all ramdon normalizations together
   name2saveHist=[path2save '\' titles{n} ' months random'];
   titleHist=[titles{n} ' months random']; 
   saveHistogramEdgesNormalized(totalSetOfLogNormDist,name2saveHist,titleHist);
   
end