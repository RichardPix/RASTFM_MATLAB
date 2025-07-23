function [ M1_Normalized, MaskUnC, coef ] = RelRadNorm( SM0, M1, ChgThresh, RspMethod )
%RelRadNorm: Relative Radiometric Normalization

[H_M0, W_M0, ~] = size(M1);

% change detection.
[ ~, MaskUnC ] = ChgDetect( SM0, M1, H_M0, W_M0, ChgThresh, RspMethod );

% Non-change sets based regression.
[M1_Normalized,coef] = Reg_NC(SM0, M1, MaskUnC);


end

