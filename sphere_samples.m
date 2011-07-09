function pts_np = sphere_samples(n,p,mode)
if nargin < 3, mode=0; end

if mode == 0
    if n > 100
        k = floor( (n/(2*p))^(1/(p-1)) );
    else
        k = n;
    end
    
    if p==2, bases = {linspace(-1,1,k)};
    else [bases{1:p-1}] = ndgrid(linspace(-1,1,k));
    end
    flatcoords = cellfun(@(b) b(:),bases,'UniformOutput',false);
    L = ones(size(flatcoords{1}));
    facepair = [flatcoords{:},L;
                flatcoords{:},-L];
    faces = arrayfun(@(i) facepair(:,[i:p,1:i-1]),(1:p)','UniformOutput',false);
    pts_np = normr(cell2mat(faces));
elseif mode == 1    
    pts_np = normr(randn(n,p));    
end

end
