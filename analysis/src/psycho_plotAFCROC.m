function [fig_tmp] = ...
      psycho_plotAFCROC(AFC_ROC, ...
			AFC_str)
  
  if ~exist("AFC_str") || isempty(AFC_str) || nargin < 2
    AFC_str = [];
  endif
  
  AFC_ROC_name = ['AFC_ROC(', AFC_str, ' )'];
  fig_tmp = figure('Name', AFC_ROC_name);
  axis "nolabel"
  lh = plot(AFC_ROC(1,:), ...
	    AFC_ROC(2,:), ...
	    '-k');  
  set( lh, 'LineWidth', 2 );

  