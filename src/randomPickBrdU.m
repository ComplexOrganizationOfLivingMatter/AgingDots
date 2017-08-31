%% Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez

%Random 100 pick of number Of centroids in BrdU from images 3 months
files3Months = getAllFiles(
for indexFile = 1:size(files3Months, 1)
    load(strcat('..\results\sortingAlgorithm\rawImages\lastIteration\', files3Months(indexFile).name));
    adjacencyMatrix(adjacencyMatrix ~= 0) = 1;
    
    for i = 1:100
        idCentroids = (1:size(adjacencyMatrix, 1))';
        numDots=length(idCentroids);
        centroidsRandom=cell(numDots,1);
        while numDots > 0
            centroidToDelete = randi(size(idCentroids, 1), 1);
            centroidsRandom{numDots}=idCentroids;
            idCentroids(centroidToDelete) = [];            
            numDots=numDots-1;
        end
        
        nameFile = strsplit(files3Months(indexFile).name(11:end), 'It');
        save(strcat('..\results\randomElection\Image', nameFile{1}, '_Random' ,num2str(i)), 'centroidsRandom');
        
    end
   
end
