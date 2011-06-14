
function [fig_tmp] = ...
      psycho_plotAFCHist(AFC_hist, ...
			 AFC_bins, ...
			 AFC_str)

  [AFC_mode, num_hist_bins] = size(AFC_hist);
  if ~exist("AFC_str") || isempty(AFC_str) || nargin < 3
    twoAFC_str = [];
  endif

  AFC_hist_name = ['AFC hist( ', AFC_str, ' )'];
  fig_list = [];
  fig_tmp = figure('Name', AFC_hist_name);
  axis "nolabel"
  set(gca, "YTickLabel", []);
  for i_AFC = 1 : AFC_mode
    AFC_hist_tmp = ...
	squeeze(AFC_hist(i_AFC, :));
    if i_AFC == 0
      red_hist = 1;
      blue_hist = 0;
      bar_width = 0.8;
    else
      red_hist = 0;
      blue_hist = 1;
      bar_width = 0.6;
    end
    bh = bar(AFC_bins, ...
	     AFC_hist_tmp, ...
	     bar_width);
    set( bh, 'EdgeColor', [red_hist 0 blue_hist] );
    set( bh, 'FaceColor', [red_hist 0 blue_hist] );
    hold on
  end  %% i_AFC
