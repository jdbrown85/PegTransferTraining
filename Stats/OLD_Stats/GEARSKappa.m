clc; clear all;
Ratings = csvread('STB_GEARS_Ratings_T2.csv',2,2)';

Ratings(1:6:60,:)=[];
Gears1 = Ratings(1:5:end,:);
Gears2 = Ratings(2:5:end,:)