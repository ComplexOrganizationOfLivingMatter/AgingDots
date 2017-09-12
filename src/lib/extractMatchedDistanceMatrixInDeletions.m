function [] = extractMatchedDistanceMatrixInDeletions( )
    
    %%Get all path to read. All distance matrix from raw images and random
    %%deletion to calculate news sorting graphs
    addpath('lib');   
    dataFiles = getAllFiles('D:\Pedro\AgingDots\results\distanceMatrix\rawImages');
    dataFiles12_18=dataFiles(1:59);
    dataFiles3=dataFiles(60:109);
    
    dataFilesRandomDeletion=getAllFiles('D:\Pedro\AgingDots\results\randomElection');
 
    for i=1:size(dataFiles12_18,1)
        %load number of dots to filter
        load(dataFiles12_18{i},'Centroids');
        pathFile=dataFiles12_18{i};
        pathFile=pathFile(1:end-4);
        numberOfImg=strsplit(pathFile,'-');
        
        numDotsFile=size(Centroids,1);
        for j=1:length(dataFilesRandomDeletion) 
            load(dataFilesRandomDeletion{j},'centroidsRandom');
            %discard operation if number of dots in image 12 or 18 months
            %is higher than randomized 3 months image 
            if numDotsFile <= size(centroidsRandom,1)
                stemCellsChosen=centroidsRandom{numDotsFile};
                splitPath=strsplit(dataFilesRandomDeletion{j},'Image');
                numImg=strsplit(splitPath{end},'_');
                numRandom=strsplit(numImg{2},'.');
                
                %load and adaptation of distance matrix to dots filtered
                load(['D:\Pedro\AgingDots\results\distanceMatrix\rawImages\3-' numImg{1} '.mat'],'distanceMatrix')
                distanceMatrix=distanceMatrix(stemCellsChosen,stemCellsChosen);
                
                %Save filtered matrix per each match of number of dots
                path='D:\Pedro\AgingDots\results\distanceMatrix\randomDeletionImages\';
                if isempty(strfind(dataFiles12_18{i},'\12-'))==0
                    if isdir([path '12 months\12_' numberOfImg{end} '\'])==0
                        mkdir([path '12 months\12_' numberOfImg{end} '\']);
                    end
                    save([path '12 months\12_' numberOfImg{end} '\Image' numImg{1} '-'  numRandom{1} '.mat'],'distanceMatrix')
                else if isempty(strfind(dataFiles12_18{i},'\18-'))==0
                        if isdir([path '18 months\18_' numberOfImg{end} '\'])==0
                            mkdir([path '18 months\18_' numberOfImg{end} '\']);
                        end
                        save([path '18 months\18_' numberOfImg{end} '\Image' numImg{1} '_' numRandom{1} '.mat'],'distanceMatrix')
                    end
                end
            end
        end
    end
    
    
end

