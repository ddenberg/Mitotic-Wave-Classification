
seg = tiffreadVolume('segmentation_example.tif');
seg = uint16(seg);
track = tiffreadVolume('track_example.tif');
objclass = tiffreadVolume('objclass_example.tif');

cell_table = array2table(zeros(0, 4), 'VariableNames', {'Frame', 'ObjID', 'TrackID', 'Class'});
for frame = 1:size(seg, 3)
    stats_class = regionprops(seg(:,:,frame), objclass(:,:,frame), {'PixelValues', 'Area'});
    stats_track = regionprops(seg(:,:,frame), track(:,:,frame), 'PixelValues');

    filter = [stats_class.Area] > 0;

    ObjID = find(filter);
    TrackID = cellfun(@(vec) double(mode(vec)), {stats_track.PixelValues});
    TrackID = TrackID(filter);

    Class = cellfun(@(vec) double(mode(vec)), {stats_class.PixelValues});
    Class = Class(filter);

    cell_table = [cell_table; array2table([frame*ones(length(ObjID), 1), ObjID(:), TrackID(:), Class(:)], ...
        'VariableNames', {'Frame', 'ObjID', 'TrackID', 'Class'})];
end

G = build_graph(cell_table);
G = filter_graph(G, 5);

%% update objclass array
for frame = 1:size(seg, 3)
    ind = find(G.Nodes.Frame == frame);

    for ii = 1:length(ind)
        node_id = G.Nodes.ObjID(ind(ii));
        [I,J] = find(seg(:,:,frame) == node_id);
        seg_ind = sub2ind(size(seg), I, J, frame*ones(length(I), 1));

        objclass(seg_ind) = G.Nodes.ClassFiltered(ind(ii));

    end

    fprintf('%d/%d\n', frame, size(seg, 3));
end

chunksize = [64, 64, 1];
h5create('objclass_filtered.h5', '/exported_data', size(objclass), 'Datatype', 'uint8', 'Chunksize', chunksize, 'Deflate', 1);
h5write('objclass_filtered.h5', '/exported_data', objclass);