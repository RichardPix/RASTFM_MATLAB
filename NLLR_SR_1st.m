function [L1_Pred] = NLLR_SR_1st(M0,M1,L0,L1_Pred_NonShpChg, h, MaskChg,MaskUnChg, blocksizeTransRes, Nsim,RspMethod)

[ L0, blocksizeTransRes ] = HrImgResize( L0, blocksizeTransRes );

% get the size of input high-resolution (i.e., intermediate-resolution) images.
[H_L0,W_L0,BandNum] = size(L0);

% get the size of shape change mask.
H_M0_Mask = H_L0/blocksizeTransRes;
W_M0_Mask = W_L0/blocksizeTransRes;

% 2*t+1 equals to the size of searching window.
tH = (H_M0_Mask-1)/2;
tW = (W_M0_Mask-1)/2;
[H_M0,W_M0,~] = size(M0);
searchWinH = 2*tH+1;
searchWinW = 2*tW+1;
if (searchWinH > H_M0) % If searching window row number > image row number.
    searchWinH = H_M0_Mask;
end
if (searchWinW > W_M0) % If searching window column number > image column number.
    searchWinW = W_M0_Mask;
end

M0_Rsp = imresize(M0,[H_L0 W_L0],RspMethod);
M1_Rsp = imresize(M1,[H_L0 W_L0],RspMethod);

% Convert RGB color values to NTSC color space.
if (BandNum == 3)
    M0_YIQ = rgb2ntsc(M0_Rsp);
    M1_YIQ = rgb2ntsc(M1_Rsp);
    FM0 = M0_YIQ;
    FM1 = M1_YIQ;
else
    FM0 = M0_Rsp;
    FM1 = M1_Rsp;
end

% Up-sampling shape change mask to intermediate-resolution. 
MaskUnC_TransRes = imresize(MaskUnChg,[H_L0 W_L0],'nearest');
% Down-sampling non-shape change prediction image to intermediate-resolution.
L1_Pred_NonShpChg_Trans = imresize(L1_Pred_NonShpChg,[H_L0 W_L0],RspMethod); 
L1_Pred_UnC = L1_Pred_NonShpChg_Trans .* repmat(MaskUnC_TransRes,[1,1,BandNum]);

% NL searching.
[ChgPos,AllSimPatches,AllWt] = FindShpChgPatch_1Layer(FM0,FM1,MaskChg,tH,tW,searchWinH,searchWinW,h,Nsim,blocksizeTransRes);

% Using difference image for reconstruction.
L0 = L0 - M0_Rsp; 

% LLE based reconstruction.
L1_Pred = ReconByLLE( FM0, FM1, L0, AllSimPatches, AllWt, Nsim, ChgPos,L1_Pred_UnC, blocksizeTransRes );

% Add M1.
L1_Pred_ShpChg = (L1_Pred + M1_Rsp) .* repmat((1-MaskUnC_TransRes),[1,1,BandNum]);
L1_Pred = L1_Pred_ShpChg + L1_Pred_UnC;

end

