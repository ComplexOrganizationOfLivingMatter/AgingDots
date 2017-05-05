%Developed by Pedro Gomez-Galvez and Pablo Vicente-Munuera

%createDistanceMatrix();

%Detecting alpha and omega points
centroidFiles = getAllFiles('results\distanceMatrix\');
newPointsFiles = getAllFiles('data\sortedByAnimal\Alpha_punto_omega_cruz_NSCs\');
newPointsFilesOnlyFileName = cellfun(@(x) strsplit(x, '\'), newPointsFiles, 'UniformOutput', false);
newPointsFilesOnlyFileName = cellfun(@(x) x{end}, newPointsFilesOnlyFileName, 'UniformOutput', false);
newPointsFilesOnlyFileName = cellfun(@(x) x(1:end-4), newPointsFilesOnlyFileName, 'UniformOutput', false);
for centroidFile = 1:length(centroidFiles)
    fullPathFile = centroidFiles{centroidFile};
    fileNameSplitted = strsplit(fullPathFile, '\');
    imgName = fileNameSplitted{end};
    imgNameNoExtension = imgName(1:end-4);
    newPointsImageFound = cellfun(@(x) isequal(x, imgNameNoExtension), newPointsFilesOnlyFileName);
    newDataImg = imread(newPointsFiles{newPointsImageFound});
    
end