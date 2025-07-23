function [RefinedPatches,RefinedWt] = RefineModPatch(W1, M0, SimPatchesCoarse, WtCoarse, NsimCoarse, NsimPrecise, blocksize)
% Using texture features to refine the searched similar patches.

[~,~,BandNum] = size(M0);

wt = zeros(NsimCoarse, 1);
RefinedPatches = zeros(2,NsimPrecise);

W1_Enhance = LinearEnhance( W1, 0, 15 );
f1 = GetTextureVec( W1_Enhance, 16 );

ind = 1;

% Iterate through the similar patches obtained by the initial search, 
% and get the largest NsimPercise weights and the corresponding patch's pixel coordinates.
for n = 1:NsimCoarse    
    i = SimPatchesCoarse(1, n);
    j = SimPatchesCoarse(2, n);
    
    W0 = M0((i-1)*blocksize+1:i*blocksize,(j-1)*blocksize+1:j*blocksize,:);
    W0_Enhance = LinearEnhance( W0, 0, 15 );
    f0 = GetTextureVec( W0_Enhance, 16 );
    
    sumOfCoe = 0;
    for k = 1:BandNum
        coe(2*(k-1)+1:2*k, :) = corrcoef(f1(:,k), f0(:,k));
        sumOfCoe = sumOfCoe + coe(2*k,1);
    end
    wt(ind,:) = sumOfCoe;
    
    ind = ind+1;
end

[~,index] = sort(wt,1,'descend'); % Sort the weights in descending order.
TempWtCoar = WtCoarse(index(1: NsimPrecise)); % Get the weights of the first NsimPrecise patches.
TempSimPatchesCoar = SimPatchesCoarse(:,index(1: NsimPrecise)); % Obtain the pixel coordinates corresponding to the first NsimPrecise patches.

RefinedWt = TempWtCoar';
RefinedPatches(1,:) = TempSimPatchesCoar(1,:);
RefinedPatches(2,:) = TempSimPatchesCoar(2,:);

end
