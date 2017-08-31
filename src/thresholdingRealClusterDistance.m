clear all
close all

%Create histogram with all ramdon networks distances for each matched natural image 
addpath('lib')
distMatrix12Path='D:\Pedro\AgingDots\results\distanceMatrix\randomDeletionImages\12 months\12_';
distMatrix18Path='D:\Pedro\AgingDots\results\distanceMatrix\randomDeletionImages\18 months\18_';



for i=1:29 %num of 12 months images
    
    %% RANDOM 
    if i>11
        d1=dir([distMatrix12Path num2str(i+1) '\*mat']);
    else
        d1=dir([distMatrix12Path num2str(i) '\*mat']);
    end
  
    listNEdgesClusterRandom20mc=zeros(length(d1),1);
    listNNodesClusterRandom20mc=zeros(length(d1),1);
    listNEdgesClusterRandom50mc=zeros(length(d1),1);
    listNNodesClusterRandom50mc=zeros(length(d1),1);
    for j=1:length(d1)
        fileName=d1(j).name;
        if i>11
            %load(distanceMatrixPath)
            load([distMatrix12Path num2str(i+1) '\' fileName],'distanceMatrix')
        else
            %load(distanceMatrixPath)
            load([distMatrix12Path num2str(i) '\' fileName],'distanceMatrix')
        end
        
        [ nEdgesClusterRandom20mc, nNodesClusterRandom20mc, nEdgesClusterRandom50mc, nNodesClusterRandom50mc ] = checkClusterDistances( distanceMatrix );
        
        listNEdgesClusterRandom20mc(j)=nEdgesClusterRandom20mc;      
        listNNodesClusterRandom20mc(j)=nNodesClusterRandom20mc;
        
        listNEdgesClusterRandom50mc(j)=nEdgesClusterRandom50mc;
        listNNodesClusterRandom50mc(j)=nNodesClusterRandom50mc;
    end
    
    %mean,standard deviation nodes Random
    meanNNodesClusterRandom20mc=mean(listNNodesClusterRandom20mc);
    stdNNodesClusterRandom20mc=std(listNNodesClusterRandom20mc);
    meanNNodesClusterRandom50mc=mean(listNNodesClusterRandom50mc);
    stdNNodesClusterRandom50mc=std(listNNodesClusterRandom50mc);
    
    %mean,standard deviation edges Random
    meanNEdgesClusterRandom20mc=mean(listNEdgesClusterRandom20mc);
    stdNEdgesClusterRandom20mc=std(listNEdgesClusterRandom20mc);
    meanNEdgesClusterRandom50mc=mean(listNEdgesClusterRandom50mc);
    stdNEdgesClusterRandom50mc=std(listNEdgesClusterRandom50mc);

    %% RAW 
    %Same operation including real image histogram
    if i>11
        load(['D:\Pedro\AgingDots\results\distanceMatrix\rawImages\12-' num2str(i+1) '.mat'],'distanceMatrix')
    else
        load(['D:\Pedro\AgingDots\results\distanceMatrix\rawImages\12-' num2str(i) '.mat'],'distanceMatrix')
    end
    
    [ nEdgesClusterRandom20mc, nNodesClusterRandom20mc, nEdgesClusterRandom50mc, nNodesClusterRandom50mc ] = checkClusterDistances( distanceMatrix );
    
    path=['D:\Pedro\AgingDots\results\clusterDistance\12 months\' num2str(size(distanceMatrix,1)) '-dots'];
    if isdir(path)==0
           mkdir(path); 
    end
        
    save([path '\12-' num2str(i)],'meanNNodesClusterRandom20mc','stdNNodesClusterRandom20mc','meanNNodesClusterRandom50mc','stdNNodesClusterRandom50mc','meanNEdgesClusterRandom20mc','stdNEdgesClusterRandom20mc','meanNEdgesClusterRandom50mc','stdNEdgesClusterRandom50mc','nEdgesClusterRaw20mc','nNodesClusterRaw20mc','nEdgesClusterRaw50mc','nNodesClusterRaw50mc')
    
end
    


for i=1:30 %num of 18 months images
   
    
    d1=dir([distMatrix18Path num2str(i) '\*mat']);
  
    listNEdgesClusterRandom20mc=zeros(length(d1),1);
    listNNodesClusterRandom20mc=zeros(length(d1),1);
    listNEdgesClusterRandom50mc=zeros(length(d1),1);
    listNNodesClusterRandom50mc=zeros(length(d1),1);
    for j=1:length(d1)
        fileName=d1(j).name;
            
        %load(distanceMatrixPath)
        load([distMatrix18Path num2str(i) '\' fileName],'distanceMatrix')

        [ nEdgesClusterRandom20mc, nNodesClusterRandom20mc, nEdgesClusterRandom50mc, nNodesClusterRandom50mc ] = checkClusterDistances( distanceMatrix );
        
        listNEdgesClusterRandom20mc(j)=nEdgesClusterRandom20mc;      
        listNNodesClusterRandom20mc(j)=nNodesClusterRandom20mc;
        
        listNEdgesClusterRandom50mc(j)=nEdgesClusterRandom50mc;
        listNNodesClusterRandom50mc(j)=nNodesClusterRandom50mc;
    end
    
    %nodes
    meanNNodesClusterRandom20mc=mean(listNNodesClusterRandom20mc);
    stdNNodesClusterRandom20mc=std(listNNodesClusterRandom20mc);
    
    meanNNodesClusterRandom50mc=mean(listNNodesClusterRandom50mc);
    stdNNodesClusterRandom50mc=std(listNNodesClusterRandom50mc);
    
    %edges
    meanNEdgesClusterRandom20mc=mean(listNEdgesClusterRandom20mc);
    stdNEdgesClusterRandom20mc=std(listNEdgesClusterRandom20mc);
    
    meanNEdgesClusterRandom50mc=mean(listNEdgesClusterRandom50mc);
    stdNEdgesClusterRandom50mc=std(listNEdgesClusterRandom50mc);

    %% RAW 
    %Same operation including real image histogram
    load(['D:\Pedro\AgingDots\results\distanceMatrix\rawImages\18-' num2str(i) '.mat'],'distanceMatrix')
    
    [ nEdgesClusterRandom20mc, nNodesClusterRandom20mc, nEdgesClusterRandom50mc, nNodesClusterRandom50mc ] = checkClusterDistances( distanceMatrix )
    
    path=['D:\Pedro\AgingDots\results\clusterDistance\18 months\' num2str(size(distanceMatrix,1)) '-dots'];
    if isdir(path)==0
           mkdir(path); 
    end
        
    save([path '\18-' num2str(i)],'meanNNodesClusterRandom20mc','stdNNodesClusterRandom20mc','meanNNodesClusterRandom50mc','stdNNodesClusterRandom50mc','meanNEdgesClusterRandom20mc','stdNEdgesClusterRandom20mc','meanNEdgesClusterRandom50mc','stdNEdgesClusterRandom50mc','nEdgesClusterRaw20mc','nNodesClusterRaw20mc','nEdgesClusterRaw50mc','nNodesClusterRaw50mc')
    
    
    
end

addpath('lib');
writeClusterDistanceExcel;