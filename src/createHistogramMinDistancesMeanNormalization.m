clear all
close all

%Create histogram with all ramdon networks distances for each matched natural image 
addpath('lib')
distMatrix12Path='D:\Pedro\AgingDots\results\distanceMatrix\randomDeletionImages\12 months\12_';
distMatrix18Path='D:\Pedro\AgingDots\results\distanceMatrix\randomDeletionImages\18 months\18_';


allLogRandomTotal=[];
allRandomTotalListDist=[];
allLogRawTotal=[];
allRawTotalListDist=[];


for i=1:29 %num of 12 months images
    
    %% RANDOM HISTOGRAM.Calculate normalization reference
    if i>11
        d1=dir([distMatrix12Path num2str(i+1) '\*mat']);
    else
        d1=dir([distMatrix12Path num2str(i) '\*mat']);
    end
  
    allEdgesDistance=[];
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

        %get edges distances normalized from length reference
        allEdgesDistance=[allEdgesDistance;edgesDistances];
        
    end
    %Calculate reference from mean distance from all random edges
    lengthReference=mean(mean(allEdgesDistance));
    
    %% loop to calculate the standard deviation
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

        %get distribution for each network to get std later
        [frequencies,~]=histcounts(log(edgesDistances/lengthReference),16,'BinLimits',[-4,4]);
        listDistribution=[listDistribution;frequencies/sum(frequencies)];
    end
    

    allEdgesNormalizedRandom=allEdgesDistance/lengthReference;
    logAllEdgesNormalizedRandom=log(allEdgesNormalizedRandom);
    h=figure('Visible','off');
    hold on
    histogram(logAllEdgesNormalizedRandom,16,'BinLimits',[-4,4],'Normalization','probability')
    
    
    
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

    %calculate n of dots and edges
    nDots=size(distanceMatrix,1);
    
    %get edges distances normalized from length reference
    edgesNormalizedRaw=edgesDistances/lengthReference;

    logEdgesNormalizedRaw=log(edgesNormalizedRaw);
    
    histogram(logEdgesNormalizedRaw,16,'BinLimits',[-4,4],'Normalization','probability','DisplayStyle','stairs')
    
    %Create bar errors
    [y,~]=histcounts(logAllEdgesNormalizedRandom,16,'BinLimits',[-4,4]);
    x=-3.75:0.5:3.75;
    stdeviation=std(listDistribution);
    standarderror=stdeviation./sqrt(y);
    standarderror(isnan(standarderror))=0;
    %errorbar(x,y/sum(y),stdeviation,'k.')
    errorbar(x,y/sum(y),standarderror,'k.')
    
    %% SAVE
    %condition due to not presence of image 12
    if (i>11)
        title(['12 months - Image ' num2str(i+1) ' - ' num2str(nDots) ' stem cells'])
        legend('ramdon','raw')
        ylabel('frequency')
        xlabel('edge distance normalized (log)')

        hold off

        %Save histogram per natural image
        saveas(h,['D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMeanDistanceEdges\standard error\12 months\Individuals\Image' num2str(i+1) '_nDots' num2str(nDots) '.jpg'])
        save(['D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMeanDistanceEdges\standard error\12 months\Individuals\DataHist_Image' num2str(i+1) '.mat'],'allEdgesNormalizedRandom','edgesNormalizedRaw','logEdgesNormalizedRaw','logAllEdgesNormalizedRandom','listDistribution','stdeviation')
    
    else
        title(['12 months - Image ' num2str(i) ' - ' num2str(nDots) ' stem cells'])
        legend('ramdon','raw')
        ylabel('frequency')
        xlabel('edge distance normalized (log)')

        hold off

        %Save histogram per natural image
        saveas(h,['D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMeanDistanceEdges\standard error\12 months\Individuals\Image' num2str(i) '_nDots' num2str(nDots) '.jpg'])
        save(['D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMeanDistanceEdges\standard error\12 months\Individuals\DataHist_Image' num2str(i) '.mat'],'allEdgesNormalizedRandom','edgesNormalizedRaw','logEdgesNormalizedRaw','logAllEdgesNormalizedRandom','listDistribution','stdeviation')
    
    end
    
    close all
    
    
    
    allLogRandomTotal=[allLogRandomTotal;logAllEdgesNormalizedRandom];
    allRandomTotalListDist=[allRandomTotalListDist;listDistribution];
    allLogRawTotal=[allLogRawTotal;logEdgesNormalizedRaw];
    [frequenciesRaw,~]=histcounts(log(edgesDistances/lengthReference),16,'BinLimits',[-4,4]);
    allRawTotalListDist=[allRawTotalListDist;frequenciesRaw/sum(frequenciesRaw)];
    
