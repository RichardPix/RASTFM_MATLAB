function [ChgPos,AllSimPatches,AllWt] = FindShpChgPatch_1Layer(M0,M1,MaskChg,tH,tW,searchWinH,searchWinW,h,Nsim,blocksizeHighRes)

[H_M0,W_M0] = size(MaskChg);
[RowInd,ColInd] = find(MaskChg);
ChgPos = [RowInd,ColInd];

ChgNum = length(RowInd);
AllWt = zeros(ChgNum,Nsim);
AllSimPatches = zeros(2*ChgNum,Nsim);

[~,~,BandNum] = size(M0);
kernel = ones(blocksizeHighRes,blocksizeHighRes)/(blocksizeHighRes^2);
kernel = repmat(kernel,[1 1 BandNum]);

% Building a searching window around each shape change pixel,
% and obtaining the most Nsim similar patches' position and their weights.
for k = 1:ChgNum
    display(['Processing pixel ',num2str(k),' of the ',num2str(ChgNum), ' pixels in the first layer of shape change prediction']);
    
    % M1 to be predicted
    i = RowInd(k);j = ColInd(k);
    W1 = M1(blocksizeHighRes*(i-1)+1:i*blocksizeHighRes,blocksizeHighRes*(j-1)+1:j*blocksizeHighRes,:);
    
    % Searching similar MODIS patches.
    [SimPatches, SimWt] = FindSimPatch_ShpChg(W1, M0, tH,tW, searchWinH,searchWinW, h, Nsim, kernel, H_M0, W_M0, i, j, blocksizeHighRes);
    
    AllWt(k,:) = SimWt;
    AllSimPatches(2*(k-1)+1,:) = SimPatches(1,:);
    AllSimPatches(2*k,:) = SimPatches(2,:);
end

end
