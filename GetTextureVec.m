function [ f ] = GetTextureVec( Img, GrayLevels )
%GetEigenVec Summary of this function goes here
% Calculating GLCM and derving texture features based on GLCM.

[H, W, BandNum] = size(Img);

NumOfDirection = 4; % Number of dirctions for GLCM.
GLCM = zeros(GrayLevels, GrayLevels, NumOfDirection);
f = zeros(10, BandNum); % Number of features as 10.

for band = 1:BandNum
    % GLCM in 4 directions.
    GLCM(:,:,1) = graycomatrix(Img(:,:,band), 'GrayLimits',[], 'NumLevels',GrayLevels, 'Offset',[0 1]);   %0 degree
    GLCM(:,:,2) = graycomatrix(Img(:,:,band), 'GrayLimits',[], 'NumLevels',GrayLevels, 'Offset',[-1 1]);  %45 degree
    GLCM(:,:,3) = graycomatrix(Img(:,:,band), 'GrayLimits',[], 'NumLevels',GrayLevels, 'Offset',[-1 0]);  %90 degree
    GLCM(:,:,4) = graycomatrix(Img(:,:,band), 'GrayLimits',[], 'NumLevels',GrayLevels, 'Offset',[-1 -1]); %135 degree
    
    GLCM(:,:,1) = GLCM(:,:,1) / (2*H*(W-1));     %0 degree
    GLCM(:,:,2) = GLCM(:,:,1) / (2*(H-1)*(W-1)); %45 degree
    GLCM(:,:,3) = GLCM(:,:,1) / (2*(H-1)*W);     %90 degree
    GLCM(:,:,4) = GLCM(:,:,1) / (2*(H-1)*(W-1)); %135 degree
    
    % Calculating ASM, CON, COR, ENT based on GLCM.
    ASM = zeros(1,4); CON = zeros(1,4); COR = zeros(1,4); ENT = zeros(1,4);
    Ux = zeros(1,4); Uy = zeros(1,4);
    deltaX = zeros(1,4);  deltaY = zeros(1,4);
    
    for n = 1:NumOfDirection
        ASM(n) = sum(sum(GLCM(:,:,n).^2));
        for i = 1:GrayLevels
            for j = 1:GrayLevels
                CON(n) = (i-j)^2 * GLCM(i,j,n) + CON(n);
                
                if GLCM(i,j,n)~=0
                    ENT(n) = -GLCM(i,j,n) * log2(GLCM(i,j,n)) + ENT(n);
                end
                
                Ux(n) = i * GLCM(i,j,n) + Ux(n);
                Uy(n) = j * GLCM(i,j,n) + Uy(n);
            end
        end
    end
    for n = 1:NumOfDirection
        for i = 1:GrayLevels
            for j = 1:GrayLevels
                deltaX(n) = (i-Ux(n))^2 * GLCM(i,j,n) + deltaX(n);
                deltaY(n) = (j-Uy(n))^2 * GLCM(i,j,n) + deltaY(n);
                COR(n) = i*j * GLCM(i,j,n) + COR(n);
            end
        end
        COR(n) = (COR(n) - Ux(n)*Uy(n)) / deltaX(n) / deltaY(n);
    end
    
    % Deriving 10-dimentional texture features.
    f(1, band) = mean(ASM);   f(2, band) = sqrt(cov(ASM));
    f(3, band) = mean(CON);   f(4, band) = sqrt(cov(CON));
    f(5, band) = mean(COR);   f(6, band) = sqrt(cov(COR));
    f(7, band) = mean(ENT);   f(8, band) = sqrt(cov(ENT));
    f(9, band) = mean2(Img(:,:,band));   f(10, band) = std2(Img(:,:,band));    
end

end

