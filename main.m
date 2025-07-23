%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Source code of the Robust and Adaptive Spatial-Temporal image Fusion Model (RASTFM) 
% 
% Code summary: this code package is for blending coarse-but-frequent (e.g., MODIS) 
% and fine-but-sparse (e.g., Landsat) satellite images to generate fine-and-frequent images.
% 
% Version 1.1: July 22, 2025.
% 
% Reference for the version 1.1 RASTFM code: 
% 1. Yongquan Zhao, Bo Huang, & Huihui Song. (2018). A robust adaptive spatial and temporal image fusion model 
%    for complex land surface changes. Remote Sensing of Environment, 208, 42-62.
% 2. Yongquan Zhao., Desheng Liu., & Xiaofang Wei. (2020). Monitoring cyanobacterial harmful algal blooms 
%    at high spatiotemporal resolution by fusing Landsat and MODIS imagery. Environmental Advances, 2, 100008.
% 
% 
% Input requirements:
% (1) The pixel value range of input surface reflectance images is 0 - 10000.
% (2) The input images should have the same geographic coverage and projection (e.g., UTM). 
% (3) The input images should be geometrically matched. 
% (4) This code package is for spatial-temporal fusion, so the input images should have the same/similar bands.
% (5) To support the spatial-temporal fusion between MODIS and Landsat. The input band names in the parameter "BandName" should be 
%     less than or equal to the Landsat bands, i.e., {'Blue', 'Green', 'Red', 'NIR', 'SWIR1', 'SWIR2'}, to call the function IntraSharpen. 
%     Moreover, The input band names must match the given name strings in "BandName" exactly.

% Copyright (c): Yongquan Zhao, Ningjing Institute of Geography and Limnology, Chinese Academy of Sciences (NIGLAS), yqzhao@niglas.ac.cn.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function main()

% clear;
clc;

%% Inputs.
ImgName_M0 = '.\test_data\MOD09_T1.tif'; % MODIS T1 image.
ImgName_M1 = '.\test_data\MOD09_T2.tif'; % MODIS T2 image.
ImgName_L0 = '.\test_data\LE07_T1.tif'; % Landsat T1 image.

% Band names should match with input images.
% BandName = {'NIR', 'Red', 'Green'};
BandName = {'Blue', 'Green', 'Red', 'NIR', 'SWIR1', 'SWIR2'};

[M0] = single(imread(ImgName_M0));
[M1] = single(imread(ImgName_M1));
[L0] = single(imread(ImgName_L0));

[H_L0, W_L0, BandNum] = size(L0);

% Fused Landsat image at T2.
ImgName_L1_pred = '.\test_result\FusedLandsatImgT2.dat';

%% Parameter setting.
% The spatial resolution gap between MODIS and Landsat.
ResGap = 250/30;

% Change detection threshold for RRN(0.10-0.15), smaller value comes with less non-change set.
ChgThresh = 0.15; 
% Shape change detection threshold(2-6), smaller values come with more shape changes.
ShpChgThresh = 3;

% Moving window size for non-shape change prediction.
SearchWinSize = 11; 

% The size for intermediate-resolution image patch.
blocksizeTransRes = 1;

% The size for high-resolution image patch.
% blocksizeHighRes should satisfy: (blocksizeHighRes<=round(250m/30m) && (H_L0 and W_L0)%blocksizeHighRes==0)
blocksizeHighRes = 4;

% the number of similar patches used for shape change prediction.
Nsim = 5;
NsimCoarse = 8;

% the re-sampling method of input images.
RspMethod = 'bicubic';


%% STIF processing.
fprintf('Fusion start!\n');

[ FusedLandsatImgT1 ] = STIF( M0, M1, L0, BandName, ResGap, ChgThresh, ShpChgThresh, SearchWinSize, blocksizeTransRes, blocksizeHighRes, Nsim, NsimCoarse, RspMethod );

% Write Landsat-like T2 image
enviwrite(FusedLandsatImgT1, H_L0, W_L0, BandNum, '', ImgName_L1_pred);

fprintf('Fusion done!\n');

end
