###Examples on how to use the DTW for measuring latency differences
x<-c("dtw", "caTools")
lapply(x, require, character.only=T)
source("functions_dtwlatency.R")


###1st EXAMPLE == Basic  Sinusoidal Signals------------------------------------------------------------------###
###Initial example taken from http://dtw.r-forge.r-project.org/
idx<-seq(0,6.28,len=100);
query<-sin(idx)+runif(100)/10;
## A cosine is for reference; sin and cos are offset by 25 samples
reference<-cos(idx)
## Find the best match with the canonical recursion formula
alignment<-dtw(query,reference,keep=TRUE);

##!!! DTW for Latency Difference Analysis !!!!##
## Calculate latency differences
latency_differences<-dtw_diff(alignment$index1,alignment$index2)
plot_latency_results(query,reference,alignment,latency_differences)
####----------END OF 1st EXAMPLE-----------------------------------------------------------------------------###
### First remove all data except the funtion from the workspace----------------------------------------------###
rm(list = setdiff(ls(), lsf.str()))

### 2nd  EXAMPLE == ERP example------------------------------------------------------------------------------###
### This is an example of how to do a latency analysis between two ERP signals
### Load ERP signal -- I have stored an array of EEG data from and example to an .RData file

load('EEG.RData')
### subj_eeg is a 2200x48 matrix, representing 731 trials with 2200 timepoints. These are trials (±50) from 15 subjects for the same condition.
subj_erp<-erp(allsubjects)
# dev.off()
# par(mfrow=c(2,1))
# matplot(allsubjects,type='l',ylab='amplitude',xlab='timepoints') #visualise the trials
# plot(rec_time,subj_erp,type='l',ylab='amplitude',xlab='time') #visualise the ERP
available_trials<-ncol(allsubjects)
#Firstly a simply example where the second condition is exactly the same as the first, just pushed by a certain amount
latency_effect<-50
ConditionA<-allsubjects[,1:available_trials]
ConditionB<-apply(ConditionA,2,pushintime,howmuch=latency_effect)

### I am going to apply DTW just to the window of interest which is 300-700ms
start_point<-which(rec_time==300)
end_point<-which(rec_time==700)
### Arbitarily set one condition as query and the other as reference. 
query<-erp(ConditionA[start_point:end_point,]) #condtion A erp for the window of interest
reference<-erp(ConditionB[start_point:end_point,])#conditon B erp for the window of interest
alignment<-dtw(query,reference,keep=TRUE)#Apply DTW
latency_differences<-dtw_diff(alignment$index1,alignment$index2)#Calculate all measurements from DTW path that are relevant for determining the latency difference
plot_latency_results(query,reference,alignment,latency_differences)#Visualising the results
####----------END OF 2nd EXAMPLE-----------------------------------------------------------------------------###
rm(list = setdiff(ls(), lsf.str()))

### 3rd  EXAMPLE == ERP example -- Realistic ----------------------------------------------------------------###
### This is an example of how to do a latency analysis between two ERP signals. 
### It is going to be the same as the 2nd example but this time the trials will be randomly divided to conditionA and condition B (and as a result they are not going to be exactly the same). Then condition B is going to be pushed in the time as in example 2. 
### Load ERP signal -- I have stored an array of EEG data from and example to an .RData file
load('EEG.RData')
### subj_eeg is a 2200x48 matrix, representing 731 trials with 2200 timepoints. These are trials (±50) from 15 subjects for the same condition.
# subj_erp<-erp(allsubjects)
# matplot(allsubjects,type='l',ylab='amplitude',xlab='timepoints') #visualise the trials
# plot(rec_time,subj_erp,type='l',ylab='amplitude',xlab='time') #visualise the ERP
available_trials<-ncol(allsubjects)
shuffletrials<-sample(available_trials,replace=FALSE)
#Firstly a simply example where the second condition is exactly the same as the first, just pushed by a certain amount
latency_effect<-50
ConditionA<-allsubjects[,shuffletrials[1:(available_trials/2)]]
ConditionB<-allsubjects[,shuffletrials[((available_trials/2)+1):available_trials]]
ConditionB<-apply(ConditionB,2,pushintime,howmuch=latency_effect)

### I am going to apply DTW just to the window of interest which is 300-700ms
start_point<-which(rec_time==300)
end_point<-which(rec_time==700)
### Arbitarily set one condition as query and the other as reference. 
query<-erp(ConditionA[start_point:end_point,]) #condtion A erp for the window of interest
reference<-erp(ConditionB[start_point:end_point,])#conditon B erp for the window of interest
alignment<-dtw(query,reference,keep=TRUE)#Apply DTW
latency_differences<-dtw_diff(alignment$index1,alignment$index2)#Calculate all measurements from DTW path that are relevant for determining the latency difference
plot_latency_results(query,reference,alignment,latency_differences)#Visualising the results
####----------END OF 3rd EXAMPLE-----------------------------------------------------------------------------###
