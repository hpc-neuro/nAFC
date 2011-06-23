function [fig_tmp] = psycho_plotAFC(ROC_struct)

  fig_tmp = figure;
  axis( [0 1 0 1] );
  axis square
  fig_tmp = figure('Name', 'AFC_ROC_mean');
  hold on
  
  num_combinations = ROC_struct.num_combinations;
  legend_str = cell(num_combinations,1);
  for i_combination = 1 : num_combinations
    x_factor_subindex = zeros(1,ROC_struct.num_x_factors);
    i_residule = i_combination;
    for i_x_factor = ROC_struct.num_x_factors : -1 : 1
      i_x_index = 1 + ...
	  floor((i_residule-1) / ...
		ROC_struct.prod_x_factors(i_x_factor));
      x_factor_subindex(i_x_factor) = i_x_index;
      i_residule = ...
	  i_combination - ...
	  ( i_x_index - 1 ) * ROC_struct.prod_x_factors(i_x_factor);
    end  %% i_x_factor

    AFC_ROC = ...
	ROC_struct.AFC_ROC{i_combination};
    [fig_tmp] = ...
	psycho_plotAFCROC(AFC_ROC, ...
			  num2str(x_factor_subindex), ...
			  fig_tmp,
			  i_combination);
    legend_str{i_combination} = num2str(i_combination);

  end
  legend(legend_str, 'location', 'east');  