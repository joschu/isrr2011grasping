function save_vars(outfile,varargin)
fid = fopen(outfile,'w');

for i=1:2:numel(varargin)
    varname = varargin{i};
    val = varargin{i+1};
    fprintf(fid,'# %s\n',varname);
    strval = num2str(val);    
    for i_line=1:size(strval,1)
       fprintf(fid,'%s\n',strval(i_line,:)) ;
    end
end

fclose(fid);
end