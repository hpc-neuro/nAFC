
function [AFC_hist, AFC_bins] = ...
      psycho_calcAFCHist(AFC_confidence)
  
  global NUM_CONFIDENCE_BINS

  AFC_mode = length(AFC_confidence);

  confidence_all = cell2mat(AFC_confidence);
  [ AFC_hist, AFC_bins ] = ...
      hist( confidence_all(:), NUM_CONFIDENCE_BINS );
  AFC_hist = zeros(AFC_mode, NUM_CONFIDENCE_BINS); 
  for i_AFC = 1 : AFC_mode
    AFC_tmp = squeeze( AFC_confidence{i_AFC} );
    AFC_hist(i_AFC, :) = ...
	hist(AFC_tmp(:), AFC_bins, 1.0);
  end %% i_AFC
  