# Mitotic-Wave-Classification

## How to use:

### Segmentation
1. Separate the movie into chunks containing a single mitotic wave. We found that segmentation improved when segmenting on chunk rather than the full movie.
2. Use ilastik to train a foreground/background classifier for nuclei. Our movies were two dimensional time series which by modifiying the metadata in ilastik, can be treated as 3D stacks. This way, temporal features can be used to improve the segmentation.
3. Export the foreground probabilies from ilastik. Because we are only dealing with two classes, the background probabilies should be omitted as they are redundant. In the export settings specify only the foreground probabilities.
4. Run 'segmentation.m' for each chunk of the movie, setting the variable 'probability_file' to the '*****_probabilities.h5' file exported from ilastik.
5. Using Fiji/ImageJ convert the segmentation.h5 file to a .tif for later use in ilastik.

### Classification
1. Using ilastik, train an object classifier using the raw image and segmentation produced in the previous step. Objects should be classified as either within interphase or mitosis.
