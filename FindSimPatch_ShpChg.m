function [ SimPatches, SimWt ] = FindSimPatch_ShpChg(W1, IM_M0, tH, tW, searchWinH,searchWinW, h, Nsim, kernel, H_Mask, W_Mask, RowInd, ColInd, blocksizeHighRes)

% Set the range of the searching window to ensure it locates within the image
% and has the fixed size of searchWinH*searchWinW.
winRowStart = RowInd - tH;
winRowEnd = RowInd + tH;
winColStart = ColInd - tW;
winColEnd = ColInd + tW;
if(winRowStart < 1) % If the 1st row of the searching window exceeds the 1st row of the image.
    winRowStart = 1;
    winRowEnd = winRowStart + searchWinH - 1;
end
if(winRowEnd > H_Mask) % If the last row of the searching window exceeds the last row of the image.
    winRowEnd = H_Mask;
    winRowStart = winRowEnd - searchWinH + 1;
end
if(winColStart < 1) % If the 1st column of the searching window exceeds the 1st column of the image.
    winColStart = 1;
    winColEnd = winColStart + searchWinW - 1;
end
if(winColEnd > W_Mask) % If the last column of the searching window exceeds the last column of the image.
    winColEnd = W_Mask;
    winColStart = winColEnd - searchWinW+ 1;
end

matchNumH = (winRowEnd-winRowStart+1) - blocksizeHighRes + 1;
matchNumW = (winColEnd-winColStart+1) - blocksizeHighRes + 1;
% patch position and similar weight.
patches = zeros(matchNumH*matchNumW, 2);
Wt = zeros(matchNumH*matchNumW, 1);

ind = 1;

% Iterate through the searching window, and calculate the weight of each patch.
for i=winRowStart:1:winRowEnd 
    for j=winColStart:1:winColEnd
        W0 = IM_M0(blocksizeHighRes*(i-1)+1:i*blocksizeHighRes,blocksizeHighRes*(j-1)+1:j*blocksizeHighRes,:);
          
        difsum = sum(sum(kernel.*(W1-W0).*(W1-W0),1),2);
        normdifsum = sum(difsum(:)./h);
        normdifsum = min(normdifsum,600);
        
        wt = exp(-normdifsum);
        Wt(ind,:) = wt;
        patches(ind,:) = [i, j];   
        
        ind = ind+1;
    end
end

[~,index] = sort(Wt,1,'descend'); % Sort the weights in descending order.
TempWt = Wt(index(1: Nsim)); % Get the weights of the first Nsim patches.
TempPatches = patches(index(1: Nsim),:); % Obtain the pixel coordinates corresponding to the first Nsim patches.

SimWt(1,:) = TempWt';
SimPatches(1,:) = TempPatches(:,1)';
SimPatches(2,:) = TempPatches(:,2)';

end

