function [ L1_Pred_AllChg, L0_Pred_AllChg ] = ChgPred( RealM0, SM0, M1, L0, ShpChgThresh, SearchWinSize, blocksizeHighRes, blocksizeTransRes, Nsim, NsimCoarse, RspMethod )

[H_L0, W_L0, BandNum] = size(L0);
[H_M0, W_M0, ~] = size(M1);

%% Non-shp change prediction.
% adaptive h for NL searching.
for i=1:BandNum
    h(i) = std2(M1(:,:,i) - SM0(:,:,i))^2;
end
[ L1_Pred_NonShpChg, L0_Pred_NonShpChg ] = NonShpChgPred( RealM0, SM0, M1, L0, h', SearchWinSize, RspMethod );

%% Shp chg detection.
% Image size of intermediate-resolution images (result of 1st layer).
H_M0_TransRes = H_L0/blocksizeHighRes;
W_M0_TransRes = W_L0/blocksizeHighRes;

% shp chg mask size.
H_M0_Mask = H_M0_TransRes/blocksizeTransRes;
W_M0_Mask = W_M0_TransRes/blocksizeTransRes;

M1_Pred_NonShpChg = imresize(L1_Pred_NonShpChg,[H_M0 W_M0], 'bilinear');

% Using M1 as the reference for shape change dectecion.
[ MaskShpChg_TransRes ] = ShpChgDetect( M1_Pred_NonShpChg, M1, ShpChgThresh, H_M0_Mask, W_M0_Mask, RspMethod );


%% shp chg prediction.
% adaptive h for NL searching.
M1_Rsp = imresize(M1,[H_M0_Mask W_M0_Mask],RspMethod);
M0_Rsp = imresize(SM0,[H_M0_Mask W_M0_Mask],RspMethod);
Chg1 = M1_Rsp .* repmat(MaskShpChg_TransRes,[1,1,BandNum]);
Chg0 = M0_Rsp .* repmat(MaskShpChg_TransRes,[1,1,BandNum]);
for i=1:BandNum
    [~,~,v1] = find(Chg1(:,:,i));
    [~,~,v0] = find(Chg0(:,:,i));
    h(i) = var(v1-v0);
end

% Prediction at T0.
[ L1_Pred_AllChg ] = ShpChgPred( SM0, M1, L0, L1_Pred_NonShpChg, ...
    H_M0_TransRes, W_M0_TransRes, MaskShpChg_TransRes, blocksizeHighRes, blocksizeTransRes, h', Nsim, NsimCoarse, RspMethod );

% Prediction at T1.
[ L0_Pred_AllChg ] = ShpChgPred( SM0, RealM0, L0, L0_Pred_NonShpChg, ...
    H_M0_TransRes, W_M0_TransRes, MaskShpChg_TransRes, blocksizeHighRes, blocksizeTransRes, h', Nsim, NsimCoarse, RspMethod );


end