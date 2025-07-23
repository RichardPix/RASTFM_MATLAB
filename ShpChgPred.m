function [ L1_Pred_NoBlock ] = ShpChgPred( M0, M1, L0, L1_Pred_NonShpChg, ...
    H_M0_TransRes, W_M0_TransRes, MaskChg_TransRes, blocksizeHighRes, blocksizeTransRes, h, Nsim, NsimCoarse, RspMethod )

MaskUnC_TransRes = 1 - MaskChg_TransRes;

L0_TransRes = imresize(L0,[H_M0_TransRes W_M0_TransRes], RspMethod);

% 1st layer prediction.
[Pred_L1_TransRes] = NLLR_SR_1st(M0,M1,L0_TransRes, L1_Pred_NonShpChg, h, MaskChg_TransRes, MaskUnC_TransRes, blocksizeTransRes,Nsim,RspMethod);

% 2nd layer prediction.
[L1_Pred_Block] = NLLR_SR_2nd(L0_TransRes,Pred_L1_TransRes,L0, L1_Pred_NonShpChg, h, MaskChg_TransRes,MaskUnC_TransRes, blocksizeHighRes,Nsim,NsimCoarse,RspMethod);

% Remove block effect.
[L1_Pred_NoBlock] = RemoveBlock( L1_Pred_Block, MaskChg_TransRes, blocksizeHighRes );

end

