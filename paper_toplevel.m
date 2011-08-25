algs = {'sat','rand','unif','bb','bb1'};
Ks = 7:4:40;
models = [1147 80 288 649 540];


for modelnum = models
    for i_alg = 1:length(algs)
        for K = Ks
            paper_run_alg(modelnum,algs{i_alg},K,'')
        end
    end
end