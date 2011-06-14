
function [AFC_ROC, AFC_AUC] = ...
      psycho_calcAFCROC(AFC_cumsum)
  
  AFC_cumsum_tmp1 = AFC_cumsum(1, :);
  AFC_cumsum_tmp2 = mean(AFC_cumsum(2:end, :), 1);
  num_ROC_bins = length(AFC_cumsum_tmp1)+2;
  AFC_ROC = zeros(2, num_ROC_bins);
  AFC_ROC(1,:) = [0, fliplr(AFC_cumsum_tmp2), 1];
  AFC_ROC(2,:) = [0, fliplr(AFC_cumsum_tmp1), 1];
  AFC_AUC = trapz(AFC_ROC(1,:), AFC_ROC(2,:));

