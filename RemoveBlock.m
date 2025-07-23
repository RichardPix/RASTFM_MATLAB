function [ IMG ] = RemoveBlock( IMG, MaskChg, BlockSize )
% Remove block effects for predicted patches at shape change points.

MaskChg_Dil = imdilate(MaskChg, strel('square', 3)); % image dilation.

[H_BlockNum,W_BlockNum] = size(MaskChg_Dil);

% size of the search window.
last = BlockSize + 2;

% Range of maximum pixel coordinates.
R = BlockSize + 1;

% Weight of the center patch (to be updated).
P_con = 0.5;

for i = 2 : H_BlockNum - 1
    for j = 2 : W_BlockNum - 1
        if(MaskChg_Dil(i,j) == 0)
            continue;
        else
            SearchWin = IMG(BlockSize*(i-1):i*BlockSize+1, BlockSize*(j-1):j*BlockSize+1, :);
            TargetWin = IMG(BlockSize*(i-1)+1:i*BlockSize, BlockSize*(j-1)+1:j*BlockSize, :);
            
            % Weighted sum based on distance.
            for m = 1 : BlockSize
                for n = 1 : BlockSize
                    p1 = 1/n^2;
                    p2 = 1/(R-n)^2;
                    p3 = 1/m^2;
                    p4 = 1/(R-m)^2;
                    s = (p1 + p2 + p3 + p4) * 2;
                    P_left = p1 / s;
                    P_right = p2 / s;
                    P_up = p3 / s;
                    P_down = p4 / s;
                    TargetWin(m, n, :) = P_con*TargetWin(m, n, :) + P_left*SearchWin(m, 1, :) +...
                        P_right*SearchWin(m, last, :) + P_up*SearchWin(1, n, :) + P_down*SearchWin(last, n, :);
                end
            end
            
            IMG(BlockSize*(i-1)+1:i*BlockSize, BlockSize*(j-1)+1:j*BlockSize, :) = TargetWin;
        end
    end
end

end