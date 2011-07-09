function hs = plotlabels(labels,x_n2,offset,varargin)
N = size(x_n2,1);
hs = zeros(1,N);
xo = offset(1); yo = offset(2);
for n=1:N
   xy = x_n2(n,:);
   [x,y] = ds2nfu(xy(1),xy(2));
   hs(n)=annotation('textarrow',[x+xo,x],[y+yo,y],'String',labels(n),varargin{:});
end
end