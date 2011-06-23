function [exp_struct] = psycho_comboAFCTrials(AFC_struct)

  %% initialize to 1st subject
  exp_struct = AFC_struct.exp_list(1);
  exp_struct.seed = 0;
  exp_struct.vision = [];
  exp_struct.age = [];
  exp_struct.gender = [];
  exp_struct.handedness = [];
  exp_struct.participation = [];
  exp_struct.familiarity = [];
  num_response_times = size(exp_struct.response_time,2);
  num_flips = size(exp_struct.StimulusOnsetTime,2);
  num_trials = length(exp_struct.trial_struct.confidence);
  response_time = repmat(NaN, num_trials*AFC_struct.num_IDs, num_response_times);
  VBLTimestamp = repmat(NaN, num_trials*AFC_struct.num_IDs, num_flips);
  StimulusOnsetTime = repmat(NaN, num_trials*AFC_struct.num_IDs, num_flips);
  FlipTimestamp = repmat(NaN, num_trials*AFC_struct.num_IDs, num_flips);
  target_ndx = repmat(NaN, num_trials*AFC_struct.num_IDs, 1);
  lft_ndx = repmat(NaN, num_trials*AFC_struct.num_IDs, 1);
  rgt_ndx = repmat(NaN, num_trials*AFC_struct.num_IDs, 1);
  choice = repmat(NaN, num_trials*AFC_struct.num_IDs, 1);
  confidence = repmat(NaN, num_trials*AFC_struct.num_IDs, 1);
  correct = repmat(NaN, num_trials*AFC_struct.num_IDs, 1);
  num_x_factors = size(exp_struct.trial_struct.x_factors,2);
  x_factors = repmat(NaN, num_trials*AFC_struct.num_IDs, num_x_factors);
  target_flag = repmat(NaN, num_trials*AFC_struct.num_IDs, 1);
  exp_struct.num_trials = num_trials*AFC_struct.num_IDs;
  for i_AFC_ID = 1 : AFC_struct.num_IDs
    AFC_trials = (1+(i_AFC_ID-1)*num_trials:i_AFC_ID*num_trials);
    response_time(AFC_trials,:) = ...
	AFC_struct.exp_list(i_AFC_ID).response_time;    
    VBLTimestamp(AFC_trials,:) = ...
	AFC_struct.exp_list(i_AFC_ID).VBLTimestamp;    
    StimulusOnsetTime(AFC_trials,:) = ...
	AFC_struct.exp_list(i_AFC_ID).StimulusOnsetTime;    
    FlipTimestamp(AFC_trials,:) = ...
	AFC_struct.exp_list(i_AFC_ID).FlipTimestamp;    
    target_ndx(AFC_trials,1) = ...
	AFC_struct.exp_list(i_AFC_ID).trial_struct.target_ndx;
    lft_ndx(AFC_trials,1) = ...
	AFC_struct.exp_list(i_AFC_ID).trial_struct.lft_ndx;
    rgt_ndx(AFC_trials,1) = ...
	AFC_struct.exp_list(i_AFC_ID).trial_struct.rgt_ndx;
    choice(AFC_trials,1) = ...
	AFC_struct.exp_list(i_AFC_ID).trial_struct.choice;
    confidence(AFC_trials,1) = ...
	AFC_struct.exp_list(i_AFC_ID).trial_struct.confidence;
    correct(AFC_trials,1) = ...
	AFC_struct.exp_list(i_AFC_ID).trial_struct.correct;
    x_factors(AFC_trials,:) = ...
	AFC_struct.exp_list(i_AFC_ID).trial_struct.x_factors;
    target_flag(AFC_trials,1) = ...
	AFC_struct.exp_list(i_AFC_ID).trial_struct.target_flag;
  end  %% i_AFC_ID
    
  exp_struct.num_response_times = response_time;
  exp_struct.VBLTimestamp = VBLTimestamp;
  exp_struct.StimulusOnsetTime = StimulusOnsetTime;
  exp_struct.FlipTimestamp = FlipTimestamp;
  exp_struct.trial_struct.target_ndx = target_ndx;
  exp_struct.trial_struct.lft_ndx = lft_ndx;
  exp_struct.trial_struct.rgt_ndx = rgt_ndx;
  exp_struct.trial_struct.choice = choice;
  exp_struct.trial_struct.confidence = confidence;
  exp_struct.trial_struct.correct = correct;
  exp_struct.trial_struct.x_factors = x_factors;
  exp_struct.trial_struct.target_flag = target_flag;

