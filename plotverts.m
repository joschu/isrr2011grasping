function plotverts(verts_2v,varargin)

xy = wraparound(verts_2v);
plot(xy(1,:),xy(2,:),varargin{:})

end

function y = wraparound(x)
y = [x, x(:,1)];
end
