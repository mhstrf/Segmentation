# Efficient Full-Characterization of Centimeter-Scale Metasurfaces by Accurate Segmentation using Augmented Partial Factorization
We enable full characterization of extremely large-area metasurfaces, up to 1 cm in width and with thousands of input channels, in under 20 minutes, using less than 97 GiB of memory and achieving an error below 1%.

Augmented Partial Factorization (APF) is an efficient method for fully characterizing the scattering matrix of linear, complex media with multiple input channels, such as metasurfaces. The method was published in APF has been published in [ Nature Computational Science (2022)](https://www-nature-com.libproxy2.usc.edu/articles/s43588-022-00370-6). Although APF significantly improves computational speed and memory efficiency for multi-input cases, it still scales with the structure size, making the characterization of optimal metasurfaces larger than 4 mm highly challenging. 

In this work, we overcome this challenge by significantly reducing computational costs—particularly memory usage, which is the main bottleneck in characterizing large-area metasurfaces. Our approach breaks down the computations into smaller segments, characterizes each segment independently, and then carefully stitches the results together. Using this method, we achieve characterization with less than 1% error while reducing memory usage by several hundred times.


# How to run
To run the codes, one needs to:
- Install [MESTI.m](https://github.com/complexphoton/MESTI.m/tree/main)
- Install the serial version of [MUMPS](https://mumps-solver.org/index.php?page=home) and its MATLAB interface
- Download and add the MESTI.m/src folder to the search path using the addpath command in MATLAB

# Example
An example of the results and the corresponding error is shown below:

