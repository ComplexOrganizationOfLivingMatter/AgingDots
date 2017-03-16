clear all
close all

%Create histogram with all ramdon networks distances for each matched natural image 
addpath('lib')
distMatrix12Path='D:\Pedro\AgingDots\results\distanceMatrix\randomDeletionImages\12 months\12_';
distMatrix18Path='D:\Pedro\AgingDots\results\distanceMatrix\randomDeletionImages\18 months\18_';


for i=1:29 %num of 12 months images
    
    %% RANDOM HISTOGRAM.Calculate normalization reference
    if i>11
        d1=dir([distMatrix12Path num2str(i+1) '\*mat']);
    else
        d1=dir([distMatrix12Path num2str(i) '\*mat']);
    end
  
    allEdgesNormalizedRandom=[];
    listDistribution=[];
    for j=1:length(d1)
        fileName=d1(j).name;
        if i>11
            %load(distanceMatrixPath)
            load([distMatrix12Path num2str(i+1) '\' fileName],'distanceMatrix')
        else
            %load(distanceMatrixPath)
            load([distMatrix12Path num2str(i) '\' fileName],'distanceMatrix')
        end
        
        %get graph min span tree
        [treeGraph,~]=graphminspantree(sparse(distanceMatrix));
        treeGraph=full(treeGraph);
        edgesDistances=treeGraph(treeGraph~=0);
        
        %this distance will be the reference to normalize all minimum distances
        lengthReference=max(max(distanceMatrix));

        %get edges distances normalized from length reference
        allEdgesNormalizedRandom=[allEdgesNormalizedRandom;edgesDistances/lengthReference];
        
        %get distribution for each network to get std later
        [frequencies,~]=histcounts(edgesDistances/lengthReference,20,'BinLimits',[0,1]);
        listDistribution=[listDistribution;frequencies/sum(frequencies)];
        
    end
        
    h=figure('Visible','off');
    hold on
    histogram(allEdgesNormalizedRandom,20,'BinLimits',[0,0.5],'Normalization','probability')
    
    
    
    %% RAW HISTOGRAM
    %Same operation including real image histogram
    if i>11
        load(['D:\Pedro\AgingDots\results\distanceMatrix\rawImages\12-' num2str(i+1) '.mat'],'distanceMatrix')
    else
        load(['D:\Pedro\AgingDots\results\distanceMatrix\rawImages\12-' num2str(i) '.mat'],'distanceMatrix')
    end
    
        
    %get graph min span tree
    [treeGraph,~]=graphminspantree(sparse(distanceMatrix));
    treeGraph=full(treeGraph);

    edgesDistances=treeGraph(treeGraph~=0);

    %this distance will be the reference to normalize all minimum distances
    lengthReference=max(max(distanceMatrix));
    
    %calculate n of dots and edges
    nDots=size(distanceMatrix,1);
    
    %get edges distances normalized from length reference
    edgesNormalizedRaw=edgesDistances/lengthReference;

    
    histogram(edgesNormalizedRaw,20,'BinLimits',[0,0.5],'Normalization','probability','DisplayStyle','stairs')
    
    %Create bar errors
    [y,~]=histcounts(allEdgesNormalizedRandom,20,'BinLimits',[0,0.5]);
    x=0.0125:0.025:0.4875;
    stdeviation=std(listDistribution);
    errorbar(x,y/sum(y),stdeviation,'k.')
    
    %% SAVE
    %condition due to not presence of image 12
    if (i>11)
        title(['12 months - Image ' num2str(i+1) ' - ' num2str(nDots) ' stem cells'])
        legend('ramdon','raw')
        ylabel('frequency')
        xlabel('edge distance normalized')

        hold off

        %Save histogram per natural image
        saveas(h,['D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMaxDistanceDistMatrix\12 months\Image' num2str(i+1) '_nDots' num2str(nDots) '.jpg'])
        save(['D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMaxDistanceDistMatrix\12 months\DataHist_Image' num2str(i+1) '.mat'],'allEdgesNormalizedRandom','edgesNormalizedRaw','listDistribution','stdeviation')
    
    else
        title(['12 months - Image ' num2str(i) ' - ' num2str(nDots) ' stem cells'])
        legend('ramdon','raw')
        ylabel('frequency')
        xlabel('edge distance normalized')

        hold off

        %Save histogram per natural image
        saveas(h,['D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMaxDistanceDistMatrix\12 months\Image' num2str(i) '_nDots' num2str(nDots) '.jpg'])
        save(['D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMaxDistanceDistMatrix\12 months\DataHist_Image' num2str(i) '.mat'],'allEdgesNormalizedRandom','edgesNormalizedRaw','listDistribution','stdeviation')
    
    end
    
    close all
    
end






for i=1:30 %num of 18 months images
    
     %% RANDOM HISTOGRAM.Calculate normalization reference
    d1=dir([distMatrix18Path num2str(i) '\*mat']);
    
    allEdgesNormalizedRandom=[];
    listDistribution=[];
    for j=1:length(d1)
        fileName=d1(j).name;
        %load(distanceMatrixPath)
        load([distMatrix18Path num2str(i) '\' fileName],'distanceMatrix')
        
        %get graph min span tree
        [treeGraph,~]=graphminspantree(sparse(distanceMatrix));
        treeGraph=full(treeGraph);
        edgesDistances=treeGraph(treeGraph~=0);
        
        %this distance will be the reference to normalize all minimum distances
        lengthReference=max(max(distanceMatrix));

        %get edges distances normalized from length reference
        allEdgesNormalizedRandom=[allEdgesNormalizedRandom;edgesDistances/lengthReference];
        
        %get distribution for each network to get std later
        [frequencies,~]=histcounts(edgesDistances/lengthReference,20,'BinLimits',[0,0.5]);
        listDistribution=[listDistribution;frequencies/sum(frequencies)];
        
    end
        
    h=figure('Visible','off');
    hold on
    histogram(allEdgesNormalizedRandom,20,'BinLimits',[0,0.5],'Normalization','probability')
    
    %% RAW HISTOGRAM
    %Same operation including real image histogram
    load(['D:\Pedro\AgingDots\results\distanceMatrix\rawImages\18-' num2str(i) '.mat'],'distanceMatrix')
        
    %get graph min span tree
    [treeGraph,~]=graphminspantree(sparse(distanceMatrix));
    treeGraph=full(treeGraph);

    edgesDistances=treeGraph(treeGraph~=0);

    %this distance will be the reference to normalize all minimum distances
    lengthReference=max(max(distanceMatrix));
    
    %calculate n of dots and edges
    nDots=size(distanceMatrix,1);
    
    %get edges distances normalized from length reference
    edgesNormalizedRaw=edgesDistances/lengthReference;
    histogram(edgesNormalizedRaw,20,'BinLimits',[0,0.5],'Normalization','probability','DisplayStyle','stairs')
    
    %Create bar errors
    [y,~]=histcounts(allEdgesNormalizedRandom,20,'BinLimits',[0,0.5]);
    x=0.0125:0.025:0.4875;
    stdeviation=std(listDistribution);
    errorbar(x,y/sum(y),stdeviation,'k.')
    
    %% SAVE
    %condition due to not presence of image 18
    title(['18 months - Image ' num2str(i) ' - ' num2str(nDots) ' stem cells'])
    legend('ramdon','raw')
    ylabel('frequency')
    xlabel('edge distance normalized')

    hold off

    %Save histogram per natural image
    saveas(h,['D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMaxDistanceDistMatrix\18 months\Image' num2str(i) '_nDots' num2str(nDots) '.jpg'])
    save(['D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMaxDistanceDistMatrix\18 months\DataHist_Image' num2str(i) '.mat'],'allEdgesNormalizedRandom','edgesNormalizedRaw','listDistribution','stdeviation')

    close all  
end
