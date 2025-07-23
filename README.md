# RASTFM_MATLAB
This repository provides a MATLAB implementation of RASTFM (Robust Adaptive Spatial and Temporal image Fusion Model) for downscaling complex land surface changes. 

Version 1.1: July 22, 2025.

Overview
===================================================================================================================================================================
RASTFM is an advanced image fusion algorithm designed to generate high spatial-temporal resolution remote sensing imagery by integrating fine-resolution spatial details with coarse-resolution temporal dynamics. For instance, RASTFM can blend coarse-but-frequent (e.g., MODIS) and fine-but-sparse (e.g., Landsat) satellite imagery to generate fine-and-frequent (Landsat-like) satellite imagery. RASTFM is particularly robust in scenarios with complex land surface changes such as crop rotation, rapid urban expansion, and vegetation disturbances. 

Input Requirements
===================================================================================================================================================================
(1) The pixel value range of input images is 0 - 10000 (surface reflectance).

(2) This code package is for spatial-temporal fusion, so input images should have the equivalent spectral bands.

(3) Input images should have the same geographic coverage and projection (e.g., UTM).

(4) Coarse-resolution images (e.g., MODIS) should be resampled to match the size of fine-resolution images (e.g., Landsat).

(5) All input images should be geometrically matched. 

(6) To support the spatial-temporal fusion between MODIS and Landsat. The input band names in the parameter "BandName" should be less than or equal to the Landsat bands, i.e., {'Blue', 'Green', 'Red', 'NIR', 'SWIR1', 'SWIR2'}, to call the function IntraSharpen. Moreover, the input band names must match the given name strings in "BandName" exactly.
    
Citation and References
===================================================================================================================================================================
If you use this code or its results in your research, please cite the following papers:
1. Zhao, Y., Huang, B., & Song, H. (2018). A robust adaptive spatial and temporal image fusion model for complex land surface changes. Remote sensing of environment, 208, 42-62. doi: 10.1016/j.rse.2018.02.009
2. Zhao, Y., Liu, D., & Wei, X. (2020). Monitoring cyanobacterial harmful algal blooms at high spatiotemporal resolution by fusing Landsat and MODIS imagery. Environmental Advances, 2, 100008. 10.1016/j.envadv.2020.100008

Intellectual Property Statement
===================================================================================================================================================================
This release includes essential components of the RASTFM algorithm to enable research reproducibility and non-commercial use. For IP protection:

    1. Some modules are compiled as *.pcode and not publicly readable.

    2. Redistribution or commercial use of this code or derived products requires explicit permission from the authors.

If you are interested in using RASTFM in a commercial or large-scale operational system, please contact the first or corresponding author.

Copyright and License
===================================================================================================================================================================
Copyright (c) 2018–2025 Yongquan Zhao, yqzhao@niglas.ac.cn, Ningjing Institute of Geography and Limnology, Chinese Academy of Sciences (NIGLAS); Bo Huang, bohuang@hku.hk, The University of Hong Kong.

This repository is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0) license.
