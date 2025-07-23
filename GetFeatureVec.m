function [SpecTemSpaVecCent, SpecTemSpaVec, SourceVecT1, SourceVecT0] = GetFeatureVec(RowCent, ColCent, t, SimPatchNum, SimPatches, ...
    Win_M0, Win_M1, Win_L0, PatchSize, win, Win_RealM0)

% Expand local window.
Win_L0 = EdgeMirror(Win_L0, [t, t]);
Win_M0 = EdgeMirror(Win_M0, [t, t]);
Win_M1 = EdgeMirror(Win_M1, [t, t]);

% trans coordinates from the non-expanded local window to the expanded local window.
% Center pixel.
RowCent = RowCent + t;
ColCent = ColCent + t;
% similar pixels.
SimPatches = SimPatches + t;

[WinRow, WinCol, BandNum] = size(Win_L0);

%% Extract the center patch.
% SpecCenterDist
PatchCent_L0(:,:,:) = Win_L0(RowCent - t:RowCent + t, ColCent - t:ColCent + t, :);
VecCent_L0 = PatchCent_L0(:,:); VecCent_L0 = VecCent_L0(:);

% SpecTemDist
PatchCent_M0(:,:,:) = Win_M0(RowCent - t:RowCent + t, ColCent - t:ColCent + t, :);
PatchCent_M1(:,:,:) = Win_M1(RowCent - t:RowCent + t, ColCent - t:ColCent + t, :);
VecCent_M0 = PatchCent_M0(:,:); VecCent_M0 = VecCent_M0(:);  
VecCent_M1 = PatchCent_M1(:,:); VecCent_M1 = VecCent_M1(:); 

% ln distance.
SpectCenterDistCent = 1 + 0; % Adding a small constant 1 to aviod zero spectral differences for center pixels.
SpaDistCent = 1 + 0; % Adding a small constant 1 to aviod zero distances for center pixels.
SpecDistCent = log(abs(VecCent_L0 - VecCent_M0) + 1);
TemDistCent = log(abs(VecCent_M0 - VecCent_M1) + 1);
SpectCenterDistCent = repmat(SpectCenterDistCent,BandNum*PatchSize*PatchSize,1);
SpaDistCent = repmat(SpaDistCent,BandNum*PatchSize*PatchSize,1);

SpecTemSpaVecCent = SpecDistCent .* TemDistCent .* SpaDistCent .* SpectCenterDistCent;


%% Extract similar patches.
Patches_RealM0 = zeros(SimPatchNum, PatchSize, PatchSize, BandNum);
Patches_M0 = zeros(SimPatchNum, PatchSize, PatchSize, BandNum);
Patches_M1 = zeros(SimPatchNum, PatchSize, PatchSize, BandNum);
Patches_L0 = zeros(SimPatchNum, PatchSize, PatchSize, BandNum);

SpaDist = zeros(SimPatchNum,1); % Weight of spatial distance.

for i=1:SimPatchNum   
    % Setting the range of similar patches.
    PatchRowStart = SimPatches(i,1) - t; 
    PatchRowEnd = SimPatches(i,1) + t;
    PatchColStart = SimPatches(i,2) - t;
    PatchColEnd = SimPatches(i,2) + t;
    if(PatchRowStart < 1) % If the 1st row of the patch exceeds the 1st row of the moving window.
        PatchRowStart = 1;
        PatchRowEnd = PatchRowStart + PatchSize - 1;
        if(PatchRowEnd > WinRow) % If the moving window is smaller than the patch, window = patch.
            PatchRowEnd = WinRow;
        end 
    end
    if(PatchRowEnd > WinRow) % If the last row of the patch exceeds the last row of the moving window.
        PatchRowEnd = WinRow;
        PatchRowStart = PatchRowEnd - PatchSize + 1;
        if(PatchRowStart < 1) % If the moving window is smaller than the patch, window = patch.
            PatchRowStart = 1;
        end 
    end
    if(PatchColStart < 1) % If the 1st column of the patch exceeds the 1st column of the moving window.
        PatchColStart = 1;
        PatchColEnd = PatchColStart + PatchSize - 1;
        if(PatchColEnd > WinCol) % If the moving window is smaller than the patch, window = patch.
            PatchColEnd = WinCol;
        end 
    end
    if(PatchColEnd > WinCol) % If the last column of the patch exceeds the last column of the moving window.
        PatchColEnd = WinCol;
        PatchColStart = PatchColEnd - PatchSize + 1;
        if(PatchColStart < 1) % If the moving window is smaller than the patch, window = patch.
            PatchColStart = 1;
        end 
    end
    
    Patches_RealM0(i,:,:,:) = Win_RealM0(PatchRowStart:PatchRowEnd, PatchColStart:PatchColEnd, :);
    Patches_M0(i,:,:,:) = Win_M0(PatchRowStart:PatchRowEnd, PatchColStart:PatchColEnd, :);
    Patches_M1(i,:,:,:) = Win_M1(PatchRowStart:PatchRowEnd, PatchColStart:PatchColEnd, :);
    Patches_L0(i,:,:,:) = Win_L0(PatchRowStart:PatchRowEnd, PatchColStart:PatchColEnd, :);   
    
    SpaDist(i,1) = 1 + ( ( (double(SimPatches(i,1))-double(RowCent))^2 + (double(SimPatches(i,2))-double(ColCent))^2 )^0.5 ) ./ win;
end

Vec_RealM0 = Patches_RealM0(:,:,:); Vec_RealM0 = Vec_RealM0(:,:); Vec_RealM0 = Vec_RealM0';
Vec_M0 = Patches_M0(:,:,:); Vec_M0 = Vec_M0(:,:); Vec_M0 = Vec_M0';
Vec_M1 = Patches_M1(:,:,:); Vec_M1 = Vec_M1(:,:); Vec_M1 = Vec_M1';
Vec_L0 = Patches_L0(:,:,:); Vec_L0 = Vec_L0(:,:); Vec_L0 = Vec_L0';

SourceVecT1 = Vec_L0 + Vec_M1 - Vec_M0; % Target vector.
SourceVecT0 = Vec_L0 + Vec_RealM0 - Vec_M0; 

% Generating weight factors.
SpecDist = log(abs(Vec_L0 - Vec_M0) + 1);
TemDist = log(abs(Vec_M0 - Vec_M1) + 1);
SpectCenterDist = log(abs(Vec_L0 - repmat(VecCent_L0,1,SimPatchNum)) + 1) + 1;
SpaDist = repmat(SpaDist',BandNum*PatchSize*PatchSize,1);

SpecTemSpaVec = SpecDist .* TemDist .* SpaDist .* SpectCenterDist;

end