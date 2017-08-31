%% Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez

%Random 100 pick of number Of centroids in BrdU from images 3 months
files3Months = getAllFiles('..\results\distanceMatrix\rawImages');
files3MonthsBrdU = getAllFiles('..\resultsByAnimal\NSCs BrdU\distanceMatrix\3m');
for indexFile = 1:size(files3Months, 1)
    fullPathFile = files3Months{indexFile};
    load(fullPathFile);
    fileNameSplitted = strsplit(fullPathFile, '\');
    imgName = fileNameSplitted{end};
    
    brdUPointsFile = cellfun(@(x) isempty(strfind(x, imgName)) == 0, files3MonthsBrdU);
    
    if any(brdUPointsFile)
        brdUPointsFile = files3MonthsBrdU{brdUPointsFile};
        brdUPointsInfo = importdata(brdUPointsFile);
        for i = 1:100
            idCentroids = (1:size(Centroids, 1))';
            numDots = 1;
            indicesCentroidsRandom=cell(size(brdUPointsInfo.centroidsBrdUWithCorners, 1),1);
            while numDots <= size(brdUPointsInfo.centroidsBrdUWithCorners, 1)
                centroidToDelete = randi(size(idCentroids, 1), 1);
                if numDots > 1
                    indicesCentroidsRandom{numDots} = horzcat(idCentroids(centroidToDelete), indicesCentroidsRandom{numDots-1});
                else
                    indicesCentroidsRandom{numDots} = idCentroids(centroidToDelete);
                end
                idCentroids(centroidToDelete) = [];
                numDots=numDots + 1;
            end
            
            centroidsRandom = cellfun(@(x) Centroids(x, :), indicesCentroidsRandom, 'UniformOutput', false);
            brdUPointsFileSplitted = strsplit(brdUPointsFile, '\');
            
            outputDir = strcat('..\resultsByAnimal\NSCs BrdU\randomElection\', brdUPointsFileSplitted{end-1});
            if ~isdir(outputDir)
                mkdir(outputDir);
            end
            
            save(strcat(outputDir, '\', imgName(1:end-4), '_Random' ,num2str(i)), 'indicesCentroidsRandom', 'centroidsRandom');

        end
    end
   
end
