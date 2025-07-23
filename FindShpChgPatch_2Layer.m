function [ChgPos,AllSimPatchesPrecise,AllWtPrecise] = FindShpChgPatch_2Layer(M0,M1,MaskChg,tH,tW,searchWinH,searchWinW,h,NsimPrecise,NsimCoarse,blocksizeHighRes)

[H_M0,W_M0] = size(MaskChg);
[RowInd,ColInd] = find(MaskChg);
ChgPos = [RowInd,ColInd];

ChgNum = length(RowInd);
AllWtPrecise = zeros(ChgNum,NsimPrecise);
AllSimPatchesPrecise = zeros(2*ChgNum,NsimPrecise);

[~,~,BandNum] = size(M0);
kernel = ones(blocksizeHighRes,blocksizeHighRes)/(blocksizeHighRes^2);
kernel = repmat(kernel,[1 1 BandNum]);

% Building a searching window around each shape change pixel,
% and obtaining the most Nsim similar patches' position and their weights.
for k = 1:ChgNum
    display(['Processing pixel ',num2str(k),' of the ',num2str(ChgNum), ' pixels in the second layer of shape change prediction']);
    
    % M1 to be predicted
    i = RowInd(k);j = ColInd(k);
    W1 = M1(blocksizeHighRes*(i-1)+1:i*blocksizeHighRes,blocksizeHighRes*(j-1)+1:j*blocksizeHighRes,:);
    
    % Searching similar patches.
    [SimPatchesCoarse, WtCoarse] = FindSimPatch_ShpChg(W1, M0, tH,tW,searchWinH,searchWinW, h, NsimCoarse, kernel, H_M0, W_M0, i, j, blocksizeHighRes);
    
    % Refine the similar patches based on texture features.
    [RefinedPatches,RefinedWt] = RefineModPatch(W1, M0, SimPatchesCoarse, WtCoarse, NsimCoarse, NsimPrecise, blocksizeHighRes);
    
    AllWtPrecise(k,:) = RefinedWt;
    AllSimPatchesPrecise(2*(k-1)+1,:) = RefinedPatches(1,:);
    AllSimPatchesPrecise(2*k,:) = RefinedPatches(2,:);
end

end
