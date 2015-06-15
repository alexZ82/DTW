## Calculate mode of a distribution x
## Returns the mode
mmode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

## Calculate all measurements needed to determine directionality and magnitude of the underlying latency differences
## The function takes as input the output from applying DTW
## query_indices: the matched indices for the query as returned by DTW
## reference_indices: the matched indices for the reference as returned by DTW 
## Returns: a list with: 
## direction: The latency directionality as a magnitude of the area under the warping path
## distances: A distribution of distances between the indices of the query and the reference
## dtw_medain: The median of the 'distances' distribution
## dtw_mode: The mode of the 'distances' distribution
dtw_diff<-function(query_indices,reference_indices){
  auc <- trapz(query_indices,reference_indices)
  aud <- trapz(c(1:tail(query_indices,1)),c(1:tail(reference_indices,1)))
  direction<-(aud-auc)/aud
  distances<-query_indices-reference_indices
  dtw_median<-median(distances)
  dtw_mode<-mmode(distances)
  dtw_resuls<-list(direction=direction,distances=distances,dtw_median=dtw_median,dtw_mode=dtw_mode)
  return (dtw_resuls) 
}

## Function that pushes a signal based on timepoints specified
## trial: singal to push
## howmuch: timepoints to push the signal
## Returns the pushed signal
pushintime<-function(trial,howmuch){
  signallength<-length(trial)
  ptrial <- (c(head(trial,howmuch),head(trial,signallength-howmuch)))
  return(ptrial)
}

## Fuction that returns the average (ERP) of a matrix representing EEG data
erp<-function(eeg){
  apply(eeg,1,mean)
}

## Ploting functions ----------------------------------------------------------------------------------------
plot_latency_results<-function(query, reference, alignment,latency_differences){
  
  par(mfrow=c(3,1))
  par(xpd=TRUE)
  plotdistances(latency_differences)
  plotpath(alignment,latency_differences)
  plotsignals(query,reference)
}

plotdistances<-function(latency_differences){
  direction<-round(latency_differences$direction,2)
  lgp <- ifelse(direction<0, "topright", "topleft")
  hist(latency_differences$distances,main = "Histogram of latency differences \nbetween the two time series",xlab = 'dinstances' )
  legend(lgp,paste0("mode = ",latency_differences$dtw_mode,"\nmedian = ",latency_differences$dtw_median),bty='n',text.col='red',cex=0.8)
}

plotsignals<-function(query,reference){
  plot(query,type='l',lty=1,main='Signals',lwd=2,ylab='')
  lines(reference,col='red',lty=2,lwd=2,ylab='')
  legend('bottomleft',lty=c(1,2),lwd=c(2,2),c('query','reference'),col=c('black','red'))
}

plotpath<-function(alignment,latency_differences){
  direction<-round(latency_differences$direction,2)
  directionality <- ifelse(direction<0, "earlier", "later")
  plot(alignment$index1,alignment$index2,type='l',col='red',main='DTW Path',xlab='Wraped Query Indices',ylab='Wraped Reference Indices',bty="n")
  legend('topleft',lty=c(1,1),c('diagonal','dtw path'),col=c('black','red'),bty = "n",cex=0.8)
  lines(c(1:tail(alignment$index1,1)),c(1:tail(alignment$index2,1)))
  legend('bottomright',c(paste0("dtw_diff = ",direction),paste0('query ',directionality,' \nthan reference')),text.col='blue',bty='n',cex=0.8)
}




