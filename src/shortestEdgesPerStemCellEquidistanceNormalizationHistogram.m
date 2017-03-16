clear all
close all

%Create histogram with minimum raw & random distances, normalized by equidistance
%edges per image.
toSavePath='D:\Pedro\AgingDots\results\histogramsFigures\shortestEdgesPerStemCellEquidistanceNormalization (Only raw)';
distMatrixRawPath='D:\Pedro\AgingDots\results\distanceMatrix\rawImages\';
dist3monthRaw=dir([distMatrixRawPath '3-*.mat']);
size3monthRaw=size(dist3monthRaw,1);
dist12monthRaw=dir([distMatrixRawPath '12-*.mat']);
size12monthRaw=size(dist12monthRaw,1);
dist18monthRaw=dir([distMatrixRawPath '18-*.mat']);
size18monthRaw=size(dist18monthRaw,1);

numImages={size3monthRaw,size12monthRaw,size18monthRaw};
totalPaths={dist3monthRaw,dist12monthRaw,dist18monthRaw};
titles={'3','12','18'};

for n=1:3
    distPaths=totalPaths{n};
    
    totalSetOfLogNormDist=[];
    for i=1:numImages{n}
        %normalize for each image
        
        
        load([distMatrixRawPath distPaths(i).name],'distanceMatrix');
        minDist=distanceMatrix;
        minDist(minDist==0)=inf;
        %get minimun distance edge per node
        minDist=min(minDist,[],1);
        %get maximum distance between nodes, dividing them per nodes - 1,
        %to adquire an imaginary equidistance nodes configuration
        maxDist=max(max(distanceMatrix));
        equidistThreshold=maxDist/(size(distanceMatrix,1)-1);
        
        normDist=minDist/equidistThreshold;
        logNormDist=log(normDist);
        totalSetOfLogNormDist=[totalSetOfLogNormDist,logNormDist];
    end
    
    %represent all normalizations together
    h=figure('Visible','off');
    hold on
    histogram(totalSetOfLogNormDist,40,'BinLimits',[-4,4],'Normalization','probability')
    title([titles{n} ' months raw minimum edges distribution'])
    ylabel('frequency')
    xlabel('minimum normalized edges - equidistance (log)')
    saveas(h,[toSavePath '\' titles{n} ' months raw minimum edges distribution 0.25 precision.jpg'])
end
 

distMatrix12mRandomPath='D:\Pedro\AgingDots\results\distanceMatrix\randomDeletionImages\12 months';
distMatrix18mRandomPath='D:\Pedro\AgingDots\results\distanceMatrix\randomDeletionImages\18 months';
distMatRandomPaths={distMatrix12mRandomPath,distMatrix18mRandomPath};

folder12mRandom=dir([distMatrix12mRandomPath '\12_*']);
folder18mRandom=dir([distMatrix18mRandomPath '\18_*']);
folderM={folder12mRandom,folder18mRandom};

titles={'12','18'};

for n=1:2
   n
   folders=folderM{n};
    
   listNDotsAnalized=[1];
   totalSetOfLogNormDist=[];
   for i=1:size(folderM{n}) 
       i
       distRandFiles=dir([distMatRandomPaths{n} '\' folders(i).name '\*.mat']);
       
       for j=1:size(distRandFiles,1)
            load([distMatRandomPaths{n} '\' folders(i).name '\' distRandFiles(j).name],'distanceMatrix');
            %don't repeat random with same number of point
            if j==1 && sum(size(distanceMatrix,1)==listNDotsAnalized)==1
                break
            end
            minDist=distanceMatrix;
            minDist(minDist==0)=inf;
            %get minimun distance edge per node
            minDist=min(minDist,[],1);
            %get maximum distance between nodes, dividing them per nodes - 1,
            %to adquire an imaginary equidistance nodes configuration
            maxDist=max(max(distanceMatrix));
            equidistThreshold=maxDist/(size(distanceMatrix,1)-1);

            normDist=minDist/equidistThreshold;
            logNormDist=log(normDist);
            totalSetOfLogNormDist=[totalSetOfLogNormDist,logNormDist];
       end
       
       listNDotsAnalized=unique([listNDotsAnalized,size(distanceMatrix,1)]);
       
   end
   
   %represent all ramdon normalizations together
    h=figure('Visible','off');
    hold on
    histogram(totalSetOfLogNormDist,40,'BinLimits',[-4,4],'Normalization','probability')
    title([titles{n} ' months random minimum edges distribution'])
    ylabel('frequency')
    xlabel('minimum normalized edges - equidistance (log)')
    saveas(h,[toSavePath '\' titles{n} ' months random minimum edges distribution 0.25 precision.jpg'])
   
    
end