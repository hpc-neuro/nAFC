
function [AFC_performance, AFC_error] = ...
      psycho_calcAFCCorrect(AFC_target_flag, AFC_choice, AFC_correct)
  
  global NUM_CONFIDENCE_BINS
  
  [AFC_mode] = ...
      length(AFC_target_flag);
  AFC_performance = zeros(1,AFC_mode+1);
  AFC_error = zeros(1,AFC_mode+1);
  for i_AFC = 1 : AFC_mode
    num_trials = length(AFC_target_flag{i_AFC});
    AFC_performance(i_AFC) = ...
      sum( squeeze(AFC_target_flag{i_AFC} == AFC_choice{i_AFC}) ) / ...
      ( num_trials + (num_trials == 0) );
    if ( AFC_performance(i_AFC) * num_trials ) ~= 0
      AFC_error(i_AFC) = ...
	sqrt(1 - AFC_performance(i_AFC) ) / ...
	sqrt( AFC_performance(i_AFC) * num_trials );
    else
      AFC_error(i_AFC) = 0;
    end
    
    if any( ( squeeze(AFC_target_flag{i_AFC} == AFC_choice{i_AFC}) ) ~= ...
	   AFC_correct{i_AFC} )
      warning('(AFC_target_flag{i_AFC} == AFC_choice{i_AFC}) ~= AFC_correct{i_AFC}');
    end 
  end

  
  AFC_performance(AFC_mode+1) = ...
      mean(AFC_performance(1:AFC_mode),2);
  if ( AFC_performance(i_AFC+1) * num_trials ) ~= 0
    AFC_error(i_AFC+1) = ...
	sqrt(1 - AFC_performance(i_AFC+1) ) / ...
	sqrt( AFC_performance(i_AFC+1) * num_trials );
  else
    AFC_error(i_AFC+1) = 0;
  end
 
