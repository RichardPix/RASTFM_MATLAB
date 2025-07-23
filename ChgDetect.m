function [ MaskChg, MaskUnC ] = ChgDetect( M0, M1, H_M0_Mask, W_M0_Mask, ChgThresh, RspMethod )

[~,~,BandNum] = size(M0);

% Resamping MODIS to the resolution of change mask.
M0 = imresize(M0,[H_M0_Mask W_M0_Mask], RspMethod);
M1 = imresize(M1,[H_M0_Mask W_M0_Mask], RspMethod);
% Reshaping image to vector for PCA.
M0_Vec=reshape(M0, H_M0_Mask*W_M0_Mask, BandNum);
M1_Vec=reshape(M1, H_M0_Mask*W_M0_Mask, BandNum);

% PCA.
[~, SCORE_M0, ~] = pca(zscore(M0_Vec)); 
[~, SCORE_M1, ~] = pca(zscore(M1_Vec));

% Using PC1 for change detection.
PC1_absDifVec = abs(SCORE_M1(:,1) - SCORE_M0(:,1));

% Reshaping to image.
PC1_absDifImg=reshape(PC1_absDifVec, H_M0_Mask, W_M0_Mask, 1);

% min-max normalization.
MinVal = min(min(PC1_absDifImg));
MaxVal = max(max(PC1_absDifImg));
if (MaxVal-MinVal ~= 0)
    PC1_absOfdif_Normalized = (PC1_absDifImg - MinVal) ./ (MaxVal-MinVal);
else
    PC1_absOfdif_Normalized = PC1_absDifImg;
end

MaskChg = PC1_absOfdif_Normalized>ChgThresh;
MaskUnC = 1-MaskChg;

end