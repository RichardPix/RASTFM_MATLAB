function [ L1_Pred_UnC ] = ReconByLLE( M0, M1, L0, SimPatches, wt, Nsim, ChgPos,L1_Pred_UnC, blocksize )

[~,~,BandNum] = size(L0);

ChgNum = size(ChgPos,1);

YS0 = zeros(blocksize*blocksize*BandNum, Nsim);
XS0 = zeros(blocksize*blocksize*BandNum, Nsim);

for k = 1:ChgNum
    for n = 1:Nsim
        i = SimPatches(2*(k-1)+1, n); j = SimPatches(2*k, n);
        Patch = L0((i-1)*blocksize+1:i*blocksize, (j-1)*blocksize+1:j*blocksize, :);
        YS0(:, n) = Patch(:); 
        Patch = M0((i-1)*blocksize+1:i*blocksize, (j-1)*blocksize+1:j*blocksize, :);
        XS0(:, n) = Patch(:);
    end
    
    i=ChgPos(k,1);j=ChgPos(k,2);
    Patch= M1(blocksize*(i-1)+1:i*blocksize,blocksize*(j-1)+1:j*blocksize,:);
    XT1 = Patch(:);
    
    % Shp chg reconstruction.
    [YT1] = ShpSimVecLLE(XT1, XS0, YS0, wt(k,:), Nsim);

    pv = reshape(YT1,blocksize,blocksize,BandNum);
    L1_Pred_UnC(blocksize*(ChgPos(k,1)-1)+1:ChgPos(k,1)*blocksize, blocksize*(ChgPos(k,2)-1)+1:ChgPos(k,2)*blocksize, :) = pv;
end

end

