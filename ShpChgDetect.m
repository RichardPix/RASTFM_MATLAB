function [ MaskShpChg ] = ShpChgDetect( Img_Pred, Img_Ref, k, H_M0_Mask, W_M0_Mask, RspMethod )

[~, ~, BandNum] = size(Img_Pred);

% Resamping image to the intermediate resolution (resolution of shape change mask).
Img_Pred = imresize(Img_Pred,[H_M0_Mask W_M0_Mask], RspMethod);
Img_Ref = imresize(Img_Ref,[H_M0_Mask W_M0_Mask], RspMethod);
% Reshaping image to vector for PCA.
Img_Pred_Vec=reshape(Img_Pred, H_M0_Mask*W_M0_Mask, BandNum);
Img_Ref_Vec=reshape(Img_Ref, H_M0_Mask*W_M0_Mask, BandNum);

% PCA change detection.
[~, SCORE_Pred, ~] = pca(zscore(Img_Pred_Vec)); 
[~, SCORE_Ref, ~] = pca(zscore(Img_Ref_Vec)); 

% Using PC1 for change detection.
PC1_dif_Vec = SCORE_Pred(:,1) - SCORE_Ref(:,1);
PC1_dif_zscore_Vec = zscore(PC1_dif_Vec);

% Reshaping to image.
PC1_dif_zscore=reshape(PC1_dif_zscore_Vec, H_M0_Mask, W_M0_Mask, 1);

% mean +- k*std for normal distribution.
MaskShpChg = (PC1_dif_zscore>k) | (PC1_dif_zscore<-k);

end

