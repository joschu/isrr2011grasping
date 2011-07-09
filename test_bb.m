%%
clear
expt_2d_shapes

%%
K=6

[r1,i1,tree] = inrad_bb(G_3k',K,c_3',sphere_samples(5,3),'mink')
%%
[r2,i2] = inrad_mink_k_brute(G_3k',K,c_3',sphere_samples(5,3))

%%
assert (r1 == r2)
assert_equal( sort(i1), sort(i2) )
assert( all([tree.lb] - [tree.ub] < .01 | [tree.lb] == -inf ))
