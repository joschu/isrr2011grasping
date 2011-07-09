%%
f = @(inds) sum(inds)
N = 10
parts = {1:3,4:6,7:10}
sels = [2,2,1]
[inds,optval]= mysfo_greedy_k_part(f,N,parts,sels)

assert_equal(inds,[10,6,5,3,2])
%%
seedrng
N = 10 % number of points to choose
R = 5 % number of functions
A_nr = rand(N,R)
fs = @(inds) sum(A_nr(inds,:),1)

% first test against old version
K = 3
parts = {1:N}
sels = [K]

[inds,val] = mysfo_saturate(fs,1:N,K)
[inds1,val1] = mysfo_saturate_part(fs,N,parts,sels)
assert_equal(inds,inds1)
assert_equal(val,val1)

% inds1 =
%      9     4     7
parts = {1:3,4:7,8:10}
sels = [0,2,1]
[inds2,val2] = mysfo_saturate_part(fs,N,parts,sels)   
assert_equal(inds,inds2)
assert_equal(val,val2)