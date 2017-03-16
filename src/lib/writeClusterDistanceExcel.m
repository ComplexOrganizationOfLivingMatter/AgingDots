%writeClusterDistanceExcel

path12Month='D:\Pedro\AgingDots\results\clusterDistance\12 months';
path18Month='D:\Pedro\AgingDots\results\clusterDistance\18 months';
listDots12=dir([path12Month '\*-dots']);
listDots18=dir([path18Month '\*-dots']);

acum=5;
xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], {'12 Months'}, 1, 'B4');
for i=1:size(listDots12,1)
    nDots=listDots12(i).name;
    xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], {[nDots(1:2) ' stem cells']}, 1, ['C' num2str(i+acum)]);
    
    listNetworkPerDot=dir([path12Month '\' nDots '\*mat']);
    
    for j=1:size(listNetworkPerDot,1)
        labelNet=listNetworkPerDot(j).name;
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], {['folder ' labelNet(1:end-4)]}, 1, ['D' num2str(i+j+acum)]);
        load([path12Month '\' nDots '\' labelNet],'nNodesClusterRaw20mc','meanNNodesClusterRandom20mc','nNodesClusterRaw50mc','meanNNodesClusterRandom50mc','nEdgesClusterRaw20mc','meanNEdgesClusterRandom20mc','nEdgesClusterRaw50mc','meanNEdgesClusterRandom50mc','stdNNodesClusterRandom20mc','stdNNodesClusterRandom50mc','stdNEdgesClusterRandom20mc','stdNEdgesClusterRandom50mc');
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], nNodesClusterRaw20mc, 1, ['E' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], meanNNodesClusterRandom20mc, 1, ['F' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], nNodesClusterRaw50mc, 1, ['G' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], meanNNodesClusterRandom50mc, 1, ['H' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], nEdgesClusterRaw20mc, 1, ['I' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], meanNEdgesClusterRandom20mc, 1, ['J' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], nEdgesClusterRaw50mc, 1, ['K' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], meanNEdgesClusterRandom50mc, 1, ['L' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], stdNNodesClusterRandom20mc, 1, ['M' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], stdNNodesClusterRandom50mc, 1, ['N' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], stdNEdgesClusterRandom20mc, 1, ['O' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], stdNEdgesClusterRandom50mc, 1, ['P' num2str(i+j+acum)]);
        
    end
    acum=acum+j;
end

acum=53;
xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], {'18 Months'}, 1, 'B52');
for i=1:size(listDots18,1)
    nDots=listDots18(i).name;
    xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], {[nDots(1:2) ' stem cells']}, 1, ['C' num2str(i+acum)]);
    
    listNetworkPerDot=dir([path18Month '\' nDots '\*mat']);
    
    for j=1:size(listNetworkPerDot,1)
        labelNet=listNetworkPerDot(j).name;
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], {['folder ' labelNet(1:end-4)]}, 1, ['D' num2str(i+j+acum)]);
        load([path18Month '\' nDots '\' labelNet],'nNodesClusterRaw20mc','meanNNodesClusterRandom20mc','nNodesClusterRaw50mc','meanNNodesClusterRandom50mc','nEdgesClusterRaw20mc','meanNEdgesClusterRandom20mc','nEdgesClusterRaw50mc','meanNEdgesClusterRandom50mc','stdNNodesClusterRandom20mc','stdNNodesClusterRandom50mc','stdNEdgesClusterRandom20mc','stdNEdgesClusterRandom50mc');
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], nNodesClusterRaw20mc, 1, ['E' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], meanNNodesClusterRandom20mc, 1, ['F' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], nNodesClusterRaw50mc, 1, ['G' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], meanNNodesClusterRandom50mc, 1, ['H' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], nEdgesClusterRaw20mc, 1, ['I' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], meanNEdgesClusterRandom20mc, 1, ['J' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], nEdgesClusterRaw50mc, 1, ['K' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], meanNEdgesClusterRandom50mc, 1, ['L' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], stdNNodesClusterRandom20mc, 1, ['M' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], stdNNodesClusterRandom50mc, 1, ['N' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], stdNEdgesClusterRandom20mc, 1, ['O' num2str(i+j+acum)]);
        xlswrite(['D:\Pedro\AgingDots\results\clusterDistance\clusterDistance_' date], stdNEdgesClusterRandom50mc, 1, ['P' num2str(i+j+acum)]);
        
    end
    acum=acum+j;
end


