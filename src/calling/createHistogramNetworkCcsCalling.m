addpath('..')
addpath('..\lib')

%% Matrixes ccs calculation
%Calculate matrix all 12 months random ccs
% allRandom12MonthsCcsPath=getAllFiles('D:\Pedro\AgingDots\results\featuresExtraction\randomDeletionImages\12 months');
% MatrixAll12RandomCcs=[];
% for i=1:length(allRandom12MonthsCcsPath)
%     ccs=load(allRandom12MonthsCcsPath{i});
%     MatrixAll12RandomCcs=[MatrixAll12RandomCcs;struct2array(ccs)];
% end
% 
% %Calculate matrix all 12 months raw ccs
% allRaw12MonthsFiles=dir('D:\Pedro\AgingDots\results\featuresExtraction\rawImages\12-*');
% MatrixAll12RawCcs=[];
% for i=1:length(allRaw12MonthsFiles)
% 
%     fileRaw12MonthPath=['D:\Pedro\AgingDots\results\featuresExtraction\rawImages\' allRaw12MonthsFiles(i).name];
%     ccs=load(fileRaw12MonthPath);
%     MatrixAll12RawCcs=[MatrixAll12RawCcs;struct2array(ccs)];
% end
% save('D:\Pedro\AgingDots\results\histogramsFigures\networkFeatures\12MonthsCCs.mat','MatrixAll12RandomCcs','MatrixAll12RawCcs')

load('D:\Pedro\AgingDots\results\histogramsFigures\networkFeatures\12MonthsCCs.mat')

createHistogramFeaturesNetwork(MatrixAll12RawCcs,MatrixAll12RandomCcs,'12 months\all12\')


%% Group features by number of stem cells and months
%% 12 months
for i=1:max(MatrixAll12RandomCcs(:,1))
    
    if sum(MatrixAll12RandomCcs(:,1)==i)>0
        indexesRaw=MatrixAll12RawCcs(:,1)==i;
        rawMatrix=MatrixAll12RawCcs(indexesRaw,:);
        indexesRand=MatrixAll12RandomCcs(:,1)==i;
        randomMatrix=MatrixAll12RandomCcs(indexesRand,:);
        createHistogramFeaturesNetwork(rawMatrix,randomMatrix,['12 months\' num2str(i)  '\'])
    end
    
end


% %Calculate matrix all 18 months random ccs
% allRandom18MonthsCcsPath=getAllFiles('D:\Pedro\AgingDots\results\featuresExtraction\randomDeletionImages\18 months');
% MatrixAll18RandomCcs=[];
% for i=1:length(allRandom18MonthsCcsPath)
%     ccs=load(allRandom18MonthsCcsPath{i});
%     MatrixAll18RandomCcs=[MatrixAll18RandomCcs;struct2array(ccs)];
% end
% 
% %Calculate matrix all 18 months raw ccs
% allRaw18MonthsFiles=dir('D:\Pedro\AgingDots\results\featuresExtraction\rawImages\18-*');
% MatrixAll18RawCcs=[];
% for i=1:length(allRaw18MonthsFiles)
% 
%     fileRaw18MonthPath=['D:\Pedro\AgingDots\results\featuresExtraction\rawImages\' allRaw18MonthsFiles(i).name];
%     ccs=load(fileRaw18MonthPath);
%     MatrixAll18RawCcs=[MatrixAll18RawCcs;struct2array(ccs)];
% end
% save('D:\Pedro\AgingDots\results\histogramsFigures\networkFeatures\18MonthsCCs.mat','MatrixAll18RandomCcs','MatrixAll18RawCcs')

load('D:\Pedro\AgingDots\results\networkFeatures\histogramsFigures\18MonthsCCs.mat','MatrixAll18RandomCcs','MatrixAll18RawCcs')


%% Calling function
createHistogramFeaturesNetwork(MatrixAll18RawCcs,MatrixAll18RandomCcs,'18 months\all18\')

%% Group features by number of stem cells and months
%% 18 months
for i=1:max(MatrixAll18RandomCcs(:,1))
    
    if sum(MatrixAll18RandomCcs(:,1)==i)>0
        indexesRaw=MatrixAll18RawCcs(:,1)==i;
        rawMatrix=MatrixAll18RawCcs(indexesRaw,:);
        indexesRand=MatrixAll18RandomCcs(:,1)==i;
        randomMatrix=MatrixAll18RandomCcs(indexesRand,:);
        createHistogramFeaturesNetwork(rawMatrix,randomMatrix,['18 months\' num2str(i)  '\'])
    end
    
end