function createHistogramFeaturesNetwork(raw_ccs,random_ccs,folderToSave)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

ccsLabel={'numStemCells','mean n connections per node', 'std n connections per node', 'mean strengths','std strengths', 'assortativity','density', 'mean coef cluster', 'std coef cluster', 'transitivity', 'mean optime structure', 'std optime structure','maximated modularity','lambda','efficiency','mean eccentricity','std eccentricity','radius','diameter', 'mean BC','std BC','meanAllShortestPath','stdAllShortestPath'};


    for i=2:size(raw_ccs,2)
       
        f=figure('Visible','off');
        hist(random_ccs(:,i));
        hold on
        for j=1:size(raw_ccs,1)
            plot(raw_ccs(j,i),1,'.r','MarkerSize',20)
            
        end
        hold off
        splitFolderToSave=strsplit(folderToSave,'\');
        title([splitFolderToSave{1} ' - ' splitFolderToSave{2} ' - ' ccsLabel{i}])
        xlabel(ccsLabel{i})
        ylabel('frequency')
        
        pathHistogram='D:\Pedro\AgingDots\results\histogramsFigures\networkFeatures\';
        if isdir([pathHistogram folderToSave])==0
           mkdir([pathHistogram folderToSave]); 
        end
        saveas(f,[pathHistogram folderToSave ccsLabel{i} '.jpg'])
        
        
        close all
    end


end

