function [YT] = ShpSimVecLLE(XT, XS, YS, wt, K)
% ShpSimVecLLE: Using LLE to reconsturct target patches on T2.

% regularlizer in case constrained fits in LLE are ill conditioned.
tol = 1e-4; 

[sorted,index] = sort(wt, 'descend');
neighborhood(:,1) = index(1:K);

U = zeros(K,1);

% compute weights based on neighbors of XT in XS
z = XS(:,neighborhood(:,1))-repmat(XT(:,1),1,K); 
C = z'*z; % local covariance
if trace(C)==0
    C = C + eye(K,K)*tol; % regularlization
else
    C = C + eye(K,K)*tol*trace(C);
end
U(:,1) = C\ones(K,1); % solve C*u=1

Ind = find(U(:,1)>0);
neighborhood_pos(:,1) = neighborhood(Ind,1);
u(:,1) = U(Ind,1);
u(:,1) = u(:,1)/sum(u(:,1));

YT(:,1) = YS(:,neighborhood_pos(:,1))*u(:,1);

end