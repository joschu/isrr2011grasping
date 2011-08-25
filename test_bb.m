%%
clear
expt_2d_shapes

%%
K=6
tic
[r1,i1,tree] = inrad_bb(G_3k',K,c_3',sphere_samples(5,3),'mink')
t_comp=toc
%%
[r2,i2] = inrad_mink_k_brute(G_3k',K,c_3',sphere_samples(5,3))

%%
assert (r1 == r2)
assert_equal( sort(i1), sort(i2) )
assert( all([tree.lb] - [tree.ub] < .01 | [tree.lb] == -inf ))

%%
tic
[rnew,inew,tree] = inrad_bb1(G_3k',K,c_3',sphere_samples(5,3),'mink')
t_simp1 = toc
[~,sortinds] = sort(G_3k(1,:));
tic
[rnew1,iinew1,tree1] = inrad_bb1(G_3k(:,sortinds)',K,c_3',sphere_samples(5,3),'mink');
inew1 = sortinds(iinew1);
t_simp2 = toc