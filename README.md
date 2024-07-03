# Mitotic-Wave-Classification

## Requirements
1. ImageJ/Fiji with the TrackMate plugin.
2. MATLAB (Tested on R2020a and later)

## How to use:

### Segmentation
1. Separate the movie into chunks containing a single mitotic wave. This can be done in ImageJ/Fiji by manually duplicating the stack with specified time ranges. We found that segmentation improved when segmenting on chunks rather than the full movie. 'raw_compressed.tif' can be used as an example input of an entire time series.
2. Use ilastik to train a foreground/background classifier for nuclei. Our movies were two dimensional time series which by modifiying the metadata in ilastik, can be treated as 3D stacks. This way, temporal features can be used to improve the segmentation.
3. Export the foreground probabilies from ilastik. Because we are only dealing with two classes, the background probabilies should be omitted as they are redundant. In the export settings specify only the foreground probabilities.
4. In MATLAB, run 'segmentation.m' for each chunk of the movie, setting the variable 'probability_file' to the '*****_probabilities.h5' file exported from ilastik. Additionally set the variable 'output_segmentation_file' for each chunk. 
5. Using Fiji/ImageJ, convert each segmentation_chunk#.h5 file to a .tif for later use in ilastik.

### Classification
1. Using ilastik, train an object classifier using the raw image and the segmentation produced in the previous step. Classification should also be done in chunks. Objects should be classified as either within interphase or mitosis.
2. Export the object classes from ilastik.

### Stitching
Because the movie was divided into chunks around each mitotic wave, we need to combine the output of the previous steps into one time series.
1. Load the segmentation chunks into ImageJ/Fiji and concatentate them by running Image -> Stacks -> Tools -> Concatenate. Save as a new file. An example output is included in this repository, 'segmentation_example.tif'.
2. Load the object class chunks into ImageJ/Fiji and concatentate them by running Image -> Stacks -> Tools -> Concatenate. Save as a new file. An example output is included in this repository, 'objclass.tif'.

### Track
The track is used in a filtering step later and it does not need to be perfect so no manual correction is necessary in this step.
1. Load the full segmentation into ImageJ/Fiji. 'segmentation_example.tif' can be used as an example.
2. Run TrackMate from Plugins -> Tracking -> TrackMate. When the TrackMate interface loads make sure that the image metadata lists the number of time series appropriately. Sometimes T and Z or T and C are swapped.
3. In TrackMate use label image detector skipping object filtering.
4. Select LAP tracker and only include frame-to-frame linking. We used a maximum distance of 15 px.
5. In the export menu, choose 'Export label image' and make sure 'Track ID' is selected in the dropdown.
6. Save the exported track. This is included as an example, 'track_example.tif'.

### Filtering and Kymograph
1. In MATLAB, run 'classify.m' specifying the filenames for the segmentation, track, and object classification. The included 'segmentation_example.tif', 'track_example.tif', and 'objclass_example.tif' can be used. This function will save a file called 'objclass_filtered.h5'.
2. Run 'kymograph.m' specifying 'objclass_filtered.h5' as the filename for the variable 'objclass'. This function produces a kymograph of the object classification along the anterior posterior axis of the embryo.
