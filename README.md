# RASTFM_MATLAB
RASTFM (Robust Adaptive Spatial and Temporal Fusion Model) is to blend coarse-but-frequent (e.g., MODIS) and fine-but-sparse (e.g., Landsat) satellite imagery to generate fine-and-frequent satellite imagery.

Version 1.1: July 22, 2025.

Input requirements:
===================================================================================================================================================================
(1) The pixel value range of input images is 0 - 10000 (surface reflectance).

(2) Input images should have the same geographic coverage and projection (e.g., UTM).

(3) Input images should be geometrically matched. 

(4) This code package is for spatial-temporal fusion, so input images should have the same/similar bands.

(5) To support the spatial-temporal fusion between MODIS and Landsat. The input band names in the parameter "BandName" should be less than or equal to the Landsat bands, i.e., {'Blue', 'Green', 'Red', 'NIR', 'SWIR1', 'SWIR2'}, to call the function IntraSharpen. Moreover, the input band names must match the given name strings in "BandName" exactly.
    
References:

1. Zhao, Y., Liu, D., & Wei, X. (2020). Monitoring cyanobacterial harmful algal blooms at high spatiotemporal resolution by fusing Landsat and MODIS imagery. Environmental Advances, 2, 100008. 10.1016/j.envadv.2020.100008
2. Zhao, Y., Huang, B., & Song, H. (2018). A robust adaptive spatial and temporal image fusion model for complex land surface changes. Remote sensing of environment, 208, 42-62. doi: 10.1016/j.rse.2018.02.009

Copyright (c) 2018–2025 Yongquan Zhao, Ningjing Institute of Geography and Limnology, Chinese Academy of Sciences (NIGLAS), yqzhao@niglas.ac.cn