end

    h=figure('Visible','off');
    hold on
    histogram(allLogRandomTotal,16,'BinLimits',[-4,4],'Normalization','probability')
    histogram(allLogRawTotal,16,'BinLimits',[-4,4],'Normalization','probability','DisplayStyle','stairs')
    
    %Create bar errors
    [y,~]=histcounts(allLogRandomTotal,16,'BinLimits',[-4,4]);
    x=-3.75:0.5:3.75;
    stdeviationRandom=std(allRandomTotalListDist);
    standarderror=stdeviationRandom./sqrt(y);
    standarderror(isnan(standarderror))=0;
    %errorbar(x,y/sum(y),stdeviationRandom,'k.')
    errorbar(x,y/sum(y),standarderror,'k.')
    
    [y,~]=histcounts(allLogRawTotal,16,'BinLimits',[-4,4]);
    x=-3.75:0.5:3.75;
    stdeviationRaw=std(allRawTotalListDist);
    standarderror=stdeviationRaw./sqrt(y);
    standarderror(isnan(standarderror))=0;
    %errorbar(x,y/sum(y),stdeviationRaw,'d','Marker','.','Color',[0.8,0.6,0.2])
    errorbar(x,y/sum(y),standarderror,'d','Marker','.','Color',[0.8,0.6,0.2])

    %Save histogram with all data
    
    title('12 months - all random images Vs all raw images')
    legend('ramdon','raw')
    ylabel('frequency')
    xlabel('edge distance normalized (log)')

    %Save histogram per natural image
    saveas(h,'D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMeanDistanceEdges\standard error\12 months\All random VS all raw images.jpg')
    save('D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMeanDistanceEdges\standard error\12 months\DataHistAllRandVSAllRaw.mat','allLogRandomTotal','allRandomTotalListDist','allLogRawTotal','allRawTotalListDist','stdeviationRandom','stdeviationRaw')

    hold off
    close all
    
    
allLogRandomTotal=[];
allRandomTotalListDist=[];
allLogRawTotal=[];
allRawTotalListDist=[];

