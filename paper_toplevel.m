algs = {'sat','rand','unif','bb','bb1'};
Ks = 7:4:40;
% models = [1147 80 288 649 540];
models = [157 552 1057 696 19 1762 1313 1073 697 943 663 210 1364 1263 1560 1321 24 763 16 1693 756 1024 1381 746 375 1432 882 589 367 1062 494 471 1299 1196 700 62 827 179 1216 806 1350 460 861 310 20 626 1066 781 462 1279];



for modelnum = models
    for i_alg = 1:length(algs)
        for K = Ks
            paper_run_alg(modelnum,algs{i_alg},K,'')
        end
    end
end