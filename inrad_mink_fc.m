function [inds_k,r] = inrad_mink_fc(Gn_pn,Gt_pm,Mu_mm,K,c_p,t_qp,test)

if nargin < 7, test=false; end

[P,N] = size(Gn_pn);
Q = size(t_qp,1);
M = size(Gt_pm,2);
R = M/N; % number of frctional components


tansups_qm = t_qp * Gt_pm * Mu_mm; % tangential components contrib to support
tansups_qnr = reshape(tansups_qm,Q,N,R);
sups_qn = max(t_qp*Gn_pn + norms(tansups_qnr,2,3),0);
sups_nq = sups_qn';
csups_q = c_p * t_qp';
[inds_k,r] = mysfo_saturate(@(inds) max(sum(sups_nq(inds,:),1)-csups_q,0),1:N,K);


if test
    for n=1:4
        for q = 1:4
            sups2_qn(q,n) = fc_support_cvx(t_qp(q,:),Gn_pn(:,n),Gt_pm(:,(1:R)+R*(n-1)),Mu_mm);
        end
    end
    
    assert_almost_equal(sups_qn(1:4,1:4),sups2_qn(1:4,1:4))
end
    