objdir = '/home/joschu/Data/grasping/obj';
outdir = '/home/joschu/Data/grasping/results';

algs = {'bb','sat','unif','rand'};
models = [1147 80 288 649 540];
% models = [1147 80];

K = 15
for modelnum = models(2)
    
    alg = 'sat';
    
    objfname = sprintf('%s/m%i.obj',objdir,modelnum);
    outname = sprintf('%s/m%i_%i_%s.mat',outdir,modelnum,K,alg);
    plot_results(outname)
    
end
