# Segmentation
Having the Augmented Partial Factorization (APF), we minimize computational costs, especially memory consumptions, for full characterization of centimeter-scale metasurfaces.

Augmented Partial Factorization (APF) is an efficient method for fully characterizing the scattering matrix of linear, complex media with multiple input channels, such as metasurfaces. The method was published in APF has been published in [ Nature Computational Science (2022)](https://www-nature-com.libproxy2.usc.edu/articles/s43588-022-00370-6). Although APF significantly improves computational speed and memory efficiency for multi-input cases, it still scales with the structure size, making the characterization of optimal metasurfaces larger than 4 mm highly challenging. In this work, we overcome this challenge by significantly reducing computational costs—particularly memory usage, which is the main bottleneck in characterizing large-area metasurfaces. Our approach breaks down the computations into smaller segments, characterizes each segment independently, and then carefully stitches the results together. Using this method, we achieve characterization with less than 1% error while reducing memory usage by several hundred times.



