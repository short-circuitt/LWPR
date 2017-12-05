# LWPR

Evaluation of light-weight place recognition approaches in changing environments

## Dependencies

This code depends on the Yael library.
See http://yael.gforge.inria.fr/ to download and configure with Matlab

This demo version is designed to run with the Garden Points Walking dataset. Parameters are included in the 

```
defaultparameters.m
```

file.

Information on downloading the Garden Points Walking dataset can be found at https://wiki.qut.edu.au/display/cyphy/Day+and+Night+with+Lateral+Pose+Change+Datasets

### Running the demo

```
Run preprocessdata.m
```

followed by

```
demo.m
```

The code used to generate the PCA basis and the vocabulary files is included in 

```
training.m
```

in the Training folder. The training code depends on OpenCV. Update the ```mex_string''' variable in ```training.m''' with the appropriate OpenCV version.

## Acknowledgements

* Arren Glover for the Gardens Point Walking dataset