function [ L1_Pred_Final ] = STIF( M0, M1, L0, BandName, ResGap, ChgThresh, ShpChgThresh, SearchWinSize, blocksizeTransRes, blocksizeHighRes, Nsim, NsimCoarse, RspMethod )

[H_L0, W_L0, ~] = size(L0);
[H_M0, W_M0, BandNum] = size(M0);

%% Adujsting MODIS images to their actual image sizes.
if (H_L0 == H_M0 && W_L0 == W_M0)
    H_M0 = uint16(H_L0/ResGap);
    W_M0 = uint16(W_L0/ResGap);    
    M0 = imresize(M0, [H_M0 W_M0], RspMethod);
    M1 = imresize(M1, [H_M0 W_M0], RspMethod);
end

%% Intra-bands sharpening (for MODIS, optional).
[ M0_Sharp, M1_Sharp ] = IntraSharpen( M0, M1, BandName, RspMethod );

M0 = M0_Sharp;
M1 = M1_Sharp;

%% Relative radiometric normalization for MODIS T2 (Use T1 as reference).
[ M1_Norm, MaskUnC, RrnCoef]  = RelRadNorm( M0, M1, ChgThresh, RspMethod );

%% Downsampling Landsat T1.
SM0 = imresize(L0,[H_M0 W_M0], RspMethod);

%% BP (for MODIS, optional).
[ M1_BP ] = BP( SM0, M1_Norm, L0, ResGap );
[ M0_BP ] = BP( SM0, M0, L0, ResGap );

%% Predicting Landsat images on T1 and T2.
[ L1_Pred, L0_Pred ] = ChgPred( M0_BP, SM0, M1_BP, L0, ShpChgThresh, SearchWinSize, blocksizeHighRes, blocksizeTransRes, Nsim, NsimCoarse, RspMethod );

%% High-pass modulation
[ L1_Pred_Modual ] = HPM( L1_Pred, L0_Pred, M1_Norm, M0, L0, MaskUnC);

%% Radiometric de-normalization.
for i = 1:BandNum
    L1_Pred_Final(:,:,i) = L1_Pred_Modual(:,:,i)*RrnCoef(i,1)+RrnCoef(i,2);    
end

end