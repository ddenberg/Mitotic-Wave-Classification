
% Exported from ilastik:
probability_file = 'F:\Shvartsman_lab\Segmentation_Liu\20230629\131_380\SUM_20230605_1001-1_Probabilities.h5';
output_segmentation_file = 'segmentation_chunk1.h5';

prob = squeeze(h5read(probability_file, '/exported_data'));

prob_smooth = imgaussfilt3(prob, 0.5);
BW = imbinarize(prob_smooth, 'global');

prob_smooth = imhmax(prob_smooth, 0.5);


L = zeros(size(prob), 'uint16');
for ii = 1:size(L, 3)
    P = prob_smooth(:,:,ii);
    L(:,:,ii) = watershed(-P, 8);

    if mod(ii, 10) == 0
        fprintf('%d/%d\n', ii, size(L, 3));
    end
end

L(~BW) = 0;

% Save to h5
chunksize = [64, 64, 1];
h5create(output_segmentation_file, '/exported_data', size(L), 'ChunkSize', chunksize, 'Datatype', 'uint16', 'Deflate', 1);
h5write(output_segmentation_file, '/exported_data', L);