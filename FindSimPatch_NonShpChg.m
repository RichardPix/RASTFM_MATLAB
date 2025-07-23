function [SimPatches] = FindSimPatch_NonShpChg(PatchCent_L0, Win_L0, Nsim, h, t, PatchSize)

[H,W,BandNum]=size(Win_L0);
kernel = ones(PatchSize,PatchSize)/(PatchSize^2);
kernel = repmat(kernel,[1 1 BandNum]);

% Edge expansion.
Win_L0_Ex = EdgeMirror(Win_L0, [t, t]);

W1 = PatchCent_L0;
ind = 1;

WinSize = H*W;
patches = zeros(WinSize,2);
Wt = zeros(WinSize,1);

%% Non-local searching.
% Iterate through the searching window, and calculate the weight of each patch.
for i=t+1:1:H+t 
    for j=t+1:1:W+t 
        W0 = Win_L0_Ex(i-t:i+t,j-t:j+t,:);
        
        difsum = sum(sum(kernel.*(W1-W0).*(W1-W0),1),2);
        normdifsum = sum(difsum(:)./h);
        normdifsum = min(normdifsum,600);
        
        wt = exp(-normdifsum); 
        Wt(ind,:) = wt;
        patches(ind,:) = [i-t, j-t]; % get a similar pixel's coordinates in a non-expanded local window.
        
        ind = ind+1;
    end
end

[~,index] = sort(Wt,1,'descend'); % Sort the weights in descending order.
SimPatches = patches(index(1: Nsim),:); % Obtain the pixel coordinates corresponding to the first Nsim patches.

end
