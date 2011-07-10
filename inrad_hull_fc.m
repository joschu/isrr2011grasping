function [inds_k,r] = inrad_hull_fc(Gn_pn,Gt_pm,Mu_mm,K,c_p,t_qp,test)

Gn_pn = bsxfun(@minus,Gn_pn,c_p);
if nargin < 7, test=false; end

[P,N] = size(Gn_pn);
Q = size(t_qp,1);
M = size(Gt_pm,2);
R = M/N; % number of frctional components


tansups_qm = t_qp * Gt_pm * Mu_mm; % tangential components contrib to support
tansups_qnr = reshape(tansups_qm,Q,N,R);
tansups_qn = norms(tansups_qnr,2,3);
normsups_qn = t_qp*Gn_pn;
sups_qn = (normsups_qn>0).*(normsups_qn + tansups_qn);
sups_nq = sups_qn';
[inds_k,r] = mysfo_saturate(@(inds) max(sups_nq(inds,:),[],1),1:N,K);


if test
    for n=1:4
        for q = 1:4
            sups2_qn(q,n) = fc_support_cvx(t_qp(q,:),Gn_pn(:,n),Gt_pm(:,(1:R)+R*(n-1)),Mu_mm);
        end
    end
    
    assert_almost_equal(sups_qn(1:4,1:4),sups2_qn(1:4,1:4))
end
    