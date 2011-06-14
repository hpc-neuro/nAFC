function [fig_tmp] = ...
      psycho_plotAFCIdeal(AFC_ideal, ...
			  AFC_bins, ...
			  AFC_str)
  
  if ~exist("AFC_str") || isempty(AFC_str) || nargin < 3
    twoAFC_str = [];
  endif
  
  AFC_ideal_name = ['AFC ideal (', AFC_str, ' )'];
  fig_tmp = figure('Name', AFC_ideal_name);
  axis "nolabel"
  bh = bar( AFC_bins, AFC_ideal );  
  set( bh, 'EdgeColor', [0 1 0] );
  set( bh, 'FaceColor', [0 1 0] );
  set(gca, 'YLim', [0 1]);
