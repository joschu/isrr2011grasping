function dprint(varargin)
if evalin('base','exist(''DEBUG'', ''var'')'), fprintf(varargin{:}); end
end
    

