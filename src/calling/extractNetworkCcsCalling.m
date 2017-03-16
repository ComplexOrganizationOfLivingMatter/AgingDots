
addpath('..')
addpath('..\lib')
addpath('..\lib\Codigo_BCT')
randomDistMatrix=getAllFiles('D:\Pedro\AgingDots\results\distanceMatrix\');

parfor i=1:numel(randomDistMatrix)
    
   distMatrixPath=randomDistMatrix{i}; 
   splitPath=strsplit(distMatrixPath,'\');
   
   if isequaln(splitPath{1,6},'randomDeletionImages')==1
   
       fileName=splitPath{end};
       pathSortingFolder=['D:\Pedro\AgingDots\results\sortingAlgorithm\ramdonDeletionImages\' splitPath{1,7} '\' splitPath{1,8} '\lastIteration\'];
       aux=getAllFiles(pathSortingFolder);
       
       for j=1:numel(aux)
           if isempty(strfind(aux{j},[pathSortingFolder fileName(1:end-4) 'It']))==0
               adjMatrixPath=aux{j};
               extractNetworkCcs(distMatrixPath,adjMatrixPath,'randomDeletionImages');
           end
       end
       
   else
       fileName=splitPath{end};
       fileName=fileName(1:end-4);
       pathSortingFolder='D:\Pedro\AgingDots\results\sortingAlgorithm\rawImages\lastIteration\';
       aux=getAllFiles(pathSortingFolder);
       
       for j=1:numel(aux)
           if isempty(strfind(aux{j},[pathSortingFolder 'sorting_' fileName 'It']))==0
               adjMatrixPath=aux{j};
               extractNetworkCcs(distMatrixPath,adjMatrixPath,'rawImages');
           end
       end
              
   end
       
end

