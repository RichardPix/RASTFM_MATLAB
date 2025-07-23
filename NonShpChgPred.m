function [ L1_Pred, L0_Pred ] = NonShpChgPred( RealM0, M0, M1, L0, h, win, RspMethod )
% NonShpChgPred: non-shape change prediction.

%%%%%%%%%%%%%%%%%% parameter setting %%%%%%%%%%%%%%%%%%
% The searching and regression patch size should be identical.
PatchSize = 1; %Pixel/Patch-based searching.
t = (PatchSize-1)/2;
RegPatchSize = 1; %Pixel/Patch-based regression.
Rt = (RegPatchSize-1)/2;
SimPatchNum = 30; % An empirical number.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[H,W,BandNum] = size(L0);
[hm,wm,~] = size(M0);

if H == hm && W == wm
    RealM0_UpRsp = RealM0;
    M0_UpRsp = M0;
    M1_UpRsp = M1;
else
    RealM0_UpRsp = imresize(RealM0,[H W], RspMethod);
    M0_UpRsp = imresize(M0,[H W], RspMethod);
    M1_UpRsp = imresize(M1,[H W], RspMethod);
end

L1_Pred = zeros(H,W,BandNum);
L0_Pred = zeros(H,W,BandNum);

% Edge expansion.
RealM0_UpRsp_Ex = EdgeMirror(RealM0_UpRsp, [win, win]);
M0_UpRsp_Ex = EdgeMirror(M0_UpRsp, [win, win]);
M1_UpRsp_Ex = EdgeMirror(M1_UpRsp, [win, win]);
L0_Ex = EdgeMirror(L0, [win, win]);

% fusion
for i = win+1:H+win
    display(['Processing row ',num2str(i-win),' of the ',num2str(H), ' rows in non-shape change prediction']);
    for j = win+1:W+win
        % loacte the processing window
        l = i - win;
        r = i + win;
        u = j - win;
        d = j + win;
        
        % target pixel (the center of the searching window).
        cent_i = i-l+1;
        cent_j = j-u+1;
        
        % Get the data within the local window.
        Win_RealM0 = RealM0_UpRsp_Ex(l:r,u:d,:);
        Win_M0 = M0_UpRsp_Ex(l:r,u:d,:);
        Win_M1 = M1_UpRsp_Ex(l:r,u:d,:);
        Win_L0 = L0_Ex(l:r,u:d,:);
             
        % Non-local searching.
        PatchCent_L0(:,:,:) = Win_L0(cent_i - t:cent_i + t, cent_j - t:cent_j + t, :);
        [SimPatches] = FindSimPatch_NonShpChg(PatchCent_L0, Win_L0, SimPatchNum, h, t, PatchSize);
     
        [SimPatchNum,~] = size(SimPatches); % Number of similar patches.
       
        if SimPatchNum == 0
            PixCent_Pred_T1 = Win_L0(cent_i,cent_j,:) + Win_M1(cent_i,cent_j,:) - Win_M0(cent_i,cent_j,:);   
        else           
            % Spectral-Temporal-Spatial-SpecCenter Distance
            [VecCent_L0, Vec_L0, SourceVecT1, SourceVecT0] = GetFeatureVec(cent_i, cent_j, Rt, SimPatchNum, SimPatches, ...
                Win_M0, Win_M1, Win_L0, RegPatchSize, win, Win_RealM0);
            
            % linear weight calculation.
            [TargetVec_T1, TargetVec_T0] = NonShpSimVecLLE(VecCent_L0, Vec_L0, SourceVecT1, SourceVecT0, SimPatchNum);
        
            PixCent_Pred_T1 = GetCentPredPix( TargetVec_T1, BandNum, RegPatchSize);
            PixCent_Pred_T0 = GetCentPredPix( TargetVec_T0, BandNum, RegPatchSize);
        end

        L1_Pred(i-win,j-win,:)=PixCent_Pred_T1;
        L0_Pred(i-win,j-win,:)=PixCent_Pred_T0;
    end
end

end