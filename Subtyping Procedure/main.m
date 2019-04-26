clc;clear;close all

addpath(genpath('../PPMI code/Subtyping Procedure'))

loaddata;
data_completion;
gendata_multilabel;

% final_0_linear_model;pause(5)
final_1_LSTM ;pause(5)%Note that this file will save new model into model_PPMI_hSize_32.mat
final_2_clustering;pause(5) %Note that currently this file load the model in model_PPMI_hSize_32_NEW4.mat. You should change it to 'model_PPMI_hSize_32.mat' if you want to use your new model.
final_3_hptest;pause(5)
final_4_numbers_all3;pause(5)
