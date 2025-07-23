function [M1,coef]=Reg_NC(M0, M1, MaskUnC)

[H_M0,W_M0,BandNum]=size(M0);

MaskUnC = imresize(MaskUnC,[H_M0 W_M0], 'nearest');

[RowInd, ColInd] = find(MaskUnC);
UnChgNum = size(RowInd, 1);

coef=zeros(BandNum,2);
UnChgM0 = zeros(UnChgNum, 1);
UnChgM1 = zeros(UnChgNum, 1);
for d=1:BandNum
    for i = 1:UnChgNum
        UnChgM0(i, 1) = M0(RowInd(i) , ColInd(i), d);
        UnChgM1(i, 1) = M1(RowInd(i) , ColInd(i), d);
    end
    
    % Regression between TO and T1 based on the unchange set.
    x = UnChgM0(:,:); x = x(:);
    y = UnChgM1(:,:); y = y(:);    
    p = polyfit(x,y,1);
    
    Y = reshape(M1(:,:,d),H_M0*W_M0,1);
    Y_ReNorm = (Y - p(2)) / p(1); 
    M1(:,:,d)=reshape(Y_ReNorm,H_M0,W_M0);
    coef(d,:)=p;
end

end