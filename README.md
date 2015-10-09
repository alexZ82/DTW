# Dynamic Time Warping (DTW) for Measuring Event Related Potential latency differences
## The goal of this project was to formalise and evaluate the use of DTW as a method of estimating latency differences in ERPs 

## Published work

This method is described in detail and compared against other popular methods in: [Zoumpoulaki, A., Alsufyani, A., Filetti, M., Brammer, M. and Bowman, H. (2015), Latency as a region contrast: Measuring ERP latency differences with Dynamic Time Warping. *Psychophysiology*. doi: 10.1111/psyp.12521] (http://onlinelibrary.wiley.com/doi/10.1111/psyp.12521/abstract). 

**Problem**

ERP latencies are considered very hard to measure, with the available methods (i.e. peak latency, fractional peak and fractional area) being characterized by several weaknesses, such as: 
- point measurments
- sensitivity to window placement
- parametrisation 

**Solution**

Dynamic Time Warping allows to examine the temporal relationship between two time series by warping (strechning and /or compressing) one to the other. 
Measurments: 
- Directionality of latency difference
    - DTW_diff = (AUC diagonal - AUC warping path)/ AUC diagonal
- Estimation of latency difference 
    - Median/Mode from distribution of point distnaces

### Running 
DTW/functions_dtwlatency.R contains the function dtw_diff that performs all necessary calculations 

#### Input
The function takes as input the output from applying the dtw::dtw (http://dtw.r-forge.r-project.org/). Applying dtw generates several output but we are interested in the warping path:
- index1 matched elements indices in x
- index2 corresponding mapped indices in y

#### Output
The ouput is the list results with   
results$direction: The latency directionality as a magnitude of the area under the warping path  
results$distances: A distribution of distances between the indices of the query and the reference  
results$dtw_median: The median of the 'distances' distribution  
results$dtw_mode: The mode of the 'distances' distribution  

### Examples
Examples are located in DTW/DTW_example_use.R

#### Example 1: Compare 2 sinusoid signals with a difference of 25 samples  


![Example 1] [image1]
[image1]: https://github.com/alexZ82/DTW/blob/master/example1.jpg


#### Example 2: Compare ERPs 
EEG conditions: 
- Condition A: Data loaded from EEGR.data 731 trials
- Condition B: Condition A pushed by 50 samples

![Example 2] [image2]
[image2]: https://github.com/alexZ82/DTW/blob/master/example2.jpg  


#### Example 3: Compare ERPs (more realistic example)
EEG conditions: Data loaded from EEGR.data 731 trials
EEG data set is randomly divided to Condition A and Condition B and then Condition B is pused in time by 50 samples.  


![Example 3] [image3]
[image3]: https://github.com/alexZ82/DTW/blob/master/example3.jpg
 


