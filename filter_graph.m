function G = filter_graph(G, dist)

[bins, bins_size] = conncomp(G);
bins_u = unique(bins);

Class = G.Nodes.Class;
ClassFiltered = G.Nodes.Class;

for ii = 1:length(bins_u)
    ind = find(bins == bins_u(ii));
    sg = subgraph(G, ind);
    sg_dist = distances(sg);

    for jj = 1:length(ind)
        % n_ind = nearest(G, ind(jj), dist);
        % n_ind = [ind(jj); n_ind];
        n_ind = ind(sg_dist(:,jj) <= dist);

        n_class = Class(n_ind);
        ClassFiltered(ind(jj)) = mode(n_class);
    end
end

G.Nodes.ClassFiltered = ClassFiltered;

end

