# LWPR

Evaluation of light-weight place recognition approaches in changing environments in [Lowry and Andreasson](http://ieeexplore.ieee.org/document/8258890/?arnumber=8258890).

## Dependencies

This code depends on the Yael library.
See http://yael.gforge.inria.fr/ to download and configure with Matlab.

This demo version is designed to run with the Garden Points Walking dataset. Parameters are included in the ```defaultparameters.m``` file.

Information on downloading the Garden Points Walking dataset can be found at https://wiki.qut.edu.au/display/cyphy/Day+and+Night+with+Lateral+Pose+Change+Datasets

### Running the demo

Run 

```
preprocessdata
```

followed by

```
demo
```

The code used to generate the PCA basis and the vocabulary files is included in ```training.m``` in the Training folder. The training code depends on OpenCV. Update the ```mex_string``` variable in ```training.m``` with the appropriate OpenCV version.

## Reference

If you use LWPR in an academic work, please cite:

```
@ARTICLE{8258890, 
author={S. Lowry and H. Andreasson}, 
journal={IEEE Robotics and Automation Letters}, 
title={Lightweight, Viewpoint-Invariant Visual Place Recognition in Changing Environments}, 
year={2018}, 
volume={3}, 
number={2}, 
pages={957-964}, 
doi={10.1109/LRA.2018.2793308}, 
month={April}
}
```

## Acknowledgements

* Arren Glover for the Gardens Point Walking dataset
