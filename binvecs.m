function out = binvecs(n)
if n == 1
    out = [false;true];
else
    x = binvecs(n-1);
    out = [x,false(2^(n-1),1);
           x,true(2^(n-1),1)];
end