% Function to calculate relative and absolute causal strengths of two time series
%
% Syntax: causal_matrix =NA_MEMD_Causal_Decomposition(input_data, level_noise, noise_channel_num, en_num)
% Parameters:
% input_data: a matrix of two time series
% level_noise: the level of noise used in noise-assisted multivariate empirical mode decomposition
%         the level_noise value represents the fraction of standard deviation of time series (e.g., 0.1)
% noise_channel_num: the number of noise channel used in 
%         noise-assisted multivariate empirical mode decomposition
% en_num: the number of ensemble to average the results of noise-assisted 
%         multivariate empirical mode decomposition.        
% 
% Output:
% The output of na_memd_causal_decomposition function contains a matrix
% The first variable in the matrix indicates the relative causal strength from first time series 
% to the second time series and vise versa in the second variable. The third 
% variable indicates the absolute causal strength from the first time series 
% to the second time series, and vice versa in the fourth variable. 
%
% Example: 
%
%          load wolves_moose;
%          causal_matrix = na_memd_causal_decomposition(data,0.001,3,5);
%
% Ver 1.0: Guan Wang, Ziwen Li 1/9/2022
%
% Referece:
% Zhang, Y., Yang, Q., Zhang, L., Ran, Y., Wang, G., Celler, B., ... & Yao, D. (2021). 
%     Noise-assisted multivariate empirical mode decomposition based causal decomposition 
%     for brain-physiological network in bivariate and multiscale time series. 
%     Journal of Neural Engineering, 18(4), 046018.

function causal_matrix =na_memd_causal_decomposition(input_data, level_noise, noise_channel_num, en_num)
%% Variable initialization

[len_input,~] = size(input_data);
input_data = zscore(input_data);

%% Step 1 Obtain the IMFS 

% Using function namemd to get IMFs
imfs_result = na_memd(input_data, level_noise, noise_channel_num, en_num);
imfs1 = imfs_result{1,1};
imfs2 = imfs_result{1,2};
[imf_num,~] = size(imfs_result{1,1});

%% Step 2 Redecomposition

% Using function Plseries to find the average frequency and frequency difference of imf1 and imf2
[peakMatrix, ang_1, ang_2] = PLseries(imfs1, imfs2); 

% Using function Plot to output peakMatrix and draw IMFs and phase images
% Using function Pick to take the ICCs set and main ICC
Plot(imf_num,len_input,imfs_result,peakMatrix,ang_1,ang_2);
[ICC,ICC_main] = Pick;

%% Step 3 Instantaneous phase coherence analysis & Caulsality inference

% Calculate the causal strength for statistical inference
causal_matrix= causal_decomposition(ICC, ICC_main, input_data, imfs_result,  level_noise, noise_channel_num, en_num);

end