function extractNetworkCcs( distMatrixPath,adjMatrixPath,typeFile )

%%For each sorting image we have an adjacency matrix. So, we treat that as
%%network to capture all possible network features.

%%Calculate weight graph from adjacency matrix and distance matrix.
%load adjacencyMatrix
load(adjMatrixPath)
%load distMatrix
load(distMatrixPath)

numStemCells=size(distanceMatrix,1);
weigth_graph=full(logical(adjacencyMatrix)).*distanceMatrix;
[mean_n_connections_per_node, std_n_connections_per_node, mean_strengths,std_strengths, assortativity_cc, density, mean_coef_cluster, std_coef_cluster, transitivity, mean_optime_structure, std_optime_structure,maximated_modularity,lambda,efficiency,mean_eccentricity,std_eccentricity,radius,diameter, mean_BC,std_BC,meanAllShortestPath,stdAllShortestPath]=mainNetworkCcs(weigth_graph,adjacencyMatrix);

    if isempty(strfind(typeFile,'raw'))==0
         pathSplit=strsplit(distMatrixPath,'\');
         folderDir='D:\Pedro\AgingDots\results\featuresExtraction\rawImages';
         save([folderDir '\' pathSplit{end}],'numStemCells','mean_n_connections_per_node', 'std_n_connections_per_node', 'mean_strengths','std_strengths', 'assortativity_cc','density', 'mean_coef_cluster', 'std_coef_cluster', 'transitivity', 'mean_optime_structure', 'std_optime_structure','maximated_modularity','lambda','efficiency','mean_eccentricity','std_eccentricity','radius','diameter', 'mean_BC','std_BC','meanAllShortestPath','stdAllShortestPath');
    else
        pathSplit=strsplit(distMatrixPath,'\');
        folderDir=['D:\Pedro\AgingDots\results\featuresExtraction\randomDeletionImages\' pathSplit{end-2} '\' pathSplit{end-1}];
        if isdir(folderDir)==0
            mkdir(folderDir);
        end
        save([folderDir '\' pathSplit{end}],'numStemCells','mean_n_connections_per_node', 'std_n_connections_per_node', 'mean_strengths','std_strengths', 'assortativity_cc','density', 'mean_coef_cluster', 'std_coef_cluster', 'transitivity', 'mean_optime_structure', 'std_optime_structure','maximated_modularity','lambda','efficiency','mean_eccentricity','std_eccentricity','radius','diameter', 'mean_BC','std_BC','meanAllShortestPath','stdAllShortestPath');
    end
end

