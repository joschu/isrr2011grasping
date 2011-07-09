function hs = plotord(x_n2,varargin)
N = size(x_n2,1);
hs = zeros(1,N);
for n=1:N
   xy = x_n2(n,:);
   x = xy(1); y = xy(2);
   hs(n)=text(x,y,num2str(n),varargin{:});
end
end