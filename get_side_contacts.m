function conts_2k = get_side_contacts(verts_2v,per_side)
x_v = verts_2v(1,:);
y_v = verts_2v(2,:);

x_k = unifcontacts(x_v,per_side);
y_k = unifcontacts(y_v,per_side);
conts_2k = [x_k;y_k];

end

function out = unifcontacts(vs,per_side)
out = catmap2(@(i)...
    remove_endpts(linspace(vs(i),vs(mod(i,numel(vs))+1),per_side+2)),...
    1:numel(vs));
end

function out = remove_endpts(x)
out = x(2:end-1);
end
