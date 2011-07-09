P = 6;
N =10;
t_mp = sphere_samples(7,P);
M = size(t_mp,1);

x = [eye(P);zeros(1,P);randn(N-P-1,P)];
x = bsxfun(@minus,x,mean(x,1));
x = x + rand(size(x))*.01;


tic
r2=inrad_mink_approx(x,zeros(1,P),t_mp);
r2time=toc;

if r2>0
%     disp('computing exact soln...')
    tic
    r1=inrad_hull_null(minkowski_sum(x));
    r1time=toc;
    
    disp([r1 r2 r1time r2time])
else
    disp('try again')
end
