function plot_results(fname)

q = load(fname)

plot_normals(q.objfname,q.chosen_inds)
