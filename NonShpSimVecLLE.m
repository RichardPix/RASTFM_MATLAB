function [YT_T1_pos, YT_T0_pos] = NonShpSimVecLLE(XT, XS, YS_T1, YS_T0, K)
% compute weight matrix U by reconstructing nearest appearance neighbors of XT in XS

% regularlizer in case constrained fits in LLE are ill conditioned.
tol = 1e-4; 

distance = dist2(XT(:,1)',XS');
[sorted,index] = sort(distance');
neighborhood(:,1) = index(1:K);

U = zeros(K,1);

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
U_pos(:,1) = U(Ind,1);
U_pos(:,1) = U_pos(:,1)/sum(U_pos(:,1));

% Target prediction.
YT_T1_pos(:,1) = YS_T1(:,neighborhood_pos(:,1))*U_pos(:,1);
YT_T0_pos(:,1) = YS_T0(:,neighborhood_pos(:,1))*U_pos(:,1);

end
