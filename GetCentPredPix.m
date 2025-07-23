function [ PixCent_Pred ] = GetCentPredPix( VecCent, BandNum, PatchSize)

% reshaping vector to patch.
PatchCent_Pred = reshape(VecCent, PatchSize,PatchSize,BandNum);

% Averaging the patch.
for i=1:BandNum
    PixCent_Pred(:,:,i) = mean2(PatchCent_Pred(:, :, i));
end

end
