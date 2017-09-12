function saveHistogramEdgesNormalized( totalSetOfLogNormDist,name2saveHist,titleHist )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    h=figure('Visible','off');
    histogram(totalSetOfLogNormDist,40,'BinLimits',[-4,4],'Normalization','probability')
    title([titleHist ' minimum edges distribution'])
    ylim([0 0.25])
    ylabel('frequency')
    xlabel('minimum normalized edges - equidistance (log)')
    saveas(h,[name2saveHist ' minimum edges distribution 0.25 precision.jpg'])


end

