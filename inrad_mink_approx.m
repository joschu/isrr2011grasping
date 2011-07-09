function r = inrad_mink_approx(x_np,c_p,t_kp)

dots_nk = x_np * t_kp';
pdots_nk = max(dots_nk,0);
cdots_k = c_p * t_kp';

r = min( sum(pdots_nk,1)-cdots_k);

end