for i=1:30 %num of 18 months images
    
    %% RANDOM HISTOGRAM.Calculate normalization reference
    d1=dir([distMatrix18Path num2str(i) '\*mat']);
    
    allEdgesDistance=[];
    for j=1:length(d1)
        fileName=d1(j).name;
        %load(distanceMatrixPath)
        load([distMatrix18Path num2str(i) '\' fileName],'distanceMatrix')     
        
        %get graph min span tree
        [treeGraph,~]=graphminspantree(sparse(distanceMatrix));
        treeGraph=full(treeGraph);
        edgesDistances=treeGraph(treeGraph~=0);

        %get edges distances normalized from length reference
        allEdgesDistance=[allEdgesDistance;edgesDistances];
        
    end
    %Calculate reference from mean distance from all random edges
    lengthReference=mean(mean(allEdgesDistance));
    
    %% loop to calculate the standard deviation
    listDistribution=[];
    for j=1:length(d1)
        fileName=d1(j).name;
        %load(distanceMatrixPath)
        load([distMatrix18Path num2str(i) '\' fileName],'distanceMatrix')      
        
        %get graph min span tree
        [treeGraph,~]=graphminspantree(sparse(distanceMatrix));
        treeGraph=full(treeGraph);
        edgesDistances=treeGraph(treeGraph~=0);

        %get distribution for each network to get std later
        [frequencies,~]=histcounts(log(edgesDistances/lengthReference),16,'BinLimits',[-4,4]);
        listDistribution=[listDistribution;frequencies/sum(frequencies)];
    end
    

    allEdgesNormalizedRandom=allEdgesDistance/lengthReference;
    logAllEdgesNormalizedRandom=log(allEdgesNormalizedRandom);
    h=figure('Visible','off');
    hold on

    histogram(logAllEdgesNormalizedRandom,16,'BinLimits',[-4,4],'Normalization','probability')
    
    
    
    
    %% RAW HISTOGRAM
    %Same operation including real image histogram
    load(['D:\Pedro\AgingDots\results\distanceMatrix\rawImages\18-' num2str(i) '.mat'],'distanceMatrix')
        
    %get graph min span tree
    [treeGraph,~]=graphminspantree(sparse(distanceMatrix));
    treeGraph=full(treeGraph);

    edgesDistances=treeGraph(treeGraph~=0);

    %calculate n of dots and edges
    nDots=size(distanceMatrix,1);
    
    %get edges distances normalized from length reference
    edgesNormalizedRaw=edgesDistances/lengthReference;

    logEdgesNormalizedRaw=log(edgesNormalizedRaw);
    
    histogram(logEdgesNormalizedRaw,16,'BinLimits',[-4,4],'Normalization','probability','DisplayStyle','stairs')
    
    %Create bar errors
    [y,~]=histcounts(logAllEdgesNormalizedRandom,16,'BinLimits',[-4,4]);
    x=-3.75:0.5:3.75;
    stdeviation=std(listDistribution);
    standarderror=stdeviation./sqrt(y);
    standarderror(isnan(standarderror))=0;
    %errorbar(x,y/sum(y),stdeviation,'k.')
    errorbar(x,y/sum(y),standarderror,'k.')


    %% SAVE
    title(['18 months - Image ' num2str(i) ' - ' num2str(nDots) ' stem cells'])
    legend('ramdon','raw')
    ylabel('frequency')
    xlabel('edge distance normalized (log)')

    hold off

    %Save histogram per natural image
    saveas(h,['D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMeanDistanceEdges\standard error\18 months\Individuals\Image' num2str(i) '_nDots' num2str(nDots) '.jpg'])
    save(['D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMeanDistanceEdges\standard error\18 months\Individuals\DataHist_Image' num2str(i) '.mat'],'allEdgesNormalizedRandom','edgesNormalizedRaw','logEdgesNormalizedRaw','logAllEdgesNormalizedRandom','listDistribution','stdeviation')
    
    close all
    
    allLogRandomTotal=[allLogRandomTotal;logAllEdgesNormalizedRandom];
    allRandomTotalListDist=[allRandomTotalListDist;listDistribution];
    allLogRawTotal=[allLogRawTotal;logEdgesNormalizedRaw];
    [frequenciesRaw,~]=histcounts(log(edgesDistances/lengthReference),16,'BinLimits',[-4,4]);
    allRawTotalListDist=[allRawTotalListDist;frequenciesRaw/sum(frequenciesRaw)];
    
end

    h=figure('Visible','off');
    hold on
    histogram(allLogRandomTotal,16,'BinLimits',[-4,4],'Normalization','probability')
    histogram(allLogRawTotal,16,'BinLimits',[-4,4],'Normalization','probability','DisplayStyle','stairs')
    
    %Create bar errors
    [y,~]=histcounts(allLogRandomTotal,16,'BinLimits',[-4,4]);
    x=-3.75:0.5:3.75;
    stdeviationRandom=std(allRandomTotalListDist);
    standarderror=stdeviationRandom./sqrt(y);
    standarderror(isnan(standarderror))=0;
    %errorbar(x,y/sum(y),stdeviationRandom,'k.')
    errorbar(x,y/sum(y),standarderror,'k.')
    
    [y,~]=histcounts(allLogRawTotal,16,'BinLimits',[-4,4]);
    x=-3.75:0.5:3.75;
    stdeviationRaw=std(allRawTotalListDist);
    standarderror=stdeviationRaw./sqrt(y);
    standarderror(isnan(standarderror))=0;
    %errorbar(x,y/sum(y),stdeviationRaw,'d','Marker','.','Color',[0.8,0.6,0.2])
    errorbar(x,y/sum(y),standarderror,'d','Marker','.','Color',[0.8,0.6,0.2])

    %Save histogram with all data
    
    title('18 months - all random images Vs all raw images')
    legend('ramdon','raw')
    ylabel('frequency')
    xlabel('edge distance normalized (log)')

    %Save histogram per natural image
    saveas(h,'D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMeanDistanceEdges\standard error\18 months\All random VS all raw images.jpg')
    save('D:\Pedro\AgingDots\results\histogramsFigures\edgesDistanceNormalizedMeanDistanceEdges\standard error\18 months\DataHistAllRandVSAllRaw.mat','allLogRandomTotal','allRandomTotalListDist','allLogRawTotal','allRawTotalListDist','stdeviationRandom','stdeviationRaw')

    hold off
    close all

