function [fig_tmp] = ...
      psycho_plotAFCROC(AFC_ROC, ...
			AFC_str, ...
			fig_in, ...
			plot_num)
  
  if ~exist('AFC_str') || isempty(AFC_str) || nargin < 2
    AFC_str = [];
  end
  if ~exist('fig_in') || isempty(fig_in) || nargin < 3
    AFC_ROC_name = ['AFC_ROC(', AFC_str, ' )'];
    fig_tmp = figure('Name', AFC_ROC_name);
    axis( [0 1 0 1] );
    axis square
    axis "nolabel"
  else
    figure(fig_in);
    fig_tmp = fig_in;
  end
  if ~exist('plot_num') || isempty(plot_num) || nargin < 4
    plot_num = 1;
  end
  
  lh = plot(AFC_ROC(1,:), ...
	    AFC_ROC(2,:), ...
	    '-k');  
  set( lh, 'LineWidth', 2 );
  color_order = get(gca, 'colororder');
  set( lh, 'color', color_order(plot_num,:) );

  