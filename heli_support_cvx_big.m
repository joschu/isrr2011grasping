function [h_nk,t_rnk] = heli_support_cvx_big(G_pR,C_mR,y_pk,N,blocksize)
if nargin < 5, blocksize=50; end
% solve a big problem by breaking it into reasonably sized blocks

P = size(y_pk,1);
K = size(y_pk,2);


starts = 1:blocksize:K;
stops = min(starts+blocksize-1,K);

h_nk = zeros(N,K);

n_blocks = numel(starts);
for i = 1:n_blocks
    fprintf('block %i/%i\n',i,n_blocks);
    start = starts(i);
    stop = stops(i);
    [hsmall_nk,tsmall_rnk] = heli_support_cvx(G_pR,C_mR,y_pk(:,start:stop),N);
    h_nk(:,start:stop) = hsmall_nk;
    t_rnk(:,:,start:stop) = tsmall_rnk;
end
    
    