function out = catmap2(f,x)
out = cell2mat(arrayfun(f,x,'UniformOutput',false));
end