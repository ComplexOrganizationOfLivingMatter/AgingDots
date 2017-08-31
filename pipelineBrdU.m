function [ ] = pipelineBrdU( )
%PIPELINE Summary of this function goes here
%   Detailed explanation goes here
    addpath(genpath('src'))
    calculateDistanceMatrixNSCsBrdU
    randomPickBrdU
end

