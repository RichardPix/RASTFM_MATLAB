function [ L0, blocksize ] = HrImgResize( L0, blocksize )
% Adjusting the sizes of patch and prior high-resolution image for following patch-based fusion steps.

[H_L0,W_L0,~]=size(L0);

% Resampling flag for the input high-resolution img.
RspFlag = 0;


%% Adjusting patch size.
% Initialization in X and Y directions.
blocksizeH = blocksize;
blocksizeW = blocksize;

% Processing in the Y direction.
if(mod(H_L0,blocksizeH) ~= 0)
    RspFlag = 1;
    for i = 3:8 % Iterating within the range of patch size.
        if(mod(H_L0,i) == 0)
            blocksizeH = i;
            break;
        end
    end
end
if(mod(H_L0,blocksizeH) ~= 0)
    blocksizeH = 3; % Set as the minimal size 3.
end


% Processing in the X direction.
if(mod(W_L0,blocksizeW) ~= 0)
    RspFlag = 1;
    for i = 3:8 % Iterating within the range of patch size.
        if(mod(W_L0,i) == 0)
            blocksizeW = i;
            break;
        end
    end
end
if(mod(W_L0,blocksizeW) ~= 0)
    blocksizeW = 3; % Set as the minimal size 3.
end

% Finalize the patch size.
if(blocksizeH ~= blocksizeW)
    blocksize = min([blocksizeH, blocksizeW]); 
end


%% Adjusting the size of the prior high-resolution img.
% Reset the height of the prior high-resolution img.
if(mod(H_L0,blocksize) ~= 0)
    H_L0 = round(H_L0/blocksize) * blocksize;
end
% Reset the width of the prior high-resolution img.
if(mod(W_L0,blocksize) ~= 0)
    W_L0 = round(W_L0/blocksize) * blocksize;
end

% If the prior high-resolution img needs to be resized.
if(RspFlag == 1)    
    L0 = imresize(L0,[H_L0 W_L0],'nearest');
end

end
