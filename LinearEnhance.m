function [ ImgEnhan ] = LinearEnhance( Img, Enhan_min, Enhan_max )
% Linearly transform the pixel value to a fixed range: [Enhan_min, Enhan_max].

[H, W, BandNum] = size(Img);

if(H==1 && W==1)
    Ori_min = Img;
    Ori_max = Img;
else
    Ori_min = min(min(Img));
    Ori_max = max(max(Img));
end

ImgEnhan = zeros(H, W, BandNum);

for band = 1:BandNum
    ImgEnhan(:,:,band) = Enhan_min + ((Enhan_max - Enhan_min) ./ (Ori_max(:,:,band) - Ori_min(:,:,band))) ...
        .* (Img(:,:,band) - Ori_min(:,:,band));
end

end

