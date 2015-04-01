function [trainPart, testPart] = weightedPartition(scores, folds)
%WEIGHTEDPARTITION, produces a testing and training partition with an even
%distribution of scores in each

