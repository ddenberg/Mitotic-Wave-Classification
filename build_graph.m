function G = build_graph(cell_table)

nodeIDs = join([string(cell_table.Frame), string(cell_table.ObjID)], '_', 2);

neighbor_ind = cell(length(nodeIDs), 1);
track_u = unique(cell_table.TrackID);
for ii = 1:length(track_u)
    ind = find(cell_table.TrackID == track_u(ii));

    for jj = 1:length(ind)
        frame_jj = cell_table.Frame(ind(jj));
        n_ind = setdiff(find(abs(cell_table.Frame(ind) - frame_jj) < 2), jj);
        neighbor_ind{ind(jj)} = unique([neighbor_ind{ind(jj)}; ind(n_ind)]);
    end
end

neighbor_len = cellfun('length', neighbor_ind);

ind_rep = repelem((1:length(nodeIDs)).', neighbor_len);
neighbor_vec = cell2mat(neighbor_ind(neighbor_len > 0));

edgeTable = table([nodeIDs(ind_rep), nodeIDs(neighbor_vec)], 'VariableNames', {'EndNodes'});
nodeTable = table(nodeIDs, 'VariableNames', {'Name'});
nodeTable.Class = cell_table.Class;
nodeTable.Frame = cell_table.Frame;
nodeTable.ObjID = cell_table.ObjID;

G = simplify(graph(edgeTable, nodeTable));

end